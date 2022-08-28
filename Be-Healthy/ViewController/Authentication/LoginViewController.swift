//
//  LoginViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import Then
import SnapKit

class LoginViewController: BHAuthViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar("로그인")
        setupScrollView()
        
        titleView.title = "로그인"
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension LoginViewController {
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
        
        // 오류 메시지 label 변수 초기화
        let errorMsgLabel = UILabel().then {
            $0.text = "이메일 또는 비밀번호를 다시 입력해주세요."
            $0.font = .systemFont(ofSize: 12.0)
            $0.textColor = .systemRed
        }
        
        contentView.addSubview(errorMsgLabel)
        
        // 오류 메시지 label 위치 잡기
        errorMsgLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.greaterThanOrEqualToSuperview().offset(18)
        }
        
        // 이메일 / 비밀번호 폼 stackView 변수 초기화
        let formStackView = generateFormStackView()
        
        contentView.addSubview(formStackView)
        
        // 이메일 / 비밀번호 폼 위치 잡기
        formStackView.snp.makeConstraints {
            $0.top.equalTo(errorMsgLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        // 회원가입 이동 안내 문구 stackView 변수 초기화
        let registerStackView = generateRegisterStackView()
        
        contentView.addSubview(registerStackView)
        
        // 회원가입 이동 stackView 위치 잡기
        registerStackView.snp.makeConstraints {
            $0.top.equalTo(formStackView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(18)
        }
        
        // 비밀번호 찾기 버튼 변수 초기화
        let passwordFindButton = UIButton().then {
            $0.setTitle("비밀번호 찾기", for: .normal)
            $0.setTitleColor(.darkGray, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 12.0)
        }
        
        // 비밀번호 찾기 버튼 눌렀을 때 처리
        passwordFindButton.addTarget(self, action: #selector(didTapPasswordResetButton), for: .touchUpInside)
        
        contentView.addSubview(passwordFindButton)
        
        // 비밀번호 찾기 버튼 위치 잡기
        passwordFindButton.snp.makeConstraints {
            $0.centerY.equalTo(registerStackView)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        // 로그인 버튼 변수 초기화
        let loginButton = BHSubmitButton(title: "로그인")
        
        contentView.addSubview(loginButton)
        
        // 로그인 버튼 위치 잡기
        loginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.top.equalTo(registerStackView.snp.bottom).offset(10)
        }
        
        // SNS 로그인 stackView 변수 초기화
        let snsLoginStackView = generateSnsLoginStackView()
        
        contentView.addSubview(snsLoginStackView)
        
        // SNS 로그인 stackView 변수 초기화
        snsLoginStackView.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
    }
    
    /// 이메일 / 비밀번호 폼 stackView 생성
    /// - Returns: 이메일 / 비밀번호 폼 stackView
    fileprivate func generateFormStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 10
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.axis = .vertical
        }
        
        // 이메일 / 비밀번호 textField 변수 초기화
        let emailTextField = BHTextField(placeholder: "이메일을 입력하세요.", keyboardType: .emailAddress)
        let pwTextField = BHTextField(placeholder: "비밀번호를 입력하세요.", secure: true)
        
        [emailTextField, pwTextField].forEach {
            stackView.addArrangedSubview($0)
            $0.delegate = self
            
            // 이메일 / 비밀번호 textField 위치 잡기
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        return stackView
    }
    
    /// 회원가입 이동 안내 문구 stackView 생성
    /// - Returns: 회원가입 이동 안내 문구 stackView
    fileprivate func generateRegisterStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 4
            $0.distribution = .fill
            $0.axis = .horizontal
        }
        
        // 회원가입 label 변수 초기화
        let registerLabel = UILabel().then {
            $0.text = "HEALTHY가 처음이신가요?"
            $0.font = .systemFont(ofSize: 12.0)
            $0.textColor = .darkGray
        }
        
        // 회원가입 이동 버튼 변수 초기화
        let registerButton = UIButton().then {
            $0.setTitle("회원가입", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 12.0)
            $0.addUnderLine()
        }
        
        // 회원가입 버튼 눌렀을 때 처리
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        
        [registerLabel, registerButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }
    
    /// SNS 로그인 stackView 생성
    /// - Returns: SNS 로그인 stackView
    fileprivate func generateSnsLoginStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 13
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        // 카카오 로그인 버튼 이미지 설정
        var kakaoButtonConfig = UIButton.Configuration.filled()
        kakaoButtonConfig.baseBackgroundColor = UIColor(hexFromString: "#FEE500")
        kakaoButtonConfig.image = UIImage(named: "kakao-symbol")?.resizeImageTo(size: CGSize(width: 18, height: 18))
        kakaoButtonConfig.imagePadding = 10
        kakaoButtonConfig.imagePlacement = .leading
        kakaoButtonConfig.baseForegroundColor = .red
        
        // 카카오 로그인 버튼
        let kakaoButton = UIButton(configuration: kakaoButtonConfig).then {
            $0.setTitle("카카오로 로그인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16.0)
            $0.layer.cornerRadius = 12.0
            $0.contentMode = .scaleAspectFit
        }
        
        // 애플 로그인 버튼 이미지 설정
        var appleButtonConfig = UIButton.Configuration.filled()
        appleButtonConfig.baseBackgroundColor = .black
        appleButtonConfig.image = UIImage(systemName: "applelogo")
        appleButtonConfig.imagePadding = 10
        appleButtonConfig.imagePlacement = .leading
        
        // 애플로그인 버튼
        let appleButton = UIButton(configuration: appleButtonConfig).then {
            $0.setTitle("Apple로 로그인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16.0)
            $0.layer.cornerRadius = 12.0
        }
        
        // 카카오 / 애플 로그인 버튼 위치 잡기
        [kakaoButton, appleButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }
        
        stackView.addArrangedSubview(kakaoButton)
        stackView.addArrangedSubview(appleButton)
        
        return stackView
    }
}

// MARK: - Actions
extension LoginViewController {
    /// 회원가입 화면 이동
    @objc fileprivate func didTapRegisterButton(_ sender: Any) {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    /// 비밀번호 재설정_인증 화면 이동
    @objc fileprivate func didTapPasswordResetButton(_ sender: Any) {
        navigationController?.pushViewController(PasswordResetAuthViewController(), animated: true)
    }
}

// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
extension LoginViewController: UITextFieldDelegate {
    // return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
