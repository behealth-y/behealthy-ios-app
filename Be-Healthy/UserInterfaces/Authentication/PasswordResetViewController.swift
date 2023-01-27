//
//  PasswordResetViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/27.
//

import UIKit
import SnapKit
import Then
import Combine

// MARK: 비밀번호 변경 프로세스 순서
enum PasswordResetProcess: Int {
    case enterEmail
    case enterVerificationCode
    case enterPassword
    case enterPasswordConfirm
}

class PasswordResetViewController: BaseViewController {
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var passwordResetProcess: PasswordResetProcess = .enterEmail
    
    private let authenticationService = AuthenticationService()
    
    // 입력 확인 여부
    private var enteredEmail = false
    private var enteredVerificationCode = false
    private var enteredPassword = false
    private var enteredPasswordConfirm = false
    
    private lazy var formStackView = generateFormStackView()
    
    // MARK: - 상단 타이틀
    private let titles = [
        "비밀번호를 재설정 해볼까요?\n이메일 주소를 입력해주세요!",
        "인증번호를 보내드렸어요. :)\n발송된 인증번호를 입력해주세요!",
        "인증번호 확인 완료!\n변경하실 비밀번호를 입력해주세요.",
        "좋은데요. :D\n비밀번호를 한 번 더 입력해주세요!",
    ]
    
    private lazy var titleLabel = UILabel().then {
        $0.text = titles[passwordResetProcess.rawValue]
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 2
    }
    
    // MARK: - 이메일 주소
    private let emailStackView = UIStackView().then {
        $0.spacing = 3
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let emailLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .init(hexFromString: "#2E2E2E")
        $0.text = "이메일 주소"
    }
    
    private lazy var emailTextField = BHTextField().then {
        $0.placeholder = "이메일 주소"
        $0.textContentType = .emailAddress
        $0.delegate = self
    }
    
    private let emailBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    private let emailErrorLabel = UILabel().then {
        $0.text = "이메일 주소를 확인해주세요!"
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .systemRed
        
        $0.isHidden = true
    }
    
    // MARK: - 인증번호
    private let verificationCodeStackView = UIStackView().then {
        $0.spacing = 3
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let verificationCodeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .init(hexFromString: "#2E2E2E")
        $0.text = "인증번호"
    }
    
    private lazy var verificationCodeTextField = BHTextField().then {
        $0.placeholder = "인증번호를 입력해주세요."
        $0.keyboardType = .numberPad
        $0.delegate = self
    }
    
    private let verificationCodeFieldStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 0
    }
    
    private let verificationCodeResendLabel = UILabel().then {
        let attribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let attributeString = NSMutableAttributedString(string: "재발송", attributes: attribute)
        
        $0.attributedText = attributeString
        
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.font = .systemFont(ofSize: 14)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapVerificationCodeResendLabel))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
    }
    
    private let verificationCodeBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    private let verificationCodeErrorLabel = UILabel().then {
        $0.text = "발송된 인증번호를 다시 확인해주세요!"
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .systemRed
        
        $0.isHidden = true
    }
    
    // MARK: - 비밀번호
    private let passwordStackView = UIStackView().then {
        $0.spacing = 3
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let passwordLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .init(hexFromString: "#2E2E2E")
        $0.text = "비밀번호"
    }
    
    private lazy var passwordTextField = BHTextField().then {
        $0.placeholder = "영문, 숫자, 특수문자 조합 최소 8자"
        $0.isSecureTextEntry = true
        $0.delegate = self
    }
    
    private let passwordBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    private let passwordErrorLabel = UILabel().then {
        $0.text = "비밀번호를 확인해주세요!"
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .systemRed
        
        $0.isHidden = true
    }
    
    // MARK: - 비밀번호 확인
    private let passwordConfirmStackView = UIStackView().then {
        $0.spacing = 3
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let passwordConfirmLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .init(hexFromString: "#2E2E2E")
        $0.text = "비밀번호 확인"
    }
    
    private lazy var passwordConfirmTextField = BHTextField().then {
        $0.placeholder = "비밀번호를 다시 한 번 입력해주세요."
        $0.isSecureTextEntry = true
        $0.delegate = self
    }
    
    private let passwordConfirmBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    private let passwordConfirmErrorLabel = UILabel().then {
        $0.text = "비밀번호를 다시 확인해주세요. :("
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .systemRed
        
        $0.isHidden = true
    }
    
    // MARK: - 폼 제출 버튼
    private lazy var submitButton = BHSubmitButton(title: "인증번호 요청").then {
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        bind()
    }
}

