//
//  AddWorkoutViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/02.
//

import UIKit
import SnapKit
import Then
import Combine

class AddWorkoutViewController: UIViewController {
    private let viewModel = WorkoutRecordViewModel(records: [])
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    // 선택된 운동 강도 버튼의 tag
    private var intensity: Int = 0
    
    // 폼 > 이모지 선택 버튼 변수 초기화
    private lazy var emojiTextField = EmojiTextField().then {
        $0.layer.borderColor = UIColor.border.cgColor
        $0.layer.borderWidth = 0.8
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
        $0.font = .systemFont(ofSize: 50)
        $0.textAlignment = .center
        $0.tintColor = .clear
        $0.text = "🔥"
    }
    
    private lazy var typeTextField = UITextField().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.placeholder = "어떤 운동을 하셨나요?"
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.delegate = self
    }
    
    private lazy var dateTextField = UITextField().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.placeholder = "언제 운동을 하셨나요?"
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.delegate = self
        $0.setDatePicker(target: self, selector: #selector(handleDatePicker))
    }
    
    private lazy var startTimeTextField = UITextField().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.placeholder = "운동 시작 시간을 알려주세요!"
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.delegate = self
        $0.setDatePicker(target: self, selector: #selector(handleStartTimePicker), isTime: true)
    }
    
    private lazy var endTimeTextField = UITextField().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.placeholder = "운동 종료 시간을 알려주세요!"
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.delegate = self
        $0.setDatePicker(target: self, selector: #selector(handleEndTimePicker), isTime: true)
    }
    
    private lazy var commentTextField = UITextField().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.placeholder = "한줄평을 입력해주세요. :)"
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.delegate = self
    }
    
    // 운동 강도 버튼 변수 초기화
    private lazy var intensityButtons: [IntensityButton] = [
        IntensityButton(title: "매우 힘듦", tag: 0),
        IntensityButton(title: "힘듦", tag: 1),
        IntensityButton(title: "적당함", tag: 2),
        IntensityButton(title: "쉬웠음", tag: 3)
    ]
    
    private lazy var submitButton = BHSubmitButton(title: "운동 추가하기").then {
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        bind()
    }
}

// MARK: - Extension
extension AddWorkoutViewController {
    // MARK: View
    private func setupViews() {
        view.addSubview(submitButton)
        
        // 폼 > stackView 변수 초기화
        let stackView = generateFormStackView()
        
        view.addSubview(stackView)
        
        // 폼 > stackView 위치 잡기
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 운동 추가하기 버튼 위치 잡기
        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(30)
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
        
        stackView.addArrangedSubview(emojiTextField)
        
        // 폼 > 이모지 선택 버튼 위치 잡기
        emojiTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        let typeStackView = generateTextFieldStackView(textField: typeTextField)
        let dateStackView = generateTextFieldStackView(textField: dateTextField)
        let startTimeStackView = generateTextFieldStackView(textField: startTimeTextField)
        let endTimeStackView = generateTextFieldStackView(textField: endTimeTextField)
        let commentStackView = generateTextFieldStackView(textField: commentTextField)
        
        [typeStackView, dateStackView, startTimeStackView, endTimeStackView, commentStackView].forEach {
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
            $0.bottom.equalToSuperview().inset(30)
        }
        
        return stackView
    }
    
