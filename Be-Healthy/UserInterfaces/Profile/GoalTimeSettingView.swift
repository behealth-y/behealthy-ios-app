//
//  GoalTimeSettingView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/09.
//

import UIKit
import SnapKit
import Then

class GoalTimeSettingView: BHBaseViewController {
    // 목표 운동시간 변수 초기화
    var timeInt: Int = 0
    
    // 목표 운동시간 textField 변수 초기화
    lazy var textField = UITextField().then {
        $0.font = .systemFont(ofSize: 16)
//        $0.attributedText = setTimeText()
        $0.text = "1 시간 0 분"
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.delegate = self
//        $0.setDatePicker(target: self, selector: #selector(handleDatePicker), isCount: true)
        $0.addLeftPadding()
        
        if let datePicker = $0.inputView as? UIDatePicker {
            datePicker.countDownDuration = 3600
            datePicker.minuteInterval = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar("목표 운동시간 설정")
        setupScrollView()
        
        setKeyboardObserver()
        titleView.title = "목표 운동시간 설정"
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension GoalTimeSettingView {
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        self.view.addSubview(scrollView)
        
        // scrollView 위치 잡기
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let contentView = UIView()
        
        scrollView.addSubview(contentView)
        
        // contentView 위치 잡기
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.edges.equalTo(scrollView)
        }
        
        contentView.addSubview(titleView)
        
        // titleView 위치 잡기
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(titleView.snp.width).multipliedBy(0.79 / 1.0)
        }
        
        let titleLabel = UILabel().then {
            $0.text = "회원님의 목표 일일 운동시간을 설정해주세요."
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.lessThanOrEqualToSuperview().inset(18)
        }
        
        let descriptionLabel = UILabel().then {
            $0.text = "나중에 언제든지 변경할 수 있어요. :)"
            $0.font = .systemFont(ofSize: 14)
        }
        
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel)
        }
        
        contentView.addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.top.equalTo(descriptionLabel.snp.bottom)
            $0.height.equalTo(60)
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = .border
        }
        
        contentView.addSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints {
            $0.bottom.equalTo(textField)
            $0.horizontalEdges.equalTo(textField)
            $0.height.equalTo(0.5)
        }
        
        let submitButton = BHSubmitButton(title: "설정하기")
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        
        contentView.addSubview(submitButton)
        
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.top.equalTo(textField.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
}

// MARK: - Actions
extension GoalTimeSettingView {
    @objc fileprivate func handleDatePicker() {
        if let datePicker = self.textField.inputView as? UIDatePicker {
            timeInt = Int(datePicker.countDownDuration) / 60
        }
        
        let hour : Int = timeInt / 60
        let minute : Int = timeInt % 60
        
        self.textField.text = "\(hour) 시간 \(minute) 분"
        self.textField.resignFirstResponder()
    }
    
    @objc fileprivate func didTapSubmitButton() {
        self.view.window?.windowScene?.keyWindow?.rootViewController = TabBarViewController()
    }
}

// MARK: - Helpers
extension GoalTimeSettingView {
    fileprivate func setTimeText(hour: Int = 1, minute: Int = 0) -> NSMutableAttributedString {
        let timeText = "\(hour) 시간 \(minute) 분"
        let attributeString = NSMutableAttributedString(string: timeText)
        
        ["시간", "분"].forEach {
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0), range: (timeText as NSString).range(of: $0))
        }
        
        return attributeString
    }
}
// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
extension GoalTimeSettingView: UITextFieldDelegate {
    // return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct GoalTimeSettingViewPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        GoalTimeSettingView()
    }
}

struct GoalTimeSettingViewPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        GoalTimeSettingViewPresentable()
            .ignoresSafeArea()
    }
}

#endif
