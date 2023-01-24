//
//  ProfileViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/05.
//

import UIKit

/// 설정 > 목록 view.tag
enum SettingView: Int {
    case goalTimeSettingView = 0
    case contentsSettingView = 1
    case accountSettingView = 2
    case appSettingView = 3
    case noticeView = 4
    case versionInfoView = 5
}

class ProfileViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupScrollView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - Extensions
extension ProfileViewController {
    // MARK: View
    fileprivate func setupViews() {
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
        
        // 프로필 stackView 변수 초기화
        let profileStackView = generateProfileStackView()
        
        contentView.addSubview(profileStackView)
        
        // 프로필 stackView 위치 잡기
        profileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(83)
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
        
        let goalTimeSettingView = generateSettingView(title: "목표 운동시간 설정", tag: 0)
        let contentsSettingView = generateSettingView(title: "게시글 관리", tag: 1)
        let accountSettingView = generateSettingView(title: "계정 설정", tag: 2)
        let appSettingView = generateSettingView(title: "알림 설정", tag: 3)
        let noticeView = generateSettingView(title: "공지사항", tag: 4)
        let versionInfoView = generateSettingView(title: "버전 정보", tag: 5)
        
        [goalTimeSettingView, accountSettingView, versionInfoView].forEach {
            settingStackView.addArrangedSubview($0)
            generateSettingViewTapGesture($0)
        }
        
        goalTimeSettingView.snp.makeConstraints {
            $0.height.equalTo(80)
        }
    }
    
    /// 프로필 stackView 생성
    /// - Returns: 프로필 stackView
    fileprivate func generateProfileStackView() -> UIStackView{
        let stackView = UIStackView().then {
            $0.spacing = 20
            $0.alignment = .center
            $0.distribution = .fill
            $0.axis = .vertical
        }
        
        let profileView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.border.cgColor
            $0.layer.borderWidth = 0.5
            $0.layer.cornerRadius = 50
        }
        
        let profileImgView = UIImageView().then {
            $0.image = UIImage(systemName: "person.fill")
            $0.tintColor = .black
        }
        
        let welcomeLabel = UILabel().then {
            $0.font = .boldSystemFont(ofSize: 20.0)
            $0.textAlignment = .center
            $0.text = "반갑습니다!\n 비헬시님"
            $0.numberOfLines = 0
        }
        
        profileView.addSubview(profileImgView)
        
        [profileView, welcomeLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        profileView.snp.makeConstraints {
            $0.size.equalTo(100)
        }
        
        profileImgView.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalTo(profileView)
        }
        
        return stackView
    }
    
    /// 설정 > 목록 view 생성
    /// - Parameters:
    ///   - title: 목록 title
    ///   - tag: 목록 tag
    /// - Returns: 설정 > 목록 view
    fileprivate func generateSettingView(title: String, tag: Int) -> UIView {
        let view = UIView().then {
            $0.tag = tag
        }
        
        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = .systemFont(ofSize: 16)
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        if tag < 5 {
            let imageView = UIImageView().then {
                $0.image = UIImage(systemName: "chevron.right")
                $0.tintColor = .black
            }
            
            view.addSubview(imageView)
            
            imageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
            
            let bottomBorder = UIView().then {
                $0.backgroundColor = UIColor.init(hexFromString: "#A9A9A9")
            }
            
            view.addSubview(bottomBorder)
            
            bottomBorder.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(0.5)
            }
        } else { // 버전 정보의 경우
            var version: String?
            
            if let infoDict = Bundle.main.infoDictionary {
                version = infoDict["CFBundleShortVersionString"] as? String
            }
            
            let versionLabel = UILabel().then {
                $0.text = version ?? ""
                $0.font = .systemFont(ofSize: 16)
            }
            
            view.addSubview(versionLabel)
            
            versionLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
        }
        
        return view
    }
    
    // MARK: Actions
    /// 설정 > 목록 > 뷰 클릭 시
    func generateSettingViewTapGesture(_ view: UIView) {
        switch view.tag {
        case SettingView.goalTimeSettingView.rawValue:
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGoalTimeSettingView))
            view.addGestureRecognizer(tapGesture)
        case SettingView.accountSettingView.rawValue:
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAccountSettingView))
            view.addGestureRecognizer(tapGesture)
        default:
            break
        }
    }
    
    /// 목표 운동 시간 설정 화면 이동
    @objc fileprivate func didTapGoalTimeSettingView(_ sender: UITapGestureRecognizer) {
        let vc = GoalTimeSettingView()
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 계정 설정 화면 이동
    @objc fileprivate func didTapAccountSettingView(_ sender: UITapGestureRecognizer) {
        let vc = AccountSettingViewController()
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
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
