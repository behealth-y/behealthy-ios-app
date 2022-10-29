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

class CalendarViewController: UIViewController {
    let viewModel = WorkOutRecordViewModel.shared
    var workOutRecordList: [WorkOutRecord]?
    
    /// scrollView 변수 초기화
    lazy var scrollView = UIScrollView()
    
    let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    /// collectionView 변수 초기화
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        
        $0.register(UINib(nibName: TopThreeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TopThreeCollectionViewCell.identifier)
        $0.register(UINib(nibName: RecordListCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecordListCollectionViewCell.identifier)
        $0.register(UINib(nibName: RecordListCollectionViewHeader.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecordListCollectionViewHeader.identifier)
    }
    
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
        
        $0.appearance.weekdayTextColor = UIColor.init(named: "mainColor")
        
        $0.placeholderType = .fillHeadTail
        
        $0.appearance.titlePlaceholderColor = UIColor.init(hexFromString: "B0B0B0")
        $0.appearance.titleDefaultColor = UIColor.init(hexFromString: "2E2E2E")
        $0.appearance.titleFont = .systemFont(ofSize: 12)
        
        $0.appearance.todaySelectionColor = .white
        $0.appearance.todayColor = .white
        $0.appearance.titleTodayColor = UIColor.init(hexFromString: "2E2E2E")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bindWorkOutRecordViewModelToController = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.workOutRecordList = self.viewModel.getAll()
                self.collectionView.reloadData()
            }
        }
        
//        setupNavigationBar()
        setupLayout()
        setupData()
    }
}

// MARK: - 레이아웃 설정 관련
extension CalendarViewController {
    /// 네비게이션 바 설정
    fileprivate func setupNavigationBar() {
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
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        let contentView = UIView()
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        contentView.addSubview(calendarView)
        
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.height.equalTo(calendarView.snp.width).multipliedBy(0.84 / 1.0)
        }
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalTo(scrollView.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalToSuperview()
        }
    }
}

extension CalendarViewController {
    fileprivate func setupData() {
        for _ in 1...10 {
            viewModel.insert(WorkOutRecord(idx: 0, emoji: "🏃‍♂️", workOutName: "러닝", workOutTime: 35))
        }
    }
}

// MARK: - FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 선택된 날짜 배경색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.init(named: "mainColor")
    }

//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//        let labelMy2 = UILabel(frame: CGRect(x: 0, y: 35, width: cell.bounds.width, height: 10))
//        labelMy2.font = .systemFont(ofSize: 8)
//        labelMy2.text = "1시간 10분"
//        labelMy2.textAlignment = .center
//        labelMy2.textColor = UIColor.init(named: "mainColor")
//        cell.addSubview(labelMy2)
//    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return workOutRecordList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopThreeCollectionViewCell.identifier, for: indexPath) as! TopThreeCollectionViewCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordListCollectionViewCell.identifier, for: indexPath) as! RecordListCollectionViewCell
            cell.delegate = self

            if let workOutRecordList = workOutRecordList {
                let data = workOutRecordList[indexPath.item]
                cell.updateUI(data: data)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecordListCollectionViewHeader.identifier, for: indexPath)
            return headerView
        default:
            assert(false)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 150)
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
}


// MARK: - RecordListCollectionViewCellDelegate
extension CalendarViewController: RecordListCollectionViewCellDelegate {
    func showMoreMenu() {
        let actionSheet = Helper().actionSheet(delete: true)
        self.present(actionSheet, animated: true)
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



