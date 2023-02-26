//
//  RegisterViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/27.
//

import UIKit
import SnapKit
import Then
import Combine

// MARK: 회원가입 프로세스 순서
enum RegisterProcess: Int {
    case enterEmail
    case enterVerificationCode
    case enterPassword
    case enterPasswordConfirm
    case enterNickname
}

class RegisterViewController: BaseViewController {
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var registerProcess: RegisterProcess = .enterEmail
    
    private let authenticationService = AuthenticationService()
    
    // 이메일 중복확인 여부
    private var isConfirmCheckEmailDuplicate = false
    
    // TODO: 인증코드 중복 소스 리팩토링
    // 인증코드 발송 여부
    private var sendedVerificationCode = false
    
    // 입력 확인 여부
    private var enteredEmail = false
    private var enteredVerificationCode = false
    private var enteredPassword = false
    private var enteredPasswordConfirm = false
    private var enteredNickname = false
    
    private lazy var formStackView = generateFormStackView()
    
    // MARK: - 상단 타이틀
    private let titles = [
        "반가워요. :)\n사용하실 이메일 주소를 알려주세요!",
        "좋아요!\n발송된 인증번호를 입력해주세요.",
        "인증번호 확인 완료!\n사용하실 비밀번호를 입력해주세요.",
        "거의 다 왔어요!\n비밀번호를 한 번 더 입력해주세요. :)",
        "마지막 단계!\n사용하실 멋진 닉네임을 입력해볼까요?",
    ]
    
    private lazy var titleLabel = UILabel().then {
        $0.text = titles[registerProcess.rawValue]
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
    
    private let emailFieldStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 0
    }
    
