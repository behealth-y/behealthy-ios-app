//
//  RegisterViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/27.
//

import UIKit
import SnapKit
import Then

class RegisterViewController: BHAuthViewController {
    
    lazy var registerButton = BHSubmitButton(title: "회원가입")
    
    var textFields: [BHTextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar("회원가입")
        setupScrollView()
        
        setKeyboardObserver()
        titleView.title = "회원가입"
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension RegisterViewController {
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
            $0.edges.equalTo(scrollView.contentLayoutGuide)
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
        
        registerButton.isEnabled = false
        
        // 회원가입 버튼 눌렀을 때 처리
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        contentView.addSubview(registerButton)
        
        registerButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.top.equalTo(formStackView.snp.bottom).offset(18)
            $0.bottom.equalToSuperview().inset(18)
        }
    }
    
    /// 회원가입 폼 stackView 생성
    /// - Returns: 회원가입 폼 stackView
    fileprivate func generateFormStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 12
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.axis = .vertical
        }
        
        // 폼 textField StackView 변수 초기화
        let emailStackView = generateTextFieldStackView("이메일", placeholder: "이메일 형식", keyboardType: .emailAddress)
        let pwStackView = generateTextFieldStackView("비밀번호", placeholder: "영문, 숫자, 특수문자 조합 최소 8자", secure: true)
        let pwCheckStackView = generateTextFieldStackView("비밀번호 확인", placeholder: "비밀번호 재입력", secure: true)
        let nicknameStackView = generateTextFieldStackView("닉네임", placeholder: "국문, 영문 2~8글자")
        
        [emailStackView, pwStackView, pwCheckStackView, nicknameStackView].forEach {
            stackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        return stackView
    }
    
    /// 회원가입 폼 > 입력창 stackVeiw 생성
    /// - Parameters:
    ///   - label: textField Label
    ///   - placeholder: textField placeholder
    /// - Returns: 입력창 stackView
    fileprivate func generateTextFieldStackView(_ label: String, placeholder: String, keyboardType: UIKeyboardType = .default, secure: Bool = false) -> UIStackView {
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
        
        let textField = BHTextField(placeholder: placeholder, keyboardType: keyboardType, secure: secure)
        textField.delegate = self
        
        textFields.append(textField)
        
        [label, textField].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        return stackView
    }
}

// MARK: - Actions
extension RegisterViewController {
    // 회원가입 처리
    @objc fileprivate func didTapRegisterButton(_ sender: Any) {
        showToast(msg: "회원가입이 완료되었습니다.\n이제 Healthy와 함께 건강해질 준비 되셨나요?")
    }
}

// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
extension RegisterViewController: UITextFieldDelegate {
    // return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // textField 채워지면 회원가입 버튼 활성화 되도록
    func textFieldDidChangeSelection(_ textField: UITextField) {
        registerButton.isEnabled = true
        
        textFields.forEach {
            if $0.text?.isEmpty ?? false {
                registerButton.isEnabled = false
            }
        }
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct RegisterViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        RegisterViewController()
    }
}

struct RegisterViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        RegisterViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
