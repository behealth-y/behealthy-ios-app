//
//  CalendarViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/12.
//

import UIKit
import Foundation
import Then
import SnapKit
import FSCalendar
import Combine

class CalendarViewController: BaseViewController {
    private let viewModel = CalendarViewModel()
    private let repository = RecordsRepository.shared

    private var cancellables: Set<AnyCancellable> = .init()
    
    private var currentDate: String = {
        Helper().getToday()
    }()
    
    private var currentDateTotalTime: Int = 0
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    // MARK: - 달력
    lazy var calendarView = FSCalendar().then {
        $0.delegate = self
        $0.dataSource = self
        
        $0.locale = Locale(identifier: "ko_KR")
        
        // 양 옆 년도, 월 지우기
        $0.appearance.headerMinimumDissolvedAlpha = 0
        
        $0.appearance.headerDateFormat = "YYYY년 MM월"
        $0.appearance.headerTitleColor = UIColor.init(hexFromString: "2E2E2E")
        $0.appearance.headerTitleAlignment = .center
        $0.appearance.headerTitleFont = .systemFont(ofSize: 14)
        
        $0.appearance.weekdayTextColor = UIColor.init(hexFromString: "#2E2E2E")
        $0.appearance.weekdayFont = .systemFont(ofSize: 10)
        
        $0.placeholderType = .fillHeadTail
        
        $0.appearance.titlePlaceholderColor = .border
        $0.appearance.titleDefaultColor = UIColor.init(hexFromString: "2E2E2E")
        $0.appearance.titleFont = .systemFont(ofSize: 12)
        
        $0.appearance.todaySelectionColor = .white
        $0.appearance.todayColor = UIColor.init(hexFromString: "#2E2E2E")
        $0.appearance.titleTodayColor = .white
    }
    
    // 이전 달 이동 버튼
    private lazy var prevMonthButton = UIButton().then {
        $0.setImage(UIImage(named: "prev"), for: .normal)
        $0.tintColor = .black
        $0.tag = -1
        $0.addTarget(self, action: #selector(moveCurrentPage), for: .touchUpInside)
    }
    
    // 다음 달 이동 버튼
    private lazy var nextMonthButton = UIButton().then {
        $0.setImage(UIImage(named: "next"), for: .normal)
        $0.tintColor = .black
        $0.tag = 1
        $0.addTarget(self, action: #selector(moveCurrentPage), for: .touchUpInside)
    }
    
    private let weeklyBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    // MARK: - 운동 기록 내역
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    /// collectionView 변수 초기화
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout).then {
        $0.isHidden = true
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        
        $0.isScrollEnabled = false
        
        $0.register(UINib(nibName: RecordListCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecordListCollectionViewCell.identifier)
        $0.register(UINib(nibName: RecordListCollectionViewHeader.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecordListCollectionViewHeader.identifier)
    }
    
    // MARK: - 운동 기록 없을 때
    private let noRecordView = UIView().then {
        $0.isHidden = true
    }
    
    private let noRecordLabel = UILabel().then {
        $0.text = "저장된 운동 기록이 없어요..\n지금 운동 추가하러 가볼까요?"
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .border
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let noRecordImgView = UIImageView().then {
        $0.image = UIImage(named: "arrow_down")
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupData()
        
        viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        weeklyBottomBorder.snp.updateConstraints {
            $0.top.equalTo(calendarView.calendarWeekdayView.frame.maxY)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        self.calendarView.collectionView.reloadData()
    }
}

// MARK: - Extension
extension CalendarViewController {
    // MARK: View
    /// 네비게이션 바 설정
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
//        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.init(named: "mainColor")!]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.tintColor = UIColor.init(named: "mainColor")
        
        navigationItem.title = "BE HEALTHY"
    }
    
    /// 뷰 설정
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        [stackView, prevMonthButton, nextMonthButton, weeklyBottomBorder].forEach {
            scrollView.addSubview($0)
        }
        
        [calendarView, noRecordView, collectionView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [noRecordLabel, noRecordImgView].forEach {
            noRecordView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        // MARK: 달력 > AutoLayout
        calendarView.snp.makeConstraints {
            $0.height.equalTo(calendarView.snp.width).multipliedBy(0.84 / 1.0)
        }
        
        prevMonthButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(calendarView.preferredHeaderHeight / 2)
            $0.leading.equalToSuperview().inset(18)
        }
        
        nextMonthButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(calendarView.preferredHeaderHeight / 2)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        weeklyBottomBorder.snp.makeConstraints {
            $0.top.equalTo(calendarView.calendarWeekdayView.bounds.maxY)
            $0.height.equalTo(0.5)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        // MARK: 운동 기록 없을 때 > AutoLayout
        noRecordView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noRecordLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        noRecordImgView.snp.makeConstraints {
            $0.top.equalTo(noRecordLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.centerX.equalToSuperview()
        }
        
        // MARK: 운동 기록 내역 > AutoLayout
        collectionView.snp.makeConstraints {
            $0.height.equalTo(300)
        }
    }
    
    // MARK: Data Set
    private func setupData() {
        collectionView.isHidden = false
        
        repository.$records
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] data in
                guard let self = self else { return }
                
                // 현재 선택된 날짜의 운동 시간과 저장된 운동 시간이 다를 경우 처리
                let _ = data.filter({ $0.key == self.currentDate }).map({
                    self.currentDateTotalTime = $0.value.totalWorkoutTime
                    
                    if self.currentDateTotalTime > 0 {
                        self.noRecordView.isHidden = true
                        self.collectionView.isHidden = false
                    } else {
                        self.collectionView.isHidden = true
                        self.noRecordView.isHidden = false
                    }
                })
                
                data.forEach {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                      
                    if let date = dateFormatter.date(from: $0.key), let cell = self.calendarView.cell(for: date, at: .current) {
                        if $0.value.totalWorkoutTime > 0 {
                            cell.eventIndicator.color = UIColor.init(named: "mainColor")!
                            cell.eventIndicator.numberOfEvents = 1
                            cell.eventIndicator.isHidden = false
                        } else {
                            cell.eventIndicator.numberOfEvents = 0
                            cell.eventIndicator.isHidden = true
                        }
                    }
                }
                
                self.collectionView.reloadData()
            })
            .store(in: &self.cancellables)
        
        let currentPageDate = calendarView.currentPage
        let year = Calendar.current.component(.year, from: currentPageDate)
        let month = Calendar.current.component(.month, from: currentPageDate)
        
        viewModel.get(year: year, month: month)
        viewModel.get(date: currentDate)
    }
    
    // MARK: Actions
    /// 달력 > 이전 / 다음 버튼 누를 시 페이지 이동
    @objc private func moveCurrentPage(_ sender: UIButton) {
        let calendar = Calendar(identifier: .gregorian)
        let currentDay = calendarView.currentPage
        
        var components = DateComponents()
        components.month = sender.tag
        
        let nextDay = calendar.date(byAdding: components, to: currentDay)!
        calendarView.setCurrentPage(nextDay, animated: true)
    }
    
    /// 운동 기록 내역 > 셀 > 더보기 > 편집 버튼 누를 시
    private func presentWorkoutForm(_ idx: Int) {
        print(#function)
        
        let vc = AddWorkoutViewController(idx: idx)
        vc.sheetPresentationController?.prefersGrabberVisible = true
        self.present(vc, animated: true)
    }
    
    /// 운동 기록 내역 > 셀 > 더보기 > 삭제 버튼 누를 시
    private func deleteWorkoutRecord(_ idx: Int) {
        print(#function)
        viewModel.delete(for: currentDate, idx: idx)
    }
}

// MARK: - FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 선택된 날짜 배경색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        return UIColor.init(named: "mainColor")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return UIColor.init(hexFromString: "2E2E2E")
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.init(named: "mainColor")!]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [UIColor.init(named: "mainColor")!]
    }
    
    // TODO: 커스텀 Cell 구현
//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd"
//        let currentDate = dateFormatter.string(from: date)
//
//        let timeLabel = UILabel(frame: CGRect(x: 0, y: cell.frame.height - 5, width: cell.bounds.width, height: 10))
//
//        if let record = repository.get(for: currentDate) {
//            timeLabel.font = .systemFont(ofSize: 7)
//            timeLabel.text = "\(record.totalWorkoutTime)분"
//            timeLabel.textAlignment = .center
//            timeLabel.textColor = UIColor.init(named: "mainColor")
//            cell.addSubview(timeLabel)
//        }
//    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        print("\(#function) ::: \(date)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let record = repository.get(for: dateString), record.totalWorkoutTime > 0 {
            return 1
        }
        
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        currentDate = dateString
        viewModel.get(date: dateString)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        let year = Calendar.current.component(.year, from: currentPageDate)
        let month = Calendar.current.component(.month, from: currentPageDate)
        
        viewModel.get(year: year, month: month)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repository.get(for: currentDate)?.workOutRecords.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordListCollectionViewCell.identifier, for: indexPath) as! RecordListCollectionViewCell
        cell.delegate = self

