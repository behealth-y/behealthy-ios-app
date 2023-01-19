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
    
    private lazy var button = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("이미지 선택", for: .normal)
        $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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
        
        view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
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
