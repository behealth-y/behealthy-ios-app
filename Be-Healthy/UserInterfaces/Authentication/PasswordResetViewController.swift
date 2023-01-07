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
    case enterAuthNumber
    case enterPassword
    case enterPasswordConfirm
}

class PasswordResetViewController: BaseViewController {
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var passwordResetProcess: PasswordResetProcess = .enterEmail
    
    // 입력 확인 여부
    private var enteredEmail = false
    private var enteredAuthNumber = false
    private var enteredPassword = false
    private var enteredPasswordConfirm = false
    
    // 인증코드 확인 여부
    private var isConfirmAuthNumber = false
    private var authNumber: String?
    
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
    private let authNumberStackView = UIStackView().then {
        $0.spacing = 3
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let authNumberLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .init(hexFromString: "#2E2E2E")
        $0.text = "인증번호"
    }
    
    private lazy var authNumberTextField = BHTextField().then {
        $0.placeholder = "인증번호를 입력해주세요."
        $0.keyboardType = .numberPad
        $0.delegate = self
    }
    
    private let authNumberFieldStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 0
    }
    
    private let authNumberResendLabel = UILabel().then {
        let attribute = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let attributeString = NSMutableAttributedString(string: "재발송", attributes: attribute)
        
        $0.attributedText = attributeString
        
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let authNumberBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    private let authNumberErrorLabel = UILabel().then {
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
        [emailTextField, authNumberTextField, passwordTextField, passwordConfirmTextField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(60)
            }
        }
        
        [emailBottomBorder, authNumberBottomBorder, passwordBottomBorder, passwordConfirmBottomBorder].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
        
        [emailLabel, emailTextField, emailBottomBorder, emailErrorLabel].forEach {
            emailStackView.addArrangedSubview($0)
        }
        
        [authNumberTextField, authNumberResendLabel].forEach {
            authNumberFieldStackView.addArrangedSubview($0)
        }
        
        [authNumberLabel, authNumberFieldStackView, authNumberBottomBorder, authNumberErrorLabel].forEach {
            authNumberStackView.addArrangedSubview($0)
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
        [emailTextField, authNumberTextField, passwordTextField, passwordConfirmTextField].forEach {
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
        case authNumberTextField:
            if text.authNumberValidate() {
                authNumberBottomBorder.backgroundColor = .lightGray
                authNumberErrorLabel.isHidden = true
                
                textField.resignFirstResponder()
                
                enteredAuthNumber = true
            } else {
                authNumberBottomBorder.backgroundColor = .systemRed
                authNumberErrorLabel.isHidden = false
                
                enteredAuthNumber = false
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
            (enteredAuthNumber && passwordResetProcess == .enterAuthNumber) ||
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
            nextPasswordResetProcess = .enterAuthNumber
            
            emailTextField.isEnabled = false
            emailTextField.textColor = .init(hexFromString: "#868181")
            
            submitButton.setTitle("인증번호 확인", for: .normal)
            
            formStackView.insertArrangedSubview(authNumberStackView, at: 0)
        case .enterAuthNumber:
            nextPasswordResetProcess = .enterPassword
            
            authNumberTextField.isEnabled = false
            authNumberTextField.textColor = .init(hexFromString: "#868181")
            
            submitButton.setTitle("다음", for: .normal)
            
            authNumberResendLabel.isHidden = true
            
            formStackView.insertArrangedSubview(passwordStackView, at: 0)
        case .enterPassword:
            nextPasswordResetProcess = .enterPasswordConfirm
            
            submitButton.setTitle("변경하기", for: .normal)
            
            formStackView.insertArrangedSubview(passwordConfirmStackView, at: 0)
        case .enterPasswordConfirm:
            navigationController?.popViewController(animated: true)
        }
        
        if nextPasswordResetProcess != nil {
            passwordResetProcess = nextPasswordResetProcess!
            titleLabel.text = titles[passwordResetProcess.rawValue]
            submitButton.isEnabled = false
        }
    }
}

// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
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
        case authNumberTextField:
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
