//
//  AddWorkOutViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/02.
//

import UIKit
import SnapKit
import Then

class AddWorkOutViewController: UIViewController {
    // scrollView 변수 초기화
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension AddWorkOutViewController {
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        self.view.addSubview(scrollView)
        
        // scrollView 위치 잡기
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // contentView 변수 초기화
        let contentView = UIView()
        
        scrollView.addSubview(contentView)
        
        // contentView 위치 잡기
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        // 폼 > stackView 변수 초기화
        let stackView = generateFormStackView()
        
        // 폼 > stackView 위치 잡기
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
        
        // 운동 추가하기 버튼 변수 초기화
        let submitButton = BHSubmitButton(title: "운동 추가하기")
        
        contentView.addSubview(submitButton)
        
        // 운동 추가하기 버튼 위치 잡기
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalTo(scrollView.frameLayoutGuide).inset(30)
        }
    }
    
    /// 폼 StackView 생성
    /// - Returns: 폼 stackView
    fileprivate func generateFormStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 30
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        // 폼 > 이모지 선택 버튼 변수 초기화
        let emojiSelectButton = UIButton().then {
            $0.layer.borderColor = UIColor.init(named: "mainColor")?.cgColor
            $0.layer.borderWidth = 0.5
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
            $0.titleLabel?.font = .systemFont(ofSize: 50)
            $0.setTitle("🔥", for: .normal)
        }
        
        stackView.addArrangedSubview(emojiSelectButton)
        
        // 폼 > 이모지 선택 버튼 위치 잡기
        emojiSelectButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        let textFieldStackView = generateTextFieldStackView(placeholder: "어떤 운동을 하셨나요?")
        
        stackView.addArrangedSubview(textFieldStackView)
        
        textFieldStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        return stackView
    }
    
    /// 입력칭 StackView 생성
    /// - Parameter placeholder: textField placeholder
    /// - Returns: 입력칭 stackView
    fileprivate func generateTextFieldStackView(placeholder: String) -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        // 폼 > 운동 종류 textField 변수 초기화
        let typeTextField = UITextField().then {
            $0.font = .boldSystemFont(ofSize: 16)
            $0.placeholder = placeholder
        }
        
        stackView.addArrangedSubview(typeTextField)
        
        // 폼 > 운동 종류 textField 위치 잡기
        typeTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = UIColor.init(named: "mainColor")
        }
        
        stackView.addArrangedSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        return stackView
    }
}

// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
extension AddWorkOutViewController: UITextFieldDelegate {
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct AddWorkOutViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        AddWorkOutViewController()
    }
}

struct AddWorkOutViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        AddWorkOutViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
