//
//  DeleteIdViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/10.
//

import UIKit

class DeleteIdViewController: BHBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar("회원 탈퇴")
        
        titleView.title = "회원 탈퇴"
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension DeleteIdViewController {
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        let contentView = UIView()
        
        view.addSubview(contentView)
        
        // contentView 위치 잡기
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubview(titleView)
        
        // titleView 위치 잡기
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(titleView.snp.width).multipliedBy(0.79 / 1.0)
        }
        
        let titleLabel = UILabel().then {
            $0.text = "안녕하세요, LAURA LEE님!\n그동안 헬시를 이용해주셔서 감사합니다."
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
            $0.textColor = UIColor.init(named: "mainColor")
            $0.numberOfLines = 0
        }
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.lessThanOrEqualToSuperview().inset(18)
        }
        
        let descriptionLabel = UILabel().then {
            $0.text = "회원 탈퇴를 원하신다면, 하단의 내용 확인을 부탁드립니다."
            $0.font = .systemFont(ofSize: 14, weight: .semibold)
        }
        
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.lessThanOrEqualToSuperview().inset(18)
        }
        
        // 회원 탈퇴 주의사항 stackView 변수 초기화
        let stackView = generateContentStackView()
        
        contentView.addSubview(stackView)
        
        // 회원 탈퇴 주의사항 stackView 위치 잡기
        stackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.lessThanOrEqualToSuperview().inset(18)
        }
        
        let submitButton = BHSubmitButton(title: "탈퇴하기")
        submitButton.addTarget(self, action: #selector(didTapDeleteIdButton), for: .touchUpInside)
        
        contentView.addSubview(submitButton)
        
        submitButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        let checkLabel = UILabel().then {
            $0.text = "정말로 헬시를 떠나실건가요? :("
            $0.font = .systemFont(ofSize: 14, weight: .semibold)
            $0.textColor = UIColor.init(named: "mainColor")
        }
        
        contentView.addSubview(checkLabel)
        
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
            $0.textColor = UIColor.init(hexFromString: "B0B0B0")
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
        sceneDelegate.window?.rootViewController = LoginViewController()
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
