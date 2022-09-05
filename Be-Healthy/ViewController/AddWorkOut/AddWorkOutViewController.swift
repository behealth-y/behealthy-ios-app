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
    
    // 선택된 운동 강도 버튼의 tag
    var intensity: Int = 0
    
    // 운동 강도 버튼 변수 초기화
    lazy var intensityButtons: [IntensityButton] = [
        IntensityButton(title: "Very Hard", tag: 0),
        IntensityButton(title: "Hard", tag: 1),
        IntensityButton(title: "Normal", tag: 2),
        IntensityButton(title: "Easy", tag: 3)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setKeyboardObserver()
        setupLayout()
        setupScrollView()
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
            $0.spacing = 30
            $0.alignment = .center
            $0.distribution = .fill
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
        }
        
        // 폼 > 이모지 선택 버튼 변수 초기화
        let emojiTextField = EmojiTextField().then {
            $0.layer.borderColor = UIColor.init(named: "mainColor")?.cgColor
            $0.layer.borderWidth = 0.8
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
            $0.font = .systemFont(ofSize: 50)
            $0.textAlignment = .center
            $0.tintColor = .clear
            $0.text = "🔥"
        }
        
        stackView.addArrangedSubview(emojiTextField)
        
        // 폼 > 이모지 선택 버튼 위치 잡기
        emojiTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        let typeStackView = generateTextFieldStackView(placeholder: "어떤 운동을 하셨나요?", type: "text")
        let dateStackView = generateTextFieldStackView(placeholder: "언제 운동을 하셨나요?", type: "date")
        let timeStackView = generateTextFieldStackView(placeholder: "얼마나 운동을 하셨나요?", type: "time")
        let countStackView = generateTextFieldStackView(placeholder: "운동 세트와 횟수를 알려주세요!", type: "text")
//        let contentStackView = generateTextFieldStackView(placeholder: "내용을 추가해주세요.", type: "content")
        let contentStackView = generateContentStackView()
        
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
    fileprivate func generateTextFieldStackView(placeholder: String, type: String) -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 0.2
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        stackView.snp.makeConstraints {
            $0.height.equalTo(31)
        }
        
        // 폼 > textField 변수 초기화
        let textField = UITextField().then {
            $0.font = .boldSystemFont(ofSize: 16)
            $0.placeholder = placeholder
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.delegate = self
        }
        
        switch type {
        case "date":
            textField.setDatePicker(target: self, selector: #selector(handleDatePicker))
        case "time":
            textField.setDatePicker(target: self, selector: #selector(handleDatePicker), isCount: true)
        default:
            break
        }
        
        stackView.addArrangedSubview(textField)
        
        // 폼 > textField 위치 잡기
        textField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = UIColor.init(named: "mainColor")
        }
        
        stackView.addArrangedSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        return stackView
    }
    
    /// 내용 추가 stackView 생성
    /// - Returns: 내용 추가 stackView
    fileprivate func generateContentStackView() -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 3
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        // 내용 추가 textview 변수 초기화
        let contentView = UITextView().then {
            $0.text = "내용을 추가해주세요."
            $0.textColor = .placeholderText
            $0.font = .boldSystemFont(ofSize: 16)
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.showsHorizontalScrollIndicator = false
            $0.delegate = self
            $0.isScrollEnabled = false
            $0.textContainer.lineFragmentPadding = .zero
        }
        
        stackView.addArrangedSubview(contentView)
        
        // 내용 추가 textview 위치 잡기
        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = UIColor.init(named: "mainColor")
        }
        
        stackView.addArrangedSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.8)
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
            $0.text = "운동 강도를 선택해주세요."
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textColor = UIColor.init(named: "mainColor")
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
        
        intensityButtons.forEach {
            intensitySelectStackView.addArrangedSubview($0)
            $0.addTarget(self, action: #selector(didTapIntensityButton), for: .touchUpInside)
            
            if $0.tag == intensity {
                $0.isSelected = true
                $0.backgroundColor = UIColor(named: "mainColor")
            }
        }
        
        return stackView
    }
    
    /// scrollView touchesBegan 호출 안되는 문제 해결
    func setupScrollView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.isEnabled = true
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Actions
extension AddWorkOutViewController {
    /// 키보드 내리기
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    /// datePicker 선택 시 이벤트 처리
    @objc fileprivate func handleDatePicker() {
        self.view.endEditing(true)
    }
    
    /// 운동 강도 버튼 눌렀을 때 이벤트 처리
    /// - Parameter sender: 운동 강도 버튼
    @objc fileprivate func didTapIntensityButton(_ sender: IntensityButton) {
        intensity = sender.tag
        
        intensityButtons.forEach { button in
            if button.tag == intensity {
                intensityButtons[button.tag].isSelected = true
                intensityButtons[button.tag].backgroundColor = UIColor.init(named: "mainColor")
            } else {
                intensityButtons[button.tag].isSelected = false
                intensityButtons[button.tag].backgroundColor = .clear
            }
        }
    }
}

// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
extension AddWorkOutViewController: UITextFieldDelegate {
    // return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - UITextViewDelegate
extension AddWorkOutViewController: UITextViewDelegate {
    /// textview 높이 자동조절
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach { (constraint) in
            if estimatedSize.height > 30 {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .placeholderText else { return }
        textView.textColor = .label
        textView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 추가해주세요."
            textView.textColor = .placeholderText
        }
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
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height + 5, right: 0.0)
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
