//
//  FirstViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/12/03.
//

import UIKit
import SnapKit
import Then
import AuthenticationServices

class FirstViewController: UIViewController {
    private let appleLoginManager = AppleLoginManager()
    private let kakaoLoginManager = KakaoLoginManager()
    
    private let logoLabel = UILabel().then {
        $0.text = "BE HEALTHY"
        $0.textColor = UIColor(named: "mainColor")
        $0.font = .systemFont(ofSize: 50, weight: .init(900))
    }
    
    private let snsLoginStackView = UIStackView().then {
        $0.spacing = 13
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    // 카카오 로그인 버튼 이미지 설정
    private let kakaoLoginButtonConfig: UIButton.Configuration = {
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = UIColor(hexFromString: "#FEE500")
        config.image = UIImage(named: "kakao-symbol")?.resizeImageTo(size: CGSize(width: 18, height: 18))
        config.imagePadding = 10
        config.imagePlacement = .leading
        config.baseForegroundColor = .black
        
        return config
    }()
    
    // 카카오 로그인 버튼
    private lazy var kakaoLoginButton = UIButton(configuration: kakaoLoginButtonConfig).then {
        $0.setTitle("카카오로 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0)
        $0.layer.cornerRadius = 12.0
        $0.contentMode = .scaleAspectFit
        
        $0.addTarget(self, action: #selector(didTapKakaoLoginButton), for: .touchUpInside)
    }
    
    // 애플 로그인 버튼 이미지 설정
    private let appleLoginButtonConfig: UIButton.Configuration = {
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = .black
        config.image = UIImage(systemName: "applelogo")
        config.imagePadding = 10
        config.imagePlacement = .leading
        
        return config
    }()
    
    // 애플 로그인 버튼
    private lazy var appleLoginButton = UIButton(configuration: appleLoginButtonConfig).then {
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0)
        $0.layer.cornerRadius = 12.0
        
        $0.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
    }
    
    // 이메일로 시작하기 버튼
    private let emailRegisterButton = UIButton().then {
        $0.backgroundColor = UIColor.init(named: "mainColor")
        $0.setTitle("이메일로 시작하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0)
        $0.layer.cornerRadius = 12.0
        $0.addTarget(self, action: #selector(didTapEmailRegisterButton), for: .touchUpInside)
    }
    
    private let orTextView = UIView()
    
    private let borderView = UIView().then {
        $0.backgroundColor = .init(hexFromString: "2E2E2E")
    }
    
    private let borderView2 = UIView().then {
        $0.backgroundColor = .init(hexFromString: "2E2E2E")
    }
    
    // "또는"
    private let orTextLabel = UILabel().then {
        $0.text = "또는"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .init(hexFromString: "2E2E2E")
    }
    
    private lazy var moveToLoginLabel = UILabel().then {
        let text = "이미 Be Healthy 회원이신가요? 로그인"
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: (text as NSString).range(of: "로그인"))
        
        $0.attributedText = attributeString
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .init(hexFromString: "2E2E2E")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMoveToLoginLabel))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        appleLoginManager.setAppleLoginPresentationAnchorView(self)
        appleLoginManager.delegate = self
        
        kakaoLoginManager.delegate = self
    }
}

// MARK: - Extension
extension FirstViewController {
    private func setupLayout() {
        view.backgroundColor = .white
        
        [logoLabel, snsLoginStackView, moveToLoginLabel].forEach {
            view.addSubview($0)
        }
        
        logoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-95)
        }
        
        snsLoginStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(logoLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(moveToLoginLabel.snp.top).offset(-13)
        }
        
        [kakaoLoginButton, appleLoginButton, orTextView, emailRegisterButton].forEach {
            snsLoginStackView.addArrangedSubview($0)
            
            let height = $0 == orTextView ? 20 : 50
            $0.snp.makeConstraints {
                $0.height.equalTo(height)
            }
        }
        
        [borderView, orTextLabel, borderView2].forEach {
            orTextView.addSubview($0)
        }
        
        borderView.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(orTextLabel)
        }
        
        orTextLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalTo(borderView.snp.trailing).offset(30)
            $0.trailing.equalTo(borderView2.snp.leading).offset(-30)
        }
        
        borderView2.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(orTextLabel)
        }
        
        moveToLoginLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(45)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: Actions
    /// 카카오로 로그인
    @objc private func didTapKakaoLoginButton() {
        kakaoLoginManager.kakaoLogin()
    }
    
    /// Apple로 로그인
    @objc private func didTapAppleLoginButton() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleLoginManager
        controller.presentationContextProvider = appleLoginManager
        controller.performRequests()
    }
    
    /// 회원가입 화면 열기
    @objc private func didTapEmailRegisterButton() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    /// 로그인 화면 열기
    @objc private func didTapMoveToLoginLabel(sender: UITapGestureRecognizer){
//        navigationController?.pushViewController(LoginViewController(), animated: true)
        self.view.window?.windowScene?.keyWindow?.rootViewController = TabBarViewController()
    }
}

// MARK: - AppleLoginManagerDelegate
extension FirstViewController: AppleLoginManagerDelegate {
    func appleLoginSuccess() {
        print(#function)
    }
    
    func appleLoginFail() {
        print(#function)
    }
}

// MARK: - KakaoLoginManagerDelegate
extension FirstViewController: KakaoLoginManagerDelegate {
    func kakaoLoginSuccess() {
        print(#function)
        let vc = GoalTimeSettingView()
        vc.openedAuthProcess = true
        view.window?.windowScene?.keyWindow?.rootViewController = vc
    }
    
    func kakaoLoginFail() {
        print(#function)
    }
    
    func kakaoLogoutSuccess() {
        print(#function)
    }
    
    func kakaoLogoutFail() {
        print(#function)
    }
}
