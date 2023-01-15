//
//  CalendarViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/12.
//

import UIKit
import Then
import SnapKit
import FSCalendar

class CalendarViewController: BaseViewController {
    private let viewModel = WorkOutRecordViewModel.shared

    private var workOutRecordList: [WorkOutRecord]?
    
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
        $0.appearance.todayColor = UIColor.init(named: "mainColor")
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
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bindWorkOutRecordViewModelToController = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.workOutRecordList = self.viewModel.getAll()
                self.collectionView.reloadData()
            }
        }
        
        setupViews()
        setupData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        weeklyBottomBorder.snp.updateConstraints {
            $0.top.equalTo(calendarView.calendarWeekdayView.frame.maxY)
        }
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
            $0.bottom.equalTo(noRecordImgView.snp.top).offset(-20)
        }
        
        noRecordImgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
        // MARK: 운동 기록 내역 > AutoLayout
        collectionView.snp.makeConstraints {
            $0.height.equalTo(300)
        }
    }
    
    // MARK: Data Set
    private func setupData() {
        for _ in 1...2 {
            viewModel.insert(WorkOutRecord(idx: 0, emoji: "🏃‍♂️", workOutName: "러닝", workOutTime: 60))
            viewModel.insert(WorkOutRecord(idx: 1, emoji: "🏋️‍♀️", workOutName: "웨이트", workOutTime: 50))
            viewModel.insert(WorkOutRecord(idx: 2, emoji: "🧘‍♂️", workOutName: "요가", workOutTime: 40))
            viewModel.insert(WorkOutRecord(idx: 3, emoji: "🏊‍♀️", workOutName: "수영", workOutTime: 50))
            viewModel.insert(WorkOutRecord(idx: 4, emoji: "🤸‍♂️", workOutName: "스트레칭", workOutTime: 20))
        }
        
        collectionView.isHidden = false
    }
    
    // MARK: Action
    /// 달력 > 이전 / 다음 버튼 누를 시 페이지 이동
    @objc private func moveCurrentPage(_ sender: UIButton) {
        let calendar = Calendar(identifier: .gregorian)
        let currentDay = calendarView.currentPage
        
        var components = DateComponents()
        components.month = sender.tag
        
        let nextDay = calendar.date(byAdding: components, to: currentDay)!
        calendarView.setCurrentPage(nextDay, animated: true)
    }
}

// MARK: - FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 선택된 날짜 배경색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.init(named: "mainColor")
    }

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let timeLabel = UILabel(frame: CGRect(x: 0, y: 35, width: cell.bounds.width, height: 10))
        timeLabel.font = .systemFont(ofSize: 7)
        timeLabel.text = "02:15"
        timeLabel.textAlignment = .center
        timeLabel.textColor = UIColor.init(named: "mainColor")
        cell.addSubview(timeLabel)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workOutRecordList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordListCollectionViewCell.identifier, for: indexPath) as! RecordListCollectionViewCell
        cell.delegate = self

        if let workOutRecordList = workOutRecordList {
            let data = workOutRecordList[indexPath.item]
            cell.updateUI(data: data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecordListCollectionViewHeader.identifier, for: indexPath)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - RecordListCollectionViewCellDelegate
extension CalendarViewController: RecordListCollectionViewCellDelegate {
    func showMoreMenu() {
        let actionSheet = Helper().actionSheet(delete: true)
        self.present(actionSheet, animated: true)
    }
    
    func updateConstraints() {
        collectionView.snp.updateConstraints {
            $0.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height + 30)
        }
        
        view.layoutIfNeeded()
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



