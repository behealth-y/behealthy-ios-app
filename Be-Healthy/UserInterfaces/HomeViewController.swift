//
//  HomeViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import Then
import SnapKit
import Charts
import Combine

class HomeViewController: UIViewController {
    private let repository = RecordsRepository.shared
    private let goalTimeSubject = GoalTimeSubject.shared
    private var userName = UserDefaults.standard.string(forKey: "userName") ?? "회원"
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    // 오늘 날짜
    private var currentDate: String = {
        Helper().getToday()
    }()
    
    // 오늘 총 운동 시간
    private var totalWorkoutTime: Int? {
        didSet {
            getGoalAchieveRate(totalWorkoutTime ?? 0)
        }
    }
    
    // 00시 지나면 날짜 초기화 용
    private var timer: Timer?
    
    private let scrollView = UIScrollView()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 30
    }
    
    // MARK: - 오늘의 운동 뷰
    private lazy var todayWorkOutView = generateTodayWorkOutView()

    private let todayWorkOutTitleLabel = UILabel().then {
        $0.text = "오늘의 운동🏃‍♂️"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor.init(named: "mainColor")
    }
    
    // 운동 시간
    private lazy var todayWorkOutTimeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 38.0, weight: .bold)
        $0.attributedText = getTodayWorkoutTime(0)
    }
    
    // MARK: - 하루 운동 목표 달성률 뷰
    private lazy var goalAchieveRateView = generateGoalAchieveRateView()
    
    private lazy var goalAchieveRateTitleLabel = UILabel().then {
        $0.text = "\(userName)님의 목표 달성률📈"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .black
    }
            
    private lazy var goalAchieveRateDescriptionLabel = UILabel().then {
        $0.text = "\(userName)님!\n목표 운동시간까지 \(self.goalTimeSubject.goalTime.minuteToTime()) 남았습니다. :)"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor.init(named: "mainColor")
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private lazy var goalAchieveRateEditButton = UIButton().then {
        $0.setTitle(":", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
    }

    private let goalAchieveRateProgressView = UIProgressView().then {
        $0.progress = 0.0
        $0.trackTintColor = .init(hexFromString: "D9D9D9")
        $0.progressTintColor = UIColor.init(named: "mainColor")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5.0
    }
    
    private let goalAchieveRateProgressLabel = UILabel().then {
        $0.text = "0%"
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    // MARK: - 이번 주 평균 운동 시간 뷰
    private lazy var averageWorkOutTimeView = generateAverageWorkOutTimeView()
            
    private lazy var averageWorkOutTimeTitleLabel = UILabel().then {
        let attributeString = getAverageWorkoutTimeTitle(0)
        
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.attributedText = attributeString
        $0.textColor = .white
        $0.numberOfLines = 2
    }
    
    // 이번 주 평균 운동 시간 차트
    private let barChartView = BarChartView()
    
    // 이번 주 운동 시간 변수
    var weekDays: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    var time: [Double] = [11, 23, 45, 78, 0, 235, 102]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationBar()
        setupViews()
        setupData()
        setupTimer()
        setupChart(dataPoints: [], values: [])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "회원"
        
        goalAchieveRateTitleLabel.text = "\(userName)님의 목표 달성률📈"
        
        let goalTime = self.goalTimeSubject.goalTime
        let time = self.totalWorkoutTime ?? 0
        let betweenTime = goalTime - time
        
        if betweenTime > 0 {
            goalAchieveRateDescriptionLabel.text = "\(userName)님!\n목표 운동시간까지 \(betweenTime.minuteToTime()) 남았습니다. :)"
        }
    }
}

// MARK: - Extensions
extension HomeViewController {
    // MARK: View
    /// 네비게이션 바 설정
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.init(named: "mainColor")!]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.tintColor = UIColor.init(named: "mainColor")
        
        navigationItem.title = "BE HEALTHY"
    }
    
    /// 레이아웃 설정
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(26)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        [todayWorkOutView, goalAchieveRateView, averageWorkOutTimeView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    /// 오늘의 운동 뷰
    private func generateTodayWorkOutView() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = .white
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 10
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 4, height: 4)
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowRadius = 4.0
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(139)
        }
        
        [todayWorkOutTitleLabel, todayWorkOutTimeLabel].forEach {
            view.addSubview($0)
        }
        
        todayWorkOutTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        todayWorkOutTimeLabel.snp.makeConstraints {
            $0.top.equalTo(todayWorkOutTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().inset(20)
        }
        
        return view
    }
    
    /// 목표 달성률
    private func generateGoalAchieveRateView() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = .white
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 10
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 4, height: 4)
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowRadius = 4.0
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(169)
        }
        
        [goalAchieveRateTitleLabel, goalAchieveRateEditButton, goalAchieveRateDescriptionLabel, goalAchieveRateProgressView, goalAchieveRateProgressLabel].forEach {
            view.addSubview($0)
        }
        
        goalAchieveRateTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        goalAchieveRateEditButton.snp.makeConstraints {
            $0.centerY.equalTo(goalAchieveRateTitleLabel)
            $0.leading.greaterThanOrEqualTo(goalAchieveRateTitleLabel).offset(10)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        goalAchieveRateDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(goalAchieveRateTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        goalAchieveRateProgressView.snp.makeConstraints {
            $0.top.equalTo(goalAchieveRateDescriptionLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.height.equalTo(15)
        }
        
        goalAchieveRateProgressLabel.snp.makeConstraints {
            $0.top.equalTo(goalAchieveRateProgressView.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().inset(10)
        }
        
        return view
    }
    
    /// 주간 운동 시간 통계
    private func generateAverageWorkOutTimeView() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = UIColor.init(named: "mainColor")
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 10
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 4, height: 4)
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowRadius = 4.0
        }
        
//        view.snp.makeConstraints {
//            $0.height.equalTo(286)
//        }
        
        [averageWorkOutTimeTitleLabel, barChartView].forEach {
            view.addSubview($0)
        }
        
        averageWorkOutTimeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        barChartView.snp.makeConstraints {
            $0.top.equalTo(averageWorkOutTimeTitleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        return view
    }
    
    // MARK: Data
    private func setupData() {
        WorkoutService().getWorkoutStats { [weak self] data in
            if let statusCode = data.statusCode {
                switch statusCode {
                case 200:
                    if let stat = data.result {
                        self?.getWorkoutStatsSuccess(stat)
                    }
                default:
                    self?.getWorkoutStatsFail()
                }
            }
        }
        
        // 운동 기록
        repository.$records
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                guard let self = self else { return }
                if let totalWorkoutTime = data[self.currentDate]?.totalWorkoutTime {
                    self.todayWorkOutTimeLabel.attributedText = self.getTodayWorkoutTime(totalWorkoutTime)
                    
                    self.totalWorkoutTime = totalWorkoutTime
                }
                
                self.getAverageWorkoutTime(workoutTimes: nil)
            })
            .store(in: &self.cancellables)
        
        // 목표 운동 시간
        goalTimeSubject.$goalTime
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.getGoalAchieveRate(self.totalWorkoutTime ?? 0)
            })
            .store(in: &self.cancellables)
    }
    
    /// 캘린더 reload
    @objc private func runCode() {
        timer?.invalidate()
        
        let currentDate = Helper().getToday()
        
        if self.currentDate != currentDate {
            self.currentDate = currentDate
            
            self.repository.setWorkoutTime(date: self.currentDate)
            
            setupTimer()
        }
    }
    
    private func setupTimer() {
        print(#function)
        let calendar = Calendar.current
        
        let now = Date()
        
        let nextDate = calendar.date(byAdding: .day, value: 1, to: now)!
        let date = calendar.date(bySettingHour: 00, minute: 00, second: 0, of: nextDate)!
        
        self.timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(runCode), userInfo: nil, repeats: false)
        
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    
    // MARK: Actions
    /// 목표 달성률 편집 버튼 클릭 시
    @objc private func didTapEditButton(sender: UIButton) {
        let actionSheet = Helper().actionSheet() { [weak self] _ in
            self?.moveGoalTimeSettingView()
        }
        
        present(actionSheet, animated: true)
    }
    
    /// 목표 운동 시간 설정 화면 이동
    private func moveGoalTimeSettingView() {
        let vc = GoalTimeSettingView(openProcess: .home)
        vc.hidesBottomBarWhenPushed = true
        
        self.present(vc, animated: true)
    }
    
    // MARK: Helpers
    private func getTodayWorkoutTime(_ time: Int) -> NSMutableAttributedString {
        let timeString = time.minuteToTime()
        let attributeString = NSMutableAttributedString(string: timeString)
        
        ["시간", "분"].forEach {
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22.0, weight: .semibold), range: (timeString as NSString).range(of: $0))
        }
        
        return attributeString
    }
    
    private func getGoalAchieveRate(_ time: Int) {
        let goalTime = goalTimeSubject.goalTime
        
        let betweenTime = goalTime - time
        
        if betweenTime > 0 {
            let goalAchieveRate = Double(time) / Double(goalTime)
            let goalAcieveRatePercent = Int(goalAchieveRate * 100)
            
            let userName = UserDefaults.standard.string(forKey: "userName") ?? "회원"
            
            goalAchieveRateDescriptionLabel.text = "\(userName)님!\n목표 운동시간까지 \(betweenTime.minuteToTime()) 남았습니다. :)"
            goalAchieveRateProgressView.progress = Float(goalAchieveRate)
            goalAchieveRateProgressLabel.text = "\(goalAcieveRatePercent)%"
        } else {
            goalAchieveRateDescriptionLabel.text = "축하드려요! 일일 목표 시간을 달성하셨군요. :)"
            goalAchieveRateProgressView.progress = 1.0
            goalAchieveRateProgressLabel.text = "100%"
        }
    }
    
    private func getAverageWorkoutTime(workoutTimes: [WorkoutTimesIntCurrentWeek]?) {
        let dates = getThisWeekDates()
        let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
        var times: [Double] = [0, 0, 0, 0, 0, 0, 0]
    
        var workoutTimesDict: [String: Double] = [:]
        
        if let workoutTimes = workoutTimes {
            for workoutTime in workoutTimes {
                workoutTimesDict[workoutTime.date] = Double(workoutTime.workoutTime)
                
                repository.setWorkoutTime(date: workoutTime.date, time: workoutTime.workoutTime)
            }
        } else {
            dates.forEach { date in
                if let record = repository.records[date] {
                    workoutTimesDict[date] = Double(record.totalWorkoutTime)
                }
            }
        }

        for i in 0..<7 {
            let date = dates[i]
            
            // 해당 날짜에 대한 workoutTime 값을 가져옴
            let workoutTime = workoutTimesDict[date] ?? 0
            
            // times 배열에 추가
            times[i] = workoutTime
        }
        
        let averageWorkoutTimeCount = Double(times.filter({ $0 > 0 }).count)
        let averageWorkoutTime = averageWorkoutTimeCount > 0 ? times.reduce(0) { $0 + $1 } / averageWorkoutTimeCount : 0
        let averageWorkoutTimeTitle = getAverageWorkoutTimeTitle(Int(averageWorkoutTime))
        
        averageWorkOutTimeTitleLabel.attributedText = averageWorkoutTimeTitle
        
        setupChart(dataPoints: weekdays, values: times)
    }
    
    private func getAverageWorkoutTimeTitle(_ time: Int) -> NSMutableAttributedString{
        let attributeString = NSMutableAttributedString(string: "이번 한 주의 운동 시간은\n평균 \(time.minuteToTime()) 입니다.")
         
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20.0, weight: .bold), range: ("이번 한 주의 운동 시간은\n평균 \(time.minuteToTime()) 입니다." as NSString).range(of: "\(time.minuteToTime())"))
        
        ["평균", "시간 ", "분", "입니다."].forEach {
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: ("이번 한 주의 운동 시간은\n평균 \(time.minuteToTime()) 입니다." as NSString).range(of: $0))
        }
        
        return attributeString
    }
    
    /// 이번주 날짜 구하기
    func getThisWeekDates() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간대
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = formatter.timeZone
        calendar.locale = Locale(identifier: "ko_KR")
        
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysOffset = (weekday == 1 ? 6 : weekday - 2)
        let startOfWeek = calendar.date(byAdding: .day, value: -daysOffset, to: today)!
        
        var weekdays: [String] = []
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: i, to: startOfWeek)!
            let dateString = formatter.string(from: date)
            weekdays.append(dateString)
        }
        
        return weekdays
    }
    
    /// 이번 주 평균 운동 시간 차트 설정
    private func setupChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0 ..< dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "운동 시간(분)")
        
        chartDataSet.colors = [.white]
        chartDataSet.highlightEnabled = false
        chartDataSet.valueTextColor = .white
        chartDataSet.valueFormatter = MinuteValueFormatter()
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartData.barWidth = Double(0.5)
        
        // 차트 데이터
        if !dataEntries.isEmpty {
            barChartView.data = chartData
        } else {
            print("No Data !!!")
        }
        
        // 데이터 없을 때 처리
        barChartView.noDataText = "운동 기록 데이터가 없습니다.\n지금 추가하러 가볼까요?"
        barChartView.noDataFont = .systemFont(ofSize: 16)
        barChartView.noDataTextColor = .white
        barChartView.noDataTextAlignment = .center
        
        // 차트 확대 방지
        barChartView.doubleTapToZoomEnabled = false
        
        // x축
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekDays)
        barChartView.xAxis.setLabelCount(dataPoints.count, force: false)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelTextColor = .white
        barChartView.xAxis.labelFont = .boldSystemFont(ofSize: 16)
        barChartView.xAxis.axisLineColor = .white
        
        // left축
