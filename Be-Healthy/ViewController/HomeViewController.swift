//
//  HomeViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import Then
import SnapKit

class HomeViewController: UIViewController {
    /// scrollView 변수 초기화
    lazy var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension HomeViewController {
    /// 네비게이션 바 설정
    fileprivate func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.init(named: "mainColor")!]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.tintColor = UIColor.init(named: "mainColor")
        
        navigationItem.title = "BE HEALTHY"
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 26
        }
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(26)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        /// 오늘의 운동 뷰
        let todayWorkOutView = generateTodayWorkOutView()

        /// 하루 운동 목표 달성률 뷰
        let goalAchieveRateView = generateGoalAchieveRateView()
        
        /// 이번 주 평균 운동 시간 뷰
        let averageWorkOutTimeView = generateAverageWorkOutTimeView()
        
        stackView.addArrangedSubview(todayWorkOutView)
        stackView.addArrangedSubview(goalAchieveRateView)
        stackView.addArrangedSubview(averageWorkOutTimeView)
    }
    
    fileprivate func generateTodayWorkOutView() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = .white
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 10
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 4, height: 4)
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowRadius = 5.0
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(139)
        }
        
        /// 타이틀
        let titleLabel = UILabel().then {
            $0.text = "오늘의 운동🏃‍♂️"
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = UIColor.init(named: "mainColor")
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        let attributeString = NSMutableAttributedString(string: "0시간 : 0분 : 0초")
        
        ["시간 : ", "분 : ", "초"].forEach {
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22.0, weight: .semibold), range: ("0시간 : 0분 : 0초" as NSString).range(of: $0))
        }
        
        let timeLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 38.0, weight: .bold)
            $0.attributedText = attributeString
        }
        
        view.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().inset(20)
        }
        
        return view
    }
    
    fileprivate func generateGoalAchieveRateView() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = .white
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 10
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 4, height: 4)
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowRadius = 5.0
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(169)
        }
        
        /// 타이틀
        let titleLabel = UILabel().then {
            $0.text = "LAURA LEE님의 목표 달성률"
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = .black
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        let descriptionLabel = UILabel().then {
            $0.text = "LAURA LEE님!\n목표 운동시간까지 2시간 남았습니다. :)"
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = UIColor.init(named: "mainColor")
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        let progressView = UIProgressView().then {
            $0.progress = 0.7
            $0.trackTintColor = .init(hexFromString: "D9D9D9")
            $0.progressTintColor = UIColor.init(named: "mainColor")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 5.0
        }
        
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(15)
        }
        
        let progressLabel = UILabel().then {
            $0.text = "0%"
            $0.font = .systemFont(ofSize: 12, weight: .semibold)
        }
        
        view.addSubview(progressLabel)
        
        progressLabel.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().inset(10)
        }
        
        return view
    }
    
    fileprivate func generateAverageWorkOutTimeView() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = UIColor.init(named: "mainColor")
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 10
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 4, height: 4)
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowRadius = 5.0
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(286)
        }
        
        let attributeString = NSMutableAttributedString(string: "이번 한 주의 운동 시간은\n평균 4.5시간 입니다.")
        
        ["평균", "시간 입니다."].forEach {
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: ("이번 한 주의 운동 시간은\n평균 4.5시간 입니다." as NSString).range(of: $0))
        }
        
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20.0, weight: .bold), range: ("이번 한 주의 운동 시간은\n평균 4.5시간 입니다." as NSString).range(of: "4.5"))
        
        /// 타이틀
        let titleLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.attributedText = attributeString
            $0.textColor = .white
            $0.numberOfLines = 2
        }
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        return view
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct HomeViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        HomeViewController()
    }
}

struct HomeViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        HomeViewControllerPresentable()
    }
}

#endif



