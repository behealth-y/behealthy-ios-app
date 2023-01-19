//
//  DeleteIdViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/10.
//

import UIKit

class DeleteIdViewController: BaseViewController {
    private let titleLabel = UILabel().then {
        $0.text = "안녕하세요, LAURA LEE님!\n그동안 헬시를 이용해주셔서 감사합니다."
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = UIColor.init(named: "mainColor")
        $0.numberOfLines = 0
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "회원 탈퇴를 원하신다면, 하단의 내용 확인을 부탁드립니다."
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var stackView = generateContentStackView()
    
    private lazy var submitButton = BHSubmitButton(title: "탈퇴하기").then {
        $0.addTarget(self, action: #selector(didTapDeleteIdButton), for: .touchUpInside)
    }
    
    private let checkLabel = UILabel().then {
        $0.text = "정말로 헬시를 떠나실건가요? :("
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = UIColor.init(named: "mainColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupViews()
    }
}

// MARK: - Extension
extension DeleteIdViewController {
    // MARK: View
    /// 네비게이션 바 설정
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.title = "회원 탈퇴"
    }
    
    /// 뷰 설정
    fileprivate func setupViews() {
        [titleLabel, descriptionLabel, stackView, submitButton, checkLabel].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.lessThanOrEqualToSuperview().inset(18)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.lessThanOrEqualToSuperview().inset(18)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.lessThanOrEqualToSuperview().inset(18)
        }
        
        submitButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(25)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        checkLabel.snp.makeConstraints {
            $0.bottom.equalTo(submitButton.snp.top).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
    }
    
    /// 회원 탈퇴 주의사항 stackView 생성
    /// - Returns: 회원 탈퇴 주의사항 stackView
    fileprivate func generateContentStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 13
            $0.distribution = .fillEqually
            $0.alignment = .leading
        }
        
        let contents = [
            generateContentLabel(text: "ID가 삭제됩니다."),
            generateContentLabel(text: "회원님의 활동 이력이 삭제됩니다."),
            generateContentLabel(text: "연결된 소셜계정 정보가 삭제됩니다.")
        ]
        
        contents.forEach {
            stackView.addArrangedSubview($0)
        }
        
        return stackView
    }
    
    fileprivate func generateContentLabel(text: String) -> UILabel {
        let label = UILabel().then {
            $0.text = text
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .border
        }
        
        let attributeString = NSMutableAttributedString()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "checkmark")
        attributeString.append(NSAttributedString(attachment: imageAttachment))
        attributeString.append(NSAttributedString(string: " \(text)"))
        label.attributedText = attributeString
        label.sizeToFit()
        
        return label
    }
}

// MARK: - Actions
extension DeleteIdViewController {
    /// 탈퇴하기 눌렀을 때 처리
    @objc fileprivate func didTapDeleteIdButton() {
        navigationController?.popToRootViewController(animated: false)
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        let nav = UINavigationController(rootViewController: LoginViewController())
        
        sceneDelegate.window?.rootViewController = nav
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct DeleteIdViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        DeleteIdViewController()
    }
}

struct DeleteIdViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        DeleteIdViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
