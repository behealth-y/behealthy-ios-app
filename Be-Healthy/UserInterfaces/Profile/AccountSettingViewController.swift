//
//  AccountSettingViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/09.
//

import UIKit

class AccountSettingViewController: BHBaseViewController {
    lazy var nicknameTextField = BHTextField().then {
        $0.placeholder = "변경하실 닉네임을 입력해주세요! (국/영문 최대 2~8자)"
        $0.keyboardType = .emailAddress
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar("계정 설정")
        setupScrollView()
        
        setKeyboardObserver()
        titleView.title = "계정 설정"
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension AccountSettingViewController {
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
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 25
            $0.distribution = .fill
            $0.alignment = .center
        }
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview()
        }
        
        let emailView = generateEmailView()
        let passwordResetView = generatePasswordResetView()
        let nicknameEditView = generateNicknameEditView()
        
        [emailView, passwordResetView, nicknameEditView].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(18)
            }
        }
        
        let submitButton = BHSubmitButton(title: "수정 완료")
        
        contentView.addSubview(submitButton)
        
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.top.equalTo(stackView.snp.bottom).offset(25)
        }
        
        let buttonStackView = generateButtonStackView()
        
        contentView.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(submitButton.snp.bottom).offset(25)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    /// 이메일 뷰 생성
    /// - Returns: 이메일 뷰
    fileprivate func generateEmailView() -> UIView {
        let view = UIView()
        
        view.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        let titleLabel = UILabel().then {
            $0.text = "이메일"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        let emailLabel = UILabel().then {
            $0.text = "laura.lee.x316@gmail.com"
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = UIColor.init(hexFromString: "868181")
        }
        
        view.addSubview(emailLabel)
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(10)
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = .border
        }
        
        view.addSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        return view
    }
    
    /// 비밀번호 변경 뷰 생성
    /// - Returns: 비밀번호 변경 뷰
    fileprivate func generatePasswordResetView() -> UIView {
        let view = UIView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPasswordResetView))
        view.addGestureRecognizer(tapGesture)
        
        view.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        let titleLabel = UILabel().then {
            $0.text = "비밀번호 변경"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        let imageView = UIImageView().then {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .black
        }
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
        
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = .border
        }
        
        view.addSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        return view
    }
    
    /// 닉네임 재설정 뷰 생성
    /// - Returns: 닉네임 재설정 뷰
    fileprivate func generateNicknameEditView() -> UIView {
        let view = UIView()
        
        view.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        let titleLabel = UILabel().then {
            $0.text = "닉네임"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        let textFieldView = BHTextFieldView(textField: nicknameTextField)
        
        view.addSubview(textFieldView)
        
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
        }
        
        return view
    }
    
    fileprivate func generateButtonStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 15
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        // 로그아웃 이동 버튼 변수 초기화
        let logoutButton = UIButton().then {
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(.border, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 12.0)
            $0.addUnderLine()
        }
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        let divisionView = UIView().then {
            $0.backgroundColor = UIColor.init(named: "mainColor")
        }
        
        divisionView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(12)
        }
        
        // 회원탈퇴 이동 버튼 변수 초기화
        let deleteIdButton = UIButton().then {
            $0.setTitle("회원탈퇴", for: .normal)
            $0.setTitleColor(.border, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 12.0)
            $0.addUnderLine()
        }
        deleteIdButton.addTarget(self, action: #selector(didTapDeleteIdButton), for: .touchUpInside)
        
        [logoutButton, divisionView, deleteIdButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }
}

// MARK: - Actions
extension AccountSettingViewController {
    /// 비밀번호 변경 눌렀을 때 처리
    @objc fileprivate func didTapPasswordResetView() {
        navigationController?.pushViewController(PasswordResetAuthViewController(), animated: true)
    }
    
    /// 로그아웃 눌렀을 때 처리
    @objc fileprivate func didTapLogoutButton() {
        navigationController?.popToRootViewController(animated: false)
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        let nav = UINavigationController(rootViewController: LoginViewController())
        
        sceneDelegate.window?.rootViewController = nav
    }
    
    /// 회원탈퇴 눌렀을 때 처리
    @objc fileprivate func didTapDeleteIdButton() {
        navigationController?.pushViewController(DeleteIdViewController(), animated: true)
    }
}

// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
extension AccountSettingViewController: UITextFieldDelegate {
    // return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct AccountSettingViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        AccountSettingViewController()
    }
}

struct AccountSettingViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        AccountSettingViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
