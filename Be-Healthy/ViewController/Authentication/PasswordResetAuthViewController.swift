//
//  PasswordResetAuthViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/27.
//

import UIKit
import SnapKit
import Then

class PasswordResetAuthViewController: BHAuthViewController {
    
    lazy var passwordResetButton = BHSubmitButton(title: "비밀번호 재설정")
    
    var textFields: [BHTextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar("이메일 인증")
        setupScrollView()
        
        setKeyboardObserver()
        titleView.title = "비밀번호 재설정"
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension PasswordResetAuthViewController {
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
        
        let formStackView = generateFormStackView()
        
        contentView.addSubview(formStackView)
        
        formStackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        passwordResetButton.isEnabled = false
        
        // 비밀번호 재설정 버튼 눌렀을 때 처리
        passwordResetButton.addTarget(self, action: #selector(didTapPasswordResetButton), for: .touchUpInside)
        
        contentView.addSubview(passwordResetButton)
        
        passwordResetButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.top.equalTo(formStackView.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().inset(18)
        }
    }
    
    /// 비밀번호 재설정 폼 stackView 생성
    /// - Returns: 비밀번호 재설정 폼 stackView
    fileprivate func generateFormStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 12
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        // 폼 textField StackView 변수 초기화
        let emailStackView = generateTextFieldStackView("이메일 주소", placeholder: "이용 중이신 이메일 주소를 입력하세요.", keyboardType: .emailAddress)
        let certNumberStackView = generateTextFieldStackView("인증번호 입력", placeholder: "인증번호를 입력하세요.", keyboardType: .numberPad)
        
        // 인증번호 요청 버튼 변수 초기화
        let certNumberButton = BHSubmitButton(title: "인증번호 요청")
        
        [emailStackView,
         certNumberButton, certNumberStackView].forEach {
            stackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        return stackView
    }
    
    /// 비밀번호 재설정 폼 > 입력창 stackVeiw 생성
    /// - Parameters:
    ///   - label: textField Label
    ///   - placeholder: textField placeholder
    /// - Returns: 입력창 stackView
    fileprivate func generateTextFieldStackView(_ label: String, placeholder: String, keyboardType: UIKeyboardType = .default) -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 7
            $0.alignment = .center
            $0.axis = .vertical
            $0.distribution = .fill
        }
        
        let label = UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = UIColor(hexFromString: "#2E2E2E")
            $0.text = label
        }
        
        let textField = BHTextField(placeholder: placeholder, keyboardType: keyboardType)
        textField.delegate = self
        
        textFields.append(textField)
        
        [label, textField].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        return stackView
    }
}

// MARK: - Actions
extension PasswordResetAuthViewController {
    /// 비밀번호 재설정_인증 화면 이동
    @objc fileprivate func didTapPasswordResetButton(_ sender: Any) {
        navigationController?.pushViewController(PasswordResetViewController(), animated: true)
    }
}

// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
extension PasswordResetAuthViewController: UITextFieldDelegate {
    // return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // textField 채워지면 비밀번호 재설정 버튼 활성화 되도록
    func textFieldDidChangeSelection(_ textField: UITextField) {
        passwordResetButton.isEnabled = true
        
        textFields.forEach {
            if $0.text?.isEmpty ?? false {
                passwordResetButton.isEnabled = false
            }
        }
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct PasswordResetAuthViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        PasswordResetAuthViewController()
    }
}

struct PasswordResetAuthViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        PasswordResetAuthViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