// MARK: - Extension
extension PasswordResetViewController {
    // MARK: View
    private func setupViews() {
        [titleLabel, formStackView, submitButton].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        formStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.top.greaterThanOrEqualTo(formStackView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    /// 비밀번호 재설정 폼 stackView 생성
    /// - Returns: 비밀번호 재설정 폼 stackView
    private func generateFormStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 18
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        // 폼 textField StackView 변수 초기화
        [emailTextField, verificationCodeTextField, passwordTextField, passwordConfirmTextField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
        }
        
        [emailBottomBorder, verificationCodeBottomBorder, passwordBottomBorder, passwordConfirmBottomBorder].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
        
        [emailLabel, emailTextField, emailBottomBorder, emailErrorLabel].forEach {
            emailStackView.addArrangedSubview($0)
        }
        
        [verificationCodeTextField, verificationCodeResendLabel].forEach {
            verificationCodeFieldStackView.addArrangedSubview($0)
        }
        
        [verificationCodeLabel, verificationCodeFieldStackView, verificationCodeBottomBorder, verificationCodeErrorLabel].forEach {
            verificationCodeStackView.addArrangedSubview($0)
        }
        
        [passwordLabel, passwordTextField, passwordBottomBorder, passwordErrorLabel].forEach {
            passwordStackView.addArrangedSubview($0)
        }
        
        [passwordConfirmLabel, passwordConfirmTextField, passwordConfirmBottomBorder, passwordConfirmErrorLabel].forEach {
            passwordConfirmStackView.addArrangedSubview($0)
        }
        
        stackView.addArrangedSubview(emailStackView)
        
        return stackView
    }
    
    // MARK: Bind
    private func bind() {
        [emailTextField, verificationCodeTextField, passwordTextField, passwordConfirmTextField].forEach {
            let textField = $0
            
            $0.textPublisher.sink { [weak self] _ in
                self?.validate(textField)
            }.store(in: &cancellables)
        }
    }
    
    // MARK: Validate
    private func validate(_ textField: UITextField) {
        let text = textField.text!
        
        switch textField {
        case emailTextField:
            if text.emailValidate() {
                emailBottomBorder.backgroundColor = .lightGray
                emailErrorLabel.isHidden = true
                
                enteredEmail = true
            } else {
                emailBottomBorder.backgroundColor = .systemRed
                emailErrorLabel.isHidden = false
                
                enteredEmail = false
            }
        case verificationCodeTextField:
            if text.verificationCodeValidate() {
                verificationCodeBottomBorder.backgroundColor = .lightGray
                verificationCodeErrorLabel.isHidden = true
                
                textField.resignFirstResponder()
                
                enteredVerificationCode = true
            } else {
                verificationCodeBottomBorder.backgroundColor = .systemRed
                verificationCodeErrorLabel.isHidden = false
                
                enteredVerificationCode = false
            }
        case passwordTextField:
            if text.passwordValidate() {
                passwordBottomBorder.backgroundColor = .lightGray
                passwordErrorLabel.isHidden = true
                
                enteredPassword = true
            } else {
                passwordBottomBorder.backgroundColor = .systemRed
                passwordErrorLabel.isHidden = false
                
                enteredPassword = false
            }
            
            checkEqualPassword()
        case passwordConfirmTextField:
            checkEqualPassword()
        default:
            break
        }
        
        if (enteredEmail && passwordResetProcess == .enterEmail) ||
            (enteredVerificationCode && passwordResetProcess == .enterVerificationCode) ||
            (enteredPassword && passwordResetProcess == .enterPassword) ||
            (enteredPassword && enteredPasswordConfirm && passwordResetProcess == .enterPasswordConfirm)
        {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    private func checkEqualPassword() {
        let passwordText = passwordTextField.text!
        let passwordConfirmText = passwordConfirmTextField.text!
        
        guard passwordText.count > 0, passwordConfirmText.count > 0 else { return }
        
        if passwordText == passwordConfirmText {
            passwordConfirmBottomBorder.backgroundColor = .lightGray
            passwordConfirmErrorLabel.isHidden = true
            
            enteredPasswordConfirm = true
        } else {
            passwordConfirmBottomBorder.backgroundColor = .systemRed
            passwordConfirmErrorLabel.isHidden = false
            
            enteredPasswordConfirm = false
        }
    }
    
    // MARK: Actions
    /// 비밀번호 재설정 처리
    @objc private func didTapSubmitButton(_ sender: Any) {
        var nextPasswordResetProcess: PasswordResetProcess?
        
        switch passwordResetProcess {
        case .enterEmail:
            nextPasswordResetProcess = .enterVerificationCode
            
            emailTextField.isEnabled = false
            emailTextField.textColor = .init(hexFromString: "#868181")
            
            submitButton.setTitle("인증번호 확인", for: .normal)
            
            formStackView.insertArrangedSubview(verificationCodeStackView, at: 0)
        case .enterVerificationCode:
            nextPasswordResetProcess = .enterPassword
            
            if let email = emailTextField.text, let verificationCode = verificationCodeLabel.text {
                authenticationService.verifyCode(email: email, purpose: "PASSWORD_RESET", emailVerificationCode: verificationCode) { [weak self] data in
                    guard let self = self else { return }
                    if let _ = data.errorCode, let reason = data.reason { // 인증번호 검증 실패
                        print(reason)
                        self.verifyCodeFail()
                    } else { // 인증번호 검증 성공
                        self.verifyCodeSuccess()
                    }
                }
            }
        case .enterPassword:
            nextPasswordResetProcess = .enterPasswordConfirm
            
            submitButton.setTitle("변경하기", for: .normal)
            
            formStackView.insertArrangedSubview(passwordConfirmStackView, at: 0)
        case .enterPasswordConfirm:
            let email = emailTextField.text!
            let toBePassword = passwordConfirmLabel.text!
            let verificationCode = verificationCodeLabel.text!
            
            authenticationService.resetPassword(email: email, toBePassword: toBePassword, verificationCode: verificationCode) { [weak self] data in
                guard let self = self else { return }
                if let _ = data.errorCode, let reason = data.reason { //  회원가입 실패
                    print(reason)
                    self.passwordResetFail()
                } else { // 회원가입 성공
                    self.passwordResetSuccess()
                }
            }
        }
        
        if nextPasswordResetProcess != nil {
            passwordResetProcess = nextPasswordResetProcess!
            titleLabel.text = titles[passwordResetProcess.rawValue]
            submitButton.isEnabled = false
        }
    }
    
    /// 인증번호 재발송 클릭 시
    @objc private func didTapVerificationCodeResendLabel(sender: UITapGestureRecognizer) {
        requestVerificationCode()
    }
    
    // MARK: 인증번호 처리
    /// 인증번호 요청
    private func requestVerificationCode() {
        if let email = emailTextField.text {
            authenticationService.requestVerififcationCode(email: email, purpose: "PASSWORD_RESET") { [weak self] data in
                if let expireAt = data.expireAt { // 인증번호 발송 성공
                    print("expireAt ::: \(expireAt)")
                    self?.requestVerificationCodeSuccess()
                } else if let _ = data.errorCode, let reason = data.reason { // 인증번호 발송 실패
                    print(reason)
                    self?.requestVerificationCodeFail()
                }
            }
        }
    }
    
    /// 인증번호 요청 성공
    private func requestVerificationCodeSuccess() {
        print(#function)
    }
    
    /// 인증번호 요청 실패
    private func requestVerificationCodeFail() {
        print(#function)
    }
    
    /// 인증번호 검증 성공
    private func verifyCodeSuccess() {
        print(#function)
        verificationCodeTextField.isEnabled = false
        verificationCodeTextField.textColor = .init(hexFromString: "#868181")
        
        submitButton.setTitle("다음", for: .normal)
        
        verificationCodeStackView.isHidden = true
        
        formStackView.insertArrangedSubview(passwordStackView, at: 0)
    }
    
    /// 인증번호 검증 실패
    private func verifyCodeFail() {
        print(#function)
    }
    
    // MARK: 비밀번호 재설정 처리
    /// 비밀번호 재설정 성공
    private func passwordResetSuccess() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    
    /// 비밀번호 재설정 실패
    private func passwordResetFail() {
        print(#function)
    }
}

// MARK: - UITextFieldDelegate
extension PasswordResetViewController: UITextFieldDelegate {
    /// return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    /// 인증번호 6글자 넘어가면 더 이상 입력 못하게 처리
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        // 백 스페이스 감지
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        switch textField {
        case verificationCodeTextField:
            return text.count < 6
        default:
            return true
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
        RegisterViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
