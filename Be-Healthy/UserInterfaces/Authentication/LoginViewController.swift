//
//  LoginViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import SnapKit
import Then
import Combine

// MARK: 회원가입 프로세스 순서
enum LoginProcess: Int {
    case enterEmail
    case enterPassword
}

class LoginViewController: BaseViewController {
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var loginProcess: LoginProcess = .enterEmail
    
    private let authenticationService = AuthenticationService()
    
    // 입력 확인 여부
    private var enteredEmail = false
    private var enteredPassword = false
    
    private lazy var formStackView = generateFormStackView()
    
    // MARK: - 상단 타이틀
    private let titles = [
        "반가워요! :D\n가입하신 이메일 주소를 입력해주세요!",
        "좋아요!\n가입하신 비밀번호를 입력해주세요!",
    ]
    
    private lazy var titleLabel = UILabel().then {
        $0.text = titles[loginProcess.rawValue]
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 2
    }
    
    // MARK: - 이메일 주소
    private let emailStackView = UIStackView().then {
        $0.spacing = 10
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
    
    private let emailLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .trailing
        $0.spacing = 0
    }
    
    private let emailErrorLabel = UILabel().then {
        $0.text = ""
//        $0.text = "이메일 주소를 확인해주세요!"
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .systemRed
    }
    
    private lazy var moveToPasswordResetLabel = UILabel().then {
        let attribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let attributeString = NSMutableAttributedString(string: "비밀번호를 잊으셨나요?", attributes: attribute)
        
        $0.attributedText = attributeString
        
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.font = .systemFont(ofSize: 12)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMoveToPasswordResetLabel))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
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
    
    // MARK: - 폼 제출 버튼
    private lazy var submitButton = BHSubmitButton(title: "비밀번호 입력").then {
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
extension LoginViewController {
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
    
    /// 로그인 폼 stackView 생성
    /// - Returns: 로그인 폼 stackView
    private func generateFormStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 18
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        // 폼 textField StackView 변수 초기화
        [emailTextField, passwordTextField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
        }
        
        [emailBottomBorder, passwordBottomBorder].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
        
        [emailErrorLabel, moveToPasswordResetLabel].forEach {
            emailLabelStackView.addArrangedSubview($0)
        }
        
        [emailLabel, emailTextField, emailBottomBorder, emailLabelStackView].forEach {
            emailStackView.addArrangedSubview($0)
        }
        
        [passwordLabel, passwordTextField, passwordBottomBorder, passwordErrorLabel].forEach {
            passwordStackView.addArrangedSubview($0)
        }
        
        stackView.addArrangedSubview(emailStackView)
        
        return stackView
    }
    
    // MARK: Bind
    private func bind() {
        [emailTextField, passwordTextField].forEach {
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
                enteredEmail = true
            } else {
                enteredEmail = false
            }
        case passwordTextField:
            if text.passwordValidate() {
                enteredPassword = true
            } else {
                enteredPassword = false
            }
        default:
            break
        }
        
        if (enteredEmail && loginProcess == .enterEmail) ||
            (enteredPassword && loginProcess == .enterPassword)
        {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    // MARK: Actions
    /// 로그인 버튼 클릭 시
    @objc private func didTapSubmitButton(_ sender: Any) {
        var nextLoginProcess: LoginProcess?
        
        switch loginProcess {
        case .enterEmail:
            nextLoginProcess = .enterPassword
            
//            emailTextField.isEnabled = false
//            emailTextField.textColor = .init(hexFromString: "#868181")
            
            passwordTextField.rightView = passwordEyeButton
            passwordTextField.rightViewMode = .always
            
            submitButton.setTitle("로그인", for: .normal)
            
            formStackView.insertArrangedSubview(passwordStackView, at: 0)
        case .enterPassword:
            if let email = emailTextField.text, let password = passwordTextField.text {
                /* Test용
                 email: "gusdn5387@naver.com", password: "abcdef!23456"
                 */
                authenticationService.login(email: email, password: password) { [weak self] data in
                    if let accessToken = data.accessToken, let refreshToken = data.refreshToken { // 로그인 성공
                        UserDefaults.standard.set(accessToken, forKey: "jwt")
                        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                        UserDefaults.standard.set(email, forKey: "email")
                        self?.emailLoginSuccess()
                    } else if let _ = data.errorCode, let reason = data.reason { // 로그인 실패
                        self?.emailLoginFail(reason: reason)
                    }
                }
            }
        }
        
        if nextLoginProcess != nil {
            loginProcess = nextLoginProcess!
            titleLabel.text = titles[loginProcess.rawValue]
            submitButton.isEnabled = false
        }
    }
    
    /// 비밀번호 재설정 화면 열기
    @objc private func didTapMoveToPasswordResetLabel(sender: UITapGestureRecognizer){
        navigationController?.pushViewController(PasswordResetViewController(), animated: true)
    }
    
    /// 비밀번호 보기 / 숨기기 클릭 시
    @objc private func didTapPasswordEyeButton(sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        passwordEyeButton.setImage(passwordTextField.isSecureTextEntry ? UIImage(named: "eye_show") : UIImage(named: "eye_hide"), for: .normal)
    }
    
    // MARK: 로그인 처리
    /// 로그인 성공
    func emailLoginSuccess() {
        let vc = TabBarViewController()
        
        if let jwt = UserDefaults.standard.string(forKey: "jwt"), let jwtDecode = JSONWebToken(jsonWebToken: jwt) {
//            print("jwt ::: \(jwt)")
//            print("jwt header ::: \(jwtDecode.header)")
//            print("jwt payload ::: \(jwtDecode.payload)")
            
            UserDefaults.standard.set(jwtDecode.payload.name, forKey: "userName")
        }
        self.view.window?.windowScene?.keyWindow?.rootViewController = vc
    }
    
    /// 로그인 실패
    func emailLoginFail(reason: String) {
        let alert = Helper().alert(title: "로그인 실패", msg: reason)
        self.present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    /// return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
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
        case passwordTextField:
            return string.passwordInputValidate()
        default:
            return true
        }
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct LoginViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        LoginViewController()
    }
}

struct LoginViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        LoginViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
