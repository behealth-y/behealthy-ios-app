//
//  AccountSettingViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/09.
//

import UIKit
import Combine

class AccountSettingViewController: BaseViewController {
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let authenticationService = AuthenticationService()
    
    private let email = UserDefaults.standard.string(forKey: "email") ?? ""
    
    // MARK: 닉네임
    private lazy var nicknameTextField = BHTextField().then {
        $0.placeholder = "변경하실 닉네임을 입력해주세요! (국/영문 최대 2~8자)"
        $0.keyboardType = .emailAddress
        $0.delegate = self
    }
    
    // MARK: 회원탈퇴
    // 회원탈퇴 이동 버튼 변수 초기화
    private lazy var deleteIdButton = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.setTitleColor(.border, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12.0)
        $0.addUnderLine()
        $0.addTarget(self, action: #selector(didTapDeleteIdButton), for: .touchUpInside)
    }
    
    private lazy var submitButton = BHSubmitButton(title: "수정 완료").then {
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
        bind()
    }
}

// MARK: - Extension
extension AccountSettingViewController {
    // MARK: View
    /// 네비게이션 바 설정
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.title = "계정 설정"
    }
    
    /// 뷰 설정
    fileprivate func setupViews() {
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fill
            $0.alignment = .leading
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        let emailView = generateEmailView()
        let passwordResetView = generatePasswordResetView()
        let nicknameEditView = generateNicknameEditView()
        let logoutView = generateLogoutView()
        
        [emailView, passwordResetView, nicknameEditView, logoutView, deleteIdButton].forEach {
            stackView.addArrangedSubview($0)
            
            if $0 != deleteIdButton {
                $0.snp.makeConstraints { make in
                    make.horizontalEdges.equalToSuperview()
                }
            }
        }
        view.addSubview(submitButton)
        
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    /// 이메일 뷰 생성
    /// - Returns: 이메일 뷰
    fileprivate func generateEmailView() -> UIView {
        let view = UIView()
        
        let titleLabel = UILabel().then {
            $0.text = "이메일"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        let emailLabel = UILabel().then {
            $0.text = "\(email)"
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = UIColor.init(hexFromString: "868181")
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = .border
        }
        
        [titleLabel, emailLabel, bottomBorder].forEach {
            view.addSubview($0)
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(10)
        }
        
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
        
        let titleLabel = UILabel().then {
            $0.text = "비밀번호 변경"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        let imageView = UIImageView().then {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .black
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = .border
        }
        
        [titleLabel, imageView, bottomBorder].forEach {
            view.addSubview($0)
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
        
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
        
        let titleLabel = UILabel().then {
            $0.text = "닉네임"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        let textFieldView = BHTextFieldView(textField: nicknameTextField)
        
        [titleLabel, textFieldView].forEach {
            view.addSubview($0)
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(105)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalToSuperview()
        }
        
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        return view
    }
    
    /// 로그아웃 뷰 생성
    /// - Returns: 로그아웃 뷰
    fileprivate func generateLogoutView() -> UIView {
        let view = UIView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLogoutView))
        view.addGestureRecognizer(tapGesture)
        
        let titleLabel = UILabel().then {
            $0.text = "로그아웃"
            $0.font = .boldSystemFont(ofSize: 18)
        }
        
        let imageView = UIImageView().then {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .black
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = .border
        }
        
        [titleLabel, imageView, bottomBorder].forEach {
            view.addSubview($0)
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
        
        bottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        return view
    }
    
    // MARK: Bind
    private func bind() {
        [nicknameTextField].forEach {
            $0.textPublisher.sink { [weak self] _ in
                guard let self = self, let text = self.nicknameTextField.text else { return }
                
                if text.nicknameValiate() {
                    self.submitButton.isEnabled = true
                } else {
                    self.submitButton.isEnabled = false
                }
            }.store(in: &cancellables)
        }
    }
    
    // MARK: Actions
    /// 비밀번호 변경 눌렀을 때 처리
    @objc fileprivate func didTapPasswordResetView() {
        navigationController?.pushViewController(PasswordResetViewController(), animated: true)
    }
    
    /// 로그아웃 눌렀을 때 처리
    @objc fileprivate func didTapLogoutView() {
        UserDefaults.standard.removeObject(forKey: "jwt")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "goalTime")
        UserDefaults.standard.removeObject(forKey: "email")
        
        navigationController?.popToRootViewController(animated: false)
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        let nav = UINavigationController(rootViewController: FirstViewController())
        
        sceneDelegate.window?.rootViewController = nav
    }
    
    /// 회원탈퇴 눌렀을 때 처리
    @objc fileprivate func didTapDeleteIdButton() {
        navigationController?.pushViewController(DeleteIdViewController(), animated: true)
    }
    
    /// 수정 완료 버튼 클릭 시
    @objc private func didTapSubmitButton(_ sender: Any) {
        guard let nickname = nicknameTextField.text else { return }
        
        authenticationService.changeNickname(nickname) { [weak self] data in
            if let statusCode = data.statusCode {
                switch statusCode {
                case 200:
                    self?.changeNicknameSuccess(nickname)
                default:
                    guard let errorData = data.errorData else { return }
                    print(errorData)
                    self?.changeNicknameFail()
                }
            }
        }
    }
    
    /// 닉네임 변경 성공
    private func changeNicknameSuccess(_ nickname: String) {
        print(#function)
        
        UserDefaults.standard.set(nickname, forKey: "userName")
        navigationController?.popViewController(animated: true)
    }
     
    /// 닉네임 변경 실패
    private func changeNicknameFail() {
        print(#function)
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