    private lazy var emailDuplicateCheckLabel = UILabel().then {
        let attribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let attributeString = NSMutableAttributedString(string: "중복확인", attributes: attribute)
        
        $0.attributedText = attributeString
        
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.font = .systemFont(ofSize: 14)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEmailDuplicateCheckLabel))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
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
    
    private lazy var verificationCodeResendLabel = UILabel().then {
        let attribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let attributeString = NSMutableAttributedString(string: "재발송", attributes: attribute)
        
        $0.attributedText = attributeString
        
        $0.highlightedTextColor = .gray
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
    
    private lazy var passwordEyeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16)).then {
        $0.tintColor = .black
        $0.setImage(UIImage(named: "eye_show"), for: .normal)
        $0.addTarget(self, action: #selector(didTapPasswordEyeButton), for: .touchUpInside)
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
    
    // MARK: - 닉네임
    private let nicknameStackView = UIStackView().then {
        $0.spacing = 3
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .init(hexFromString: "#2E2E2E")
        $0.text = "닉네임"
    }
    
    private lazy var nicknameTextField = BHTextField().then {
        $0.placeholder = "최대 2~8자 내외"
        $0.delegate = self
    }
    
    private let nicknameBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    private let nicknameErrorLabel = UILabel().then {
        $0.text = "닉네임을 확인해주세요!"
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
extension RegisterViewController {
    // MARK: View
    private func setupViews() {
        [titleLabel, formStackView, submitButton].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        formStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.top.greaterThanOrEqualTo(formStackView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    /// 회원가입 폼 stackView 생성
    /// - Returns: 회원가입 폼 stackView
    private func generateFormStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 18
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        // 폼 textField StackView 변수 초기화
        [emailTextField, verificationCodeTextField, passwordTextField, passwordConfirmTextField, nicknameTextField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
        }
        
        [emailBottomBorder, verificationCodeBottomBorder, passwordBottomBorder, passwordConfirmBottomBorder, nicknameBottomBorder].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
        
        [emailTextField, emailDuplicateCheckLabel].forEach {
            emailFieldStackView.addArrangedSubview($0)
        }
        
        [emailLabel, emailFieldStackView, emailBottomBorder, emailErrorLabel].forEach {
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
        
        [nicknameLabel, nicknameTextField, nicknameBottomBorder, nicknameErrorLabel].forEach {
            nicknameStackView.addArrangedSubview($0)
        }
        
        stackView.addArrangedSubview(emailStackView)
        
        return stackView
    }
    
    // MARK: Bind
    private func bind() {
        [emailTextField, verificationCodeTextField, passwordTextField, passwordConfirmTextField, nicknameTextField].forEach {
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
            isConfirmCheckEmailDuplicate = false
            
            if text.emailValidate() {
                emailBottomBorder.backgroundColor = .lightGray
                emailErrorLabel.isHidden = true
                
                emailErrorLabel.text = "이메일 주소를 확인해주세요!"
                emailErrorLabel.textColor = .systemRed
                
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
        case nicknameTextField:
            if text.nicknameValiate(){
                nicknameBottomBorder.backgroundColor = .lightGray
                nicknameErrorLabel.isHidden = true
                
                enteredNickname = true
            } else {
                nicknameBottomBorder.backgroundColor = .systemRed
                nicknameErrorLabel.isHidden = false
                
                enteredNickname = false
            }
        default:
            break
        }
        
        if (enteredEmail && registerProcess == .enterEmail) ||
            (enteredVerificationCode && registerProcess == .enterVerificationCode) ||
            (enteredPassword && registerProcess == .enterPassword) ||
            (enteredPassword && enteredPasswordConfirm && registerProcess == .enterPasswordConfirm) ||
            (enteredNickname && registerProcess == .enterNickname)
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
    /// 회원가입 버튼 클릭 시
    @objc private func didTapSubmitButton(_ sender: Any) {
        var nextRegisterProcess: RegisterProcess?
        
        switch registerProcess {
        case .enterEmail:
            if isConfirmCheckEmailDuplicate {
                nextRegisterProcess = .enterVerificationCode
                
                emailTextField.isEnabled = false
                emailTextField.textColor = .init(hexFromString: "#868181")
                
                emailErrorLabel.isHidden = true
                
                submitButton.setTitle("인증번호 확인", for: .normal)
                
                emailDuplicateCheckLabel.isHidden = true
                
                formStackView.insertArrangedSubview(verificationCodeStackView, at: 0)
                
                requestVerificationCode(resend: false)
            } else {
                emailErrorLabel.text = "이메일 중복 여부를 확인해주세요!"
                emailErrorLabel.textColor = .systemRed
                emailErrorLabel.isHidden = false
                
                submitButton.isEnabled = false
            }
        case .enterVerificationCode:
            if let email = emailTextField.text, let verificationCode = verificationCodeTextField.text {
                authenticationService.verifyCode(email: email, purpose: "SIGN_UP", emailVerificationCode: verificationCode) { [weak self] data in
                    if let statusCode = data.statusCode {
                        switch statusCode {
                        case 200:
                            self?.verifyCodeSuccess()
                        default:
                            guard let errorData = data.errorData else { return }
                            self?.verifyCodeFail(reason: errorData.reason)
                        }
                    }
                }
            }
        case .enterPassword:
            nextRegisterProcess = .enterPasswordConfirm
            
            passwordTextField.rightView = nil
            passwordTextField.isSecureTextEntry = true
            
            passwordEyeButton.setImage(UIImage(named: "eye_show"), for: .normal)
            passwordConfirmTextField.rightView = passwordEyeButton
            passwordConfirmTextField.rightViewMode = .always
            
            formStackView.insertArrangedSubview(passwordConfirmStackView, at: 0)
        case .enterPasswordConfirm:
            nextRegisterProcess = .enterNickname
            
            passwordConfirmTextField.rightView = nil
            passwordConfirmTextField.isSecureTextEntry = true
            
            passwordTextField.isEnabled = false
            passwordConfirmTextField.isEnabled = false
            
            passwordTextField.textColor = .init(hexFromString: "#868181")
            passwordConfirmTextField.textColor = .init(hexFromString: "#868181")
            
            formStackView.insertArrangedSubview(nicknameStackView, at: 0)
        case .enterNickname:
            let email = emailTextField.text!
            let password = passwordTextField.text!
            let name = nicknameTextField.text!
            let verificationCode = verificationCodeTextField.text!
            
            let user = User(email: email, password: password, name: name, verificationCode: verificationCode)
            
            authenticationService.signUp(user: user) { [weak self] data in
                if let accessToken = data.accessToken, let refreshToken = data.refreshToken { // 회원가입 성공
                    UserDefaults.standard.set(accessToken, forKey: "jwt")
                    UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                    UserDefaults.standard.set(email, forKey: "email")
                    self?.signUpSuccess()
                } else if let _ = data.errorCode, let reason = data.reason { // 회원가입 실패
                    self?.signUpFail(reason: reason)
                }
            }
        }
        
        if nextRegisterProcess != nil {
            registerProcess = nextRegisterProcess!
            titleLabel.text = titles[registerProcess.rawValue]
            submitButton.isEnabled = false
        }
    }
    
    /// 이메일 중복확인 클릭 시
    @objc private func didTapEmailDuplicateCheckLabel(sender: UITapGestureRecognizer) {
        print(#function)
        if let email = emailTextField.text, email.emailValidate() {
            authenticationService.checkEmailDuplicate(email: email) { [weak self] data in
                if let statusCode = data.statusCode {
                    switch statusCode {
                    case 200:
                        self?.checkEmailDuplicateFail()
                    default:
                        self?.checkEmailDuplicateSuccess()
                    }
                }
            }
        }
    }
    
    /// 인증번호 재발송 클릭 시
    @objc private func didTapVerificationCodeResendLabel(sender: UITapGestureRecognizer) {
        verificationCodeResendLabel.isHighlighted = true
        
        requestVerificationCode(resend: true)
    }
    
    /// 비밀번호 보기 / 숨기기 클릭 시
    @objc private func didTapPasswordEyeButton(sender: UIButton) {
        if registerProcess == .enterPassword {
            passwordTextField.isSecureTextEntry.toggle()
            passwordEyeButton.setImage(passwordTextField.isSecureTextEntry ? UIImage(named: "eye_show") : UIImage(named: "eye_hide"), for: .normal)
        } else {
            passwordConfirmTextField.isSecureTextEntry.toggle()
            passwordEyeButton.setImage(passwordConfirmTextField.isSecureTextEntry ? UIImage(named: "eye_show") : UIImage(named: "eye_hide"), for: .normal)
        }
    }
    
    // MARK: 이메일 중복확인 처리
    /// 이메일 중복확인 성공
    private func checkEmailDuplicateSuccess() {
        print(#function)
        isConfirmCheckEmailDuplicate = true
        
        emailErrorLabel.text = "사용 가능한 이메일 입니다!"
        emailErrorLabel.textColor = .init(hexFromString: "#007AFF")
        emailErrorLabel.isHidden = false
        
        submitButton.isEnabled = true
    }
    
    /// 이메일 중복확인 실패
    private func checkEmailDuplicateFail() {
        print(#function)
        isConfirmCheckEmailDuplicate = false
        
        emailErrorLabel.text = "이미 가입된 이메일이에요. :("
        emailErrorLabel.textColor = .systemRed
        emailErrorLabel.isHidden = false
        
        submitButton.isEnabled = false
    }
    
    // MARK: 인증번호 처리
    /// 인증번호 요청
    private func requestVerificationCode(resend: Bool) {
        if sendedVerificationCode { return }
        
        if let email = emailTextField.text {
            sendedVerificationCode = true
            
            authenticationService.requestVerififcationCode(email: email, purpose: "SIGN_UP") { [weak self] data in
                self?.verificationCodeResendLabel.isHighlighted = false
                self?.sendedVerificationCode = false
                
                if let statusCode = data.statusCode {
                    switch statusCode {
                    case 200:
                        self?.requestVerificationCodeSuccess(resend: resend)
                    default:
                        self?.requestVerificationCodeFail(reason: data.result?.reason)
                    }
                }
            }
        }
    }
    
    /// 인증번호 요청 성공
    private func requestVerificationCodeSuccess(resend: Bool) {
        print(#function)
        
        if resend {
            showToast(title: "인증번호 재발송 완료!", msg: "발송된 인증번호를 확인해주세요!") { }
        }
    }
    
    /// 인증번호 요청 실패
    private func requestVerificationCodeFail(reason: String?) {
        print(#function)
        if let reason = reason {
            print(reason)
        }
    }
    
    /// 인증번호 검증 성공
    private func verifyCodeSuccess() {
        print(#function)
        registerProcess = .enterPassword
        
        passwordTextField.rightView = passwordEyeButton
        passwordTextField.rightViewMode = .always
        
        titleLabel.text = titles[registerProcess.rawValue]
        submitButton.isEnabled = false
        
        verificationCodeTextField.isEnabled = false
        verificationCodeTextField.textColor = .init(hexFromString: "#868181")
        
        submitButton.setTitle("다음", for: .normal)
        
        verificationCodeStackView.isHidden = true
        
        formStackView.insertArrangedSubview(passwordStackView, at: 0)
    }
    
    /// 인증번호 검증 실패
    private func verifyCodeFail(reason: String?) {
        print(#function)
        if let reason = reason {
            print(reason)
            verificationCodeBottomBorder.backgroundColor = .systemRed
            verificationCodeErrorLabel.isHidden = false
            
            enteredVerificationCode = false
        }
    }
    
    // MARK: 회원가입 처리
    private func signUpSuccess() {
        print(#function)
        let vc = GoalTimeSettingView(openProcess: .auth)
        
        if let jwt = UserDefaults.standard.string(forKey: "jwt"), let jwtDecode = JSONWebToken(jsonWebToken: jwt) {
//            print("jwt ::: \(jwt)")
//            print("jwt header ::: \(jwtDecode.header)")
//            print("jwt payload ::: \(jwtDecode.payload)")
            
            UserDefaults.standard.set(jwtDecode.payload.name, forKey: "userName")
        }
        
        self.view.window?.windowScene?.keyWindow?.rootViewController = vc
    }
    
    private func signUpFail(reason: String?) {
        print(#function)
        if let reason = reason {
            print(reason)
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
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
        case passwordTextField, passwordConfirmTextField:
            return string.passwordInputValidate()
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
