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
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let msgLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(title: String, msg: String) {
        self.init(frame: .zero)
        titleLabel.text = title
        msgLabel.text = msg
    }
    
    func setupView() {
        self.alpha = 0
        self.backgroundColor = UIColor.init(hexFromString: "#ffffff", alpha: 1)
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 2.0
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        [titleLabel, msgLabel].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(33)
            $0.centerX.equalToSuperview()
        }
        
        msgLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(33)
            $0.centerX.equalToSuperview()
        }
    }
}

extension UIViewController {
    func showToast(title: String, msg: String, completion: @escaping () -> Void) {
        let toastView = ToastView(title: title, msg: msg)
        
        view.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(102)
            $0.horizontalEdges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseIn, animations: {
                toastView.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
                completion()
            })
        })
    }
}
