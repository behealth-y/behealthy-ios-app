//
//  PasswordResetViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/27.
//

import UIKit
import SnapKit
import Then

class PasswordResetViewController: BHBaseViewController {
    lazy var pwTextField = BHTextField().then {
        $0.placeholder = "영문, 숫자, 특수문자 조합 최소 8자"
        $0.isSecureTextEntry = true
        $0.delegate = self
    }
    
    lazy var pwCheckTextField = BHTextField().then {
        $0.placeholder = "비밀번호 재입력"
        $0.isSecureTextEntry = true
        $0.delegate = self
    }
    
    lazy var passwordResetButton = BHSubmitButton(title: "설정 완료")
    
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar("비밀번호 재설정")
        setupScrollView()
        
        setKeyboardObserver()
        titleView.title = "비밀번호 재설정"
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension PasswordResetViewController {
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
        
        let formStackView = generateFormStackView()
        
        contentView.addSubview(formStackView)
        
        formStackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        passwordResetButton.isEnabled = false
        
        contentView.addSubview(passwordResetButton)
        
        passwordResetButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.top.equalTo(formStackView.snp.bottom).offset(18)
            $0.bottom.equalToSuperview().inset(18)
        }
    }
    
    /// 비밀번호 재설정 폼 stackView 생성
    /// - Returns: 비밀번호 재설정 폼 stackView
    fileprivate func generateFormStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 12
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.axis = .vertical
        }
        
        // 폼 textField StackView 변수 초기화
        let pwStackView = generateTextFieldStackView("비밀번호", textField: pwTextField)
        let pwCheckStackView = generateTextFieldStackView("비밀번호 확인", textField: pwCheckTextField)
        
        [pwStackView, pwCheckStackView].forEach {
            stackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        return stackView
    }
    
    /// 비밀번호 재설정 폼 > 입력창 stackVeiw 생성
    /// - Parameters:
    ///   - label: textField Label
    ///   - placeholder: textField placeholder
    /// - Returns: 입력창 stackView
    fileprivate func generateTextFieldStackView(_ label: String, textField: BHTextField) -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 7
            $0.alignment = .center
            $0.axis = .vertical
            $0.distribution = .fill
        }
        
        let label = UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = UIColor(hexFromString: "#2E2E2E")
            $0.text = label
        }
        
        let textFieldView = BHTextFieldView(textField: textField)
        
        textFields.append(textField)
        
        [label, textFieldView].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        return stackView
    }
}

// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
extension PasswordResetViewController: UITextFieldDelegate {
    // return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // textField 채워지면 비밀번호 재설정 버튼 활성화 되도록
    func textFieldDidChangeSelection(_ textField: UITextField) {
        passwordResetButton.isEnabled = true
        
        textFields.forEach {
            if $0.text?.isEmpty ?? false {
                passwordResetButton.isEnabled = false
            }
        }
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct PasswordResetViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        PasswordResetViewController()
    }
}

struct PasswordResetViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        PasswordResetViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
