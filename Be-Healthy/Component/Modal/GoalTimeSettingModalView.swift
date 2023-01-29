//
//  GoalTimeSettingModalView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/12/29.
//

import UIKit
import SnapKit
import Then

protocol GoalTimeSettingModalViewDelegate: NSObject {
    func setGoalTime(hour: Int, minute: Int)
}

final class GoalTimeSettingModalView: BaseViewController {
    weak var delegate: GoalTimeSettingModalViewDelegate?
    
    // MARK: - 뷰
    // 배경 뷰
    private lazy var dimmedView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.5
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
//        $0.isUserInteractionEnabled = true
//        $0.addGestureRecognizer(tapGesture)
    }
    
    // 모달 뷰
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }
    
    // TODO: - 모달 > 닫기
    
    // MARK: - 모달 > 타이틀
    private let titleLabel = UILabel().then {
        $0.text = "⏱ 목표 시간 설정"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    // MARK: - 모달 > 시간 설정
    private lazy var hourTextField = UITextField().then {
        $0.placeholder = "00"
        $0.font = .boldSystemFont(ofSize: 60)
        $0.textAlignment = .center
        
        $0.keyboardType = .numberPad
        
        $0.delegate = self
    }
    
    private let hourBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    // MARK: - 모달 > 분 설정
    private lazy var minuteTextField = UITextField().then {
        $0.placeholder = "00"
        $0.font = .boldSystemFont(ofSize: 60)
        $0.textAlignment = .center
        
        $0.keyboardType = .numberPad
        
        $0.delegate = self
    }
    
    private let minuteBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    private let colonLabel = UILabel().then {
        $0.text = ":"
        $0.font = .boldSystemFont(ofSize: 60)
    }
    
    // MARK: - 폼 제출 버튼
    private lazy var submitButton = BHSubmitButton(title: "설정완료").then {
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboardObserver()
        setupViews()
    }
}

// MARK: - Extension
extension GoalTimeSettingModalView {
    // MARK: View
    private func setupViews() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let contentView = UIView()
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.edges.equalTo(scrollView)
        }

        [dimmedView, containerView].forEach {
            contentView.addSubview($0)
        }

        dimmedView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.frameLayoutGuide)
        }

        containerView.snp.makeConstraints {
            $0.bottom.equalTo(dimmedView)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(300)
        }

        [titleLabel, hourTextField, minuteTextField, hourBottomBorder, minuteBottomBorder, colonLabel, submitButton].forEach {
            containerView.addSubview($0)
        }

        colonLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-25)
        }

        hourTextField.snp.makeConstraints {
            $0.centerY.equalTo(colonLabel)
            $0.trailing.equalTo(colonLabel.snp.leading).offset(-10)
            $0.leading.greaterThanOrEqualToSuperview().inset(10)
        }

        minuteTextField.snp.makeConstraints {
            $0.centerY.equalTo(colonLabel)
            $0.leading.equalTo(colonLabel.snp.trailing).offset(10)
            $0.trailing.lessThanOrEqualToSuperview().inset(10)
        }
        
        [hourBottomBorder, minuteBottomBorder].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
        
        hourBottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalTo(hourTextField)
            $0.top.equalTo(hourTextField.snp.bottom)
        }
        
        minuteBottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalTo(minuteTextField)
            $0.top.equalTo(minuteTextField.snp.bottom)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(colonLabel)
            $0.bottom.equalTo(hourTextField.snp.top).offset(-20)
        }

        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    // MARK: Actions
    /// 모달 닫기
    @objc private func dismissView() {
        print(#function)
        
        self.dismiss(animated: false)
    }
    
    /// 목표 운동 시간 설정
    @objc private func didTapSubmitButton() {
        if let hour = hourTextField.text, let minute = minuteTextField.text {
            delegate?.setGoalTime(hour: Int(hour) ?? 0, minute: Int(minute) ?? 0)
            self.dismiss(animated: false)
        }
    }
}

// MARK: - UITextFieldDelegate
extension GoalTimeSettingModalView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        // 백 스페이스 감지
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
                    
        if text.count < 2 {
            switch textField {
            case hourTextField:
                // 최대 23시간
                if let hour = Int(text + string), hour > 23 {
                    textField.text = "23"
                    return false
                }
            case minuteTextField:
                // 최대 59분
                if let minute = Int(text + string), minute > 59 {
                    textField.text = "59"
                    return false
                }
            default:
                break
            }

            return true
        } else {
            // 시간 / 분 2글자 넘어가면 마지막으로 입력한 숫자로 변경
            textField.text = string
            return false
        }
    }
}
