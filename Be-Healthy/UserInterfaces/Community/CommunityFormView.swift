//
//  CommunityFormView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/15.
//

import UIKit
import SnapKit
import Then
import PhotosUI

final class CommunityFormView: BaseViewController {
    private var configuration = PHPickerConfiguration()
    
    private let stackView = UIStackView().then {
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    // MARK: 이미지 폼
    
    // MARK: 내용
    private lazy var contentTextView = UITextView().then {
        $0.text = "오늘 운동은 어떠셨는지, 이야기를 들려주세요. :)"
        $0.textColor = .placeholderText
        $0.font = .boldSystemFont(ofSize: 16)
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.isScrollEnabled = true
        $0.textContainer.lineFragmentPadding = .zero
    }
    
    // MARK: 만족도
    private lazy var satisfactionButtonStackView = UIStackView().then {
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let satisfactionLabel = UILabel().then {
        $0.text = "운동의 만족도는 어떠셨나요?"
        $0.textColor = .placeholderText
    }
    
    private let satisfactionButton = UIButton().then {
        $0.setTitle("최고였어요~", for: .normal)
    }
    
    // MARK: 제출 버튼
    private let submitButton = BHSubmitButton(title: "업로드").then {
        $0.isEnabled = false
    }
    
    private lazy var picker = PHPickerViewController(configuration: configuration)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPHPicker()
        setupViews()
    }
}

// MARK: - Extension
extension CommunityFormView {
    // MARK: View
    private func setupViews() {
        view.backgroundColor = .white
        
        [scrollView, submitButton].forEach {
            view.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        let contentView = UIView()
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(18)
        }
        
        [contentTextView, satisfactionButtonStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentTextView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        satisfactionButtonStackView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func setupPHPicker() {
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        picker.delegate = self
    }
    
    // MARK: Action
    @objc private func didTapButton() {
        self.present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension CommunityFormView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    print(image as? UIImage)
                }
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension CommunityFormView: UITextViewDelegate {
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
