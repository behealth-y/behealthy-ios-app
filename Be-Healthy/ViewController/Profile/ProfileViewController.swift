//
//  ProfileViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/05.
//

import UIKit

class ProfileViewController: BHAuthViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar("마이페이지")
        setupScrollView()
        
        titleView.title = "마이페이지"
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension ProfileViewController {
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
        
        // 프로필 stackView 변수 초기화
        let profileStackView = generateProfileStackView()
        
        contentView.addSubview(profileStackView)
        
        // 프로필 stackView 위치 잡기
        profileStackView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 설정 stackView 변수 초기화
        let settingStackView = UIStackView().then {
            $0.spacing = 0
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.axis = .vertical
        }
        
        contentView.addSubview(settingStackView)
        
        // 설정 stackView 위치 잡기
        settingStackView.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0.0)
        }
        
        let profileSettingView = generateSettingView(title: "프로필 관리", tag: 0)
        let accountSettingView = generateSettingView(title: "계정 설정", tag: 1)
        let appSettingView = generateSettingView(title: "APP 설정", tag: 2)
        let noticeView = generateSettingView(title: "공지사항", tag: 3)
        
        settingStackView.addArrangedSubview(profileSettingView)
        settingStackView.addArrangedSubview(accountSettingView)
        settingStackView.addArrangedSubview(appSettingView)
        settingStackView.addArrangedSubview(noticeView)
        
        profileSettingView.snp.makeConstraints {
            $0.height.equalTo(80)
        }
    }
    
    /// 프로필 stackView 생성
    /// - Returns: 프로필 stackView
    fileprivate func generateProfileStackView() -> UIStackView{
        let stackView = UIStackView().then {
            $0.spacing = 10
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        let text = "반갑습니다!\n LAURA님"
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttributes([.foregroundColor: UIColor.init(named: "mainColor")!, .font: UIFont.systemFont(ofSize: 30.0, weight: .semibold)], range: (text as NSString).range(of: "LAURA"))
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25.0), range: (text as NSString).range(of: "반갑습니다!"))
        
        let welcomeLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 30.0)
            $0.textAlignment = .center
            $0.attributedText = attributeString
            $0.numberOfLines = 0
        }
        
        stackView.addArrangedSubview(welcomeLabel)
        
        let emailLabel = UILabel().then {
            $0.text = "laura.lee.x316@gmail.com"
            $0.font = .systemFont(ofSize: 14)
        }
        
        stackView.addArrangedSubview(emailLabel)
        
        return stackView
    }
    
    /// 설정 > 목록 view 생성
    /// - Parameters:
    ///   - title: 목록 title
    ///   - tag: 목록 tag
    /// - Returns: 설정 > 목록 view
    fileprivate func generateSettingView(title: String, tag: Int) -> UIView {
        let view = UIView()
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .systemFont(ofSize: 16)
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        let imageView = UIImageView().then {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .black
        }
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        if tag < 3 {
            let bottomBorder = UIView().then {
                $0.backgroundColor = UIColor.init(hexFromString: "#A9A9A9")
            }
            
            view.addSubview(bottomBorder)
            
            bottomBorder.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(0.5)
            }
        }
        
        return view
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct ProfileViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ProfileViewController()
    }
}

struct ProfileViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        ProfileViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
