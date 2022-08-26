//
//  LoginViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import Then
import SnapKit

class LoginViewController: UIViewController {
    
    // 스크롤 시 status Bar 변경하기 위해 사용하는 변수
    var isTitleView: Bool = true
    
    /// scrollView 변수 초기화
    lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    
    /// titleView 변수 초기화
    let titleView = TitleView()
    
    /// status Bar 색상 설정
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isTitleView {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
        
        // 오류 메시지 label 변수 초기화
        let errorMsgLabel = UILabel().then {
            $0.text = "이메일 또는 비밀번호를 다시 입력해주세요."
            $0.font = .systemFont(ofSize: 12.0)
            $0.textColor = .systemRed
        }
        
        contentView.addSubview(errorMsgLabel)
        
        // 오류 메시지 label 위치 잡기
        errorMsgLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.greaterThanOrEqualToSuperview().offset(18)
        }
        
        // 아이디 / 비밀번호 폼 stackView 변수 초기화
        let formStackView = UIStackView().then {
            $0.spacing = 10
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.axis = .vertical
        }
        
        contentView.addSubview(formStackView)
        
        // 아이디 / 비밀번호 폼 위치 잡기
        formStackView.snp.makeConstraints {
            $0.top.equalTo(errorMsgLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().offset(18)
        }
        
        // 아이디 / 비밀번호 textField 변수 초기화
        let idTextField = BHTextField(placeholder: "이메일을 입력하세요.")
        let pwTextField = BHTextField(placeholder: "비밀번호를 입력하세요.")
        
        [idTextField, pwTextField].forEach {
            formStackView.addArrangedSubview($0)
            $0.delegate = self
            
            // 아이디 / 비밀번호 textField 위치 잡기
            $0.snp.makeConstraints {
                $0.height.equalTo(60)
                $0.horizontalEdges.equalToSuperview()
            }
        }
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - UIScrollViewDelegate
extension LoginViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos = scrollView.contentOffset.y
        
        scrollView.bounces = yPos > 100
        
        // 스크롤 시 statusBar 색 변경
        if yPos >= titleView.bounds.maxY - 200 {
            isTitleView = false
        } else {
            isTitleView = true
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - UITextFieldDelegate
// 사용하는 textField에 delegate 설정 필요
extension LoginViewController: UITextFieldDelegate {
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
struct LoginViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        LoginViewController()
    }
}

struct LoginViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        LoginViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