//        let ll = ChartLimitLine(limit: 60.0, label: "목표")
//        barChartView.leftAxis.addLimitLine(ll)
//        barChartView.leftAxis.limitLines.map({ $0.lineColor = .white })
        
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.labelTextColor = .white
//        barChartView.leftAxis.axisMaximum = 300
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisLineColor = .white
        
        barChartView.leftAxis.valueFormatter = LeftAxisValueFormatter()
        
        // right축
        barChartView.rightAxis.enabled = false
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 3.0)
        
        // 범례
        barChartView.legend.enabled = false
    }
    
    // MARK: 운동 통계
    private func getWorkoutStatsSuccess(_ stat: WorkoutStatsResultData) {
        let goalTime = (stat.workoutGoal.hour * 60) + stat.workoutGoal.minute
        goalTimeSubject.setGoalTime(goalTime)
        
        self.totalWorkoutTime = stat.todayWorkoutTime
        
        self.todayWorkOutTimeLabel.attributedText = self.getTodayWorkoutTime(totalWorkoutTime!)
        
        getAverageWorkoutTime(workoutTimes: stat.workoutTimesInCurrentWeek)
    }
    
    private func getWorkoutStatsFail() {
        print(#function)
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct HomeViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        HomeViewController()
    }
}

struct HomeViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        HomeViewControllerPresentable()
    }
}

#endif