    /// 입력칭 StackView 생성
    /// - Parameter placeholder: textField placeholder
    /// - Returns: 입력창 stackView
    fileprivate func generateTextFieldStackView(textField: UITextField) -> UIStackView {
        let stackView = UIStackView().then {
            $0.spacing = 0.2
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        stackView.snp.makeConstraints {
            $0.height.equalTo(31)
        }
        
        stackView.addArrangedSubview(textField)
        
        // 폼 > textField 위치 잡기
        textField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = .border
        }
        
        stackView.addArrangedSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
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
            $0.font = .systemFont(ofSize: 15, weight: .init(500))
            $0.textColor = UIColor.init(hexFromString: "#2E2E2E")
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
                $0.backgroundColor = UIColor(hexFromString: "#2E2E2E")
            }
        }
        
        return stackView
    }
    
    // MARK: Bind
    private func bind() {
        [typeTextField, dateTextField, startTimeTextField, endTimeTextField, commentTextField].forEach {
            let textField = $0
            
            $0.textPublisher.sink { [weak self] _ in
                self?.checkSubmitButtonEnable()
            }.store(in: &cancellables)
        }
    }
    
    /// "운동 추가하기" 버튼 활성화 / 비활설화 처리
    private func checkSubmitButtonEnable() {
        let type = typeTextField.text ?? ""
        let date = dateTextField.text ?? ""
        let startTime = startTimeTextField.text ?? ""
        let endTime = endTimeTextField.text ?? ""
        let comment = commentTextField.text ?? ""
        
        if type.count > 0 && date.count > 0 && startTime.count > 0 && endTime.count > 0, comment.count > 0 {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    // MARK: Actions
    /// 키보드 내리기
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // TODO: datePicker 선택 시 이벤트 처리
    /// datePicker 선택 시 이벤트 처리
    @objc private func handleDatePicker() {
        self.view.endEditing(true)
        
        if let datePickerView = dateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY년 MM월 dd일"
            let dateString = dateFormatter.string(from: datePickerView.date)

            dateTextField.text = dateString
            
            checkSubmitButtonEnable()
        }	
    }
    
    /// startTimePicker 선택 시 이벤트 처리
    @objc private func handleStartTimePicker() {
        self.view.endEditing(true)
        
        if let datePickerView = startTimeTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH시 mm분"
            let dateString = dateFormatter.string(from: datePickerView.date)

            startTimeTextField.text = dateString
            
            checkSubmitButtonEnable()
        }
    }
    
    /// endTimePicker 선택 시 이벤트 처리
    @objc private func handleEndTimePicker() {
        self.view.endEditing(true)
        
        if let datePickerView = endTimeTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH시 mm분"
            let dateString = dateFormatter.string(from: datePickerView.date)

            endTimeTextField.text = dateString
            
            checkSubmitButtonEnable()
        }
    }
    
    /// 운동 강도 버튼 눌렀을 때 이벤트 처리
    /// - Parameter sender: 운동 강도 버튼
    @objc private func didTapIntensityButton(_ sender: IntensityButton) {
        intensity = sender.tag
        
        intensityButtons.forEach { button in
            if button.tag == intensity {
                intensityButtons[button.tag].isSelected = true
                intensityButtons[button.tag].backgroundColor = UIColor.init(hexFromString: "#2E2E2E")
            } else {
                intensityButtons[button.tag].isSelected = false
                intensityButtons[button.tag].backgroundColor = .clear
            }
        }
    }
    
    /// 운동 추가하기 버튼 클릭 시
    @objc private func didTapSubmitButton() {
        let emoji = emojiTextField.text ?? "💪"
        let workoutName = typeTextField.text ?? ""
        let date = dateTextField.text ?? "0000-00-00"
        let startTime = startTimeTextField.text ?? "00:00"
        let endTime = endTimeTextField.text ?? "00:00"
        let comment = commentTextField.text ?? ""
        
        
        
        let record = WorkoutRecordForDate(emoji: emoji,
                                          workoutName: workoutName,
                                          startTime: "\(startTime):00",
                                          endTime: "\(endTime):00",
                                          intensity: getIntensityText(),
                                          comment: comment)
        
        print(record)
    }
    
    // MARK: Helpers
    func getIntensityText() -> String {
        switch intensity {
        case 1:
            return "NORMAL"
        case 2:
            return "HARD"
        case 3:
            return "EXTREMELY_HARD"
        default:
            return "EASY"
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddWorkoutViewController: UITextFieldDelegate {
    // return 키 눌렀을 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct AddWorkoutViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        AddWorkoutViewController()
    }
}

struct AddWorkoutViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        AddWorkoutViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
