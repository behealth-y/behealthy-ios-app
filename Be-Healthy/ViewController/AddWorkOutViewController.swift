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
        
        setKeyboardObserver()
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
        
        contentView.addSubview(stackView)
        
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
            $0.spacing = 40
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        // 폼 > 이모지 선택 버튼 변수 초기화
        let emojiSelectButton = UIButton().then {
            $0.layer.borderColor = UIColor.init(named: "mainColor")?.cgColor
            $0.layer.borderWidth = 1
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
        
        let typeStackView = generateTextFieldStackView(placeholder: "어떤 운동을 하셨나요?")
        let dateStackView = generateTextFieldStackView(placeholder: "언제 운동을 하셨나요?")
        let timeStackView = generateTextFieldStackView(placeholder: "시간을 설정해주세요. :)")
        let countStackView = generateTextFieldStackView(placeholder: "세트와 횟수를 설정해주세요. :)")
        let contentStackView = generateTextFieldStackView(placeholder: "내용을 추가해주세요.")
        
        [typeStackView, dateStackView, timeStackView, countStackView, contentStackView].forEach {
            stackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(18)
            }
        }
        
        // 폼 > 운동 강도 선택 stackView 변수 초기화
        let intensityStackView = generateIntensityStackView()
        
        stackView.addArrangedSubview(intensityStackView)
        
        // 폼 > 운동 강도 선택 stackView 위치 잡기
        intensityStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        return stackView
    }
    
    /// 입력칭 StackView 생성
    /// - Parameter placeholder: textField placeholder
    /// - Returns: 입력창 stackView
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
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.delegate = self
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
            $0.height.equalTo(1)
        }
        
        return stackView
    }
    
    /// 운동 강도 stackView 생성
    /// - Returns: 운동강도 stackView
    fileprivate func generateIntensityStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 15
            $0.alignment = .leading
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        let intensityTitleLabel = UILabel().then {
            $0.text = "운동 강도를 선택해주세요"
            $0.font = .boldSystemFont(ofSize: 14)
        }
        
        stackView.addArrangedSubview(intensityTitleLabel)
        
        // 운동 강도 버튼 stackView 변수 초기화
        let intensitySelectStackView = UIStackView().then {
            $0.spacing = 10
            $0.distribution = .fillEqually
            $0.axis = .horizontal
        }
        
        stackView.addArrangedSubview(intensitySelectStackView)
        
        intensitySelectStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 운동 강도 버튼 변수 초기화
        let intensityVeryHighButton = IntensityButton(title: "매우 힘듦")
        let intensityHighButton = IntensityButton(title: "힘듦")
        let intensityMidiumButton = IntensityButton(title: "적당함")
        let intensityLowButton = IntensityButton(title: "할 만했음")
        
        [intensityVeryHighButton, intensityHighButton, intensityMidiumButton, intensityLowButton].forEach {
            intensitySelectStackView.addArrangedSubview($0)
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

// MARK: - 키보드가 textField 가리는 문제 해결
extension AddWorkOutViewController {
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 키보드 나타날 때 키보드 높이만큼 스크롤
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
        scrollView.contentInset = contentInset
    }
    
    /// 키보드 숨길때 키보드 높이만큼 스크롤 되었던 거 복구
    @objc func keyboardWillHide(notification: NSNotification) {
       guard let userInfo = notification.userInfo,
             let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
           return
       }
       scrollView.contentInset = .zero
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
