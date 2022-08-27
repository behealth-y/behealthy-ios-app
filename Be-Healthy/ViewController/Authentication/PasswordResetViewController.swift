//
//  PasswordResetViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/27.
//

import UIKit
import SnapKit
import Then

class PasswordResetViewController: BHAuthViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.title = "비밀번호 재설정"
        view.backgroundColor = .white
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension PasswordResetViewController {
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
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct PasswordResetViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        PasswordResetViewController()
    }
}

struct PasswordResetViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        PasswordResetViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
