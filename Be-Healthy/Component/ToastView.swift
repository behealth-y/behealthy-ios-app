//
//  ToastView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/29.
//

import UIKit
import SnapKit
import Then

class ToastView: UIView {
    lazy var toastLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(msg: String) {
        self.init(frame: .zero)
        toastLabel.text = msg
    }
    
    func setupLayout() {
        self.backgroundColor = UIColor.init(hexFromString: "#ffffff", alpha: 1)
        self.layer.cornerRadius = 10
        self.alpha = 0
        
        toastLabel.font = .systemFont(ofSize: 14)
        toastLabel.textColor = .black
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .center
        
        self.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

extension UIViewController {
    func showToast(msg: String) {
        let toastView = ToastView(msg: msg)
        
        view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(70)
            $0.horizontalEdges.equalToSuperview().inset(5)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseIn, animations: {
                toastView.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        })
    }
}
