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
    /// scrollView 변수 초기화
    lazy var scrollView = UIScrollView()
    
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
        setupNavigationBar()
        setupLayout()
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
            $0.edges.equalToSuperview()
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(calendarView.snp.width).multipliedBy(0.84 / 1.0)
        }
    }
}

// MARK: - FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 선택된 날짜 배경색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.init(named: "mainColor")
    }
//    
//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//        let labelMy2 = UILabel(frame: CGRect(x: 0, y: 35, width: cell.bounds.width, height: 10))
//            labelMy2.font = .systemFont(ofSize: 8)
//            labelMy2.text = "1시간 10분"
//            labelMy2.textAlignment = .center
//            labelMy2.textColor = UIColor.init(named: "mainColor")
//            cell.addSubview(labelMy2)
//
//    }
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



