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
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var currentDate: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        
        return dateString
    }()
    
    private let scrollView = UIScrollView()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 26
    }
    
    // MARK: - 오늘의 운동 뷰
    private lazy var todayWorkOutView = generateTodayWorkOutView()

    // 타이틀
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
    
    // MARK: - 이번 주 평균 운동 시간 뷰
    private lazy var averageWorkOutTimeView = generateAverageWorkOutTimeView()
    
    // 이번 주 평균 운동 시간 차트
    private let barChartView = BarChartView()
    
    // 이번 주 운동 시간 변수
    var weekDays: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    var time: [Double] = [30, 60, 90, 120, 180, 240, 300]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNavigationBar()
        setupLayout()
        setupData()
        setupChart(dataPoints: weekDays, values: time)
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
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(26)
            $0.horizontalEdges.equalToSuperview().inset(20)
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
            $0.layer.shadowRadius = 5.0
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
            $0.layer.shadowRadius = 5.0
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(169)
        }
        
        /// 타이틀
        let titleLabel = UILabel().then {
            $0.text = "LAURA LEE님의 목표 달성률"
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = .black
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        /// 편집 버튼
        let editButton = UIButton().then {
            $0.setTitle(":", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        }
        
        view.addSubview(editButton)
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.greaterThanOrEqualTo(titleLabel).offset(10)
            $0.trailing.equalToSuperview().inset(5)
        }
        
        let descriptionLabel = UILabel().then {
            $0.text = "LAURA LEE님!\n목표 운동시간까지 2시간 남았습니다. :)"
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = UIColor.init(named: "mainColor")
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        let progressView = UIProgressView().then {
            $0.progress = 0.7
            $0.trackTintColor = .init(hexFromString: "D9D9D9")
            $0.progressTintColor = UIColor.init(named: "mainColor")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 5.0
        }
        
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(15)
        }
        
        let progressLabel = UILabel().then {
            $0.text = "0%"
            $0.font = .systemFont(ofSize: 12, weight: .semibold)
        }
        
        view.addSubview(progressLabel)
        
        progressLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
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
            $0.layer.shadowRadius = 5.0
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(286)
        }
        
        let attributeString = NSMutableAttributedString(string: "이번 한 주의 운동 시간은\n평균 4.5시간 입니다.")
        
        ["평균", "시간 입니다."].forEach {
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: ("이번 한 주의 운동 시간은\n평균 4.5시간 입니다." as NSString).range(of: $0))
        }
        
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20.0, weight: .bold), range: ("이번 한 주의 운동 시간은\n평균 4.5시간 입니다." as NSString).range(of: "4.5"))
        
        /// 타이틀
        let titleLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.attributedText = attributeString
            $0.textColor = .white
            $0.numberOfLines = 2
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        view.addSubview(barChartView)
        
        barChartView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        return view
    }
    
    // MARK: Data
    private func setupData() {
        repository.$records
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                guard let self = self else { return }
                if let totalWorkoutTime = data[self.currentDate]?.totalWorkoutTime {
                    self.todayWorkOutTimeLabel.attributedText = self.getTodayWorkoutTime(totalWorkoutTime)
                }
            })
            .store(in: &self.cancellables)
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
        chartDataSet.valueTextColor = .clear
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartData.barWidth = Double(0.5)
        // 데이터 없을 때 처리
//        barChartView.noDataText = "데이터가 없습니다."
//        barChartView.noDataFont = .systemFont(ofSize: 20)
//        barChartView.noDataTextColor = .white
        
        // 차트 데이터
        barChartView.data = chartData
        
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
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.labelTextColor = .white
        barChartView.leftAxis.axisMaximum = 300
//        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisLineColor = .white
        
        barChartView.leftAxis.valueFormatter = LeftAxisValueFormatter()
        
        // right축
        barChartView.rightAxis.enabled = false
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 3.0)
        
        // 범례
        barChartView.legend.enabled = false
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