        let data = repository.get(for: currentDate, at: indexPath.item)
        cell.updateUI(data: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecordListCollectionViewHeader.identifier, for: indexPath) as! RecordListCollectionViewHeader
            
            headerView.updateUI(date: currentDate, time: currentDateTotalTime)
            
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(#function) :: \(indexPath.item)")
    }
}

// MARK: - RecordListCollectionViewCellDelegate
extension CalendarViewController: RecordListCollectionViewCellDelegate {
    func showMoreMenu(_ idx: Int) {
        print("\(#function) ::: \(idx)")
        let actionSheet = Helper().actionSheet(delete: true) { [weak self] action in
            switch action {
            case .edit:
                self?.presentWorkoutForm(idx)
            case .delete:
                self?.deleteWorkoutRecord(idx)
            }
        }
        self.present(actionSheet, animated: true)
    }
    
    func updateConstraints() {
        collectionView.snp.updateConstraints {
            $0.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height + 30)
        }
        
        view.layoutIfNeeded()
    }
}

// MARK: - CalendarViewModelDelegate
extension CalendarViewController: CalendarViewModelDelegate {
    func deleteWorkoutRecordSuccess() {
        print(#function)
    }
    
    func deleteWorkoutRecordFail() {
        print(#function)
    }
    
    func getForYearAndMonthSuccess() {
        print(#function)
        
        self.calendarView.collectionView.reloadData()
    }
    
    func getForYearAndMonthFail() {
        print(#function)
    }
    
    func getForDateSuccess(date: String) {
        
        if let record = repository.get(for: date), record.workOutRecords.count > 0 {
            collectionView.isHidden = false
            noRecordView.isHidden = true
        } else {
            collectionView.isHidden = true
            noRecordView.isHidden = false
        }
    }
    
    func getForDateFail() {
        print(#function)
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct CalendarViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        CalendarViewController()
    }
}

struct CalendarViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        CalendarViewControllerPresentable()
    }
}

#endif



