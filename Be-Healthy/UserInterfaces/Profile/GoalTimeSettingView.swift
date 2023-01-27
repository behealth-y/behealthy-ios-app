//
//  GoalTimeSettingView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/09.
//

import UIKit
import SnapKit
import Then

class GoalTimeSettingView: BaseViewController {
    // 회원가입 / 로그인 프로세스에서 열리는 경우
    var openedAuthProcess: Bool = false
    
    private let workOutService = WorkOutService()
    
    // 목표 운동시간
    private var timeInt: Int = 0
    
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        let style = NSMutableParagraphStyle()
        let fontSize: CGFloat = 25
        let lineHeight: CGFloat = fontSize * 1.6
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        
        $0.attributedText = NSAttributedString(
            string: "🙋‍♀️만나서 반가워요!\n목표 운동 시간을 설정해볼까요?",
            attributes: [
                .paragraphStyle: NSMutableParagraphStyle(),
                .baselineOffset: (lineHeight - fontSize) / 4
            ]
        )
        
        $0.numberOfLines = 2
        $0.font = .boldSystemFont(ofSize: fontSize)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "나중에 언제든지 변경할 수 있어요. :)"
        $0.font = .systemFont(ofSize: 16)
    }
    
    private lazy var timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 30, weight: .heavy)
        $0.attributedText = setTimeText()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTimeLabel))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
    }
    
    private let timeLabelBottomBorder = UIView().then {
        $0.backgroundColor = .border
    }
    
    private let submitButton = BHSubmitButton(title: "설정하기").then {
        $0.isEnabled = true
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension GoalTimeSettingView {
    /// 레이아웃 설정
    private func setupLayout() {
        view.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        contentView.addSubview(timeLabel)

        timeLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }

        contentView.addSubview(timeLabelBottomBorder)

        timeLabelBottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(timeLabel.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)

        view.addSubview(submitButton)

        submitButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    // MARK: Actions
    @objc private func didTapSubmitButton() {
        workOutService.setWorkOutGoal(hour: 2, minute: 0) { [weak self] data in
            if let _ = data.errorCode, let reason = data.reason { // 목표 운동 시간 설정 실패
                print(reason)
                self?.setWorkOutGoalFail()
            } else { // 목표 운동 시간 설정 성공
                self?.setWorkOutGoalSuccess()
            }
        }
    }
    
    /// 목표 시간 설정 모달 화면 열기
    @objc private func didTapTimeLabel(sender: UITapGestureRecognizer){
        let vc = GoalTimeSettingModalView()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    // MARK: 목표 운동 시간 설정 처리
    /// 목표 운동 시간 설정 성공
    private func setWorkOutGoalSuccess() {
        print(#function)
        if openedAuthProcess {
            self.view.window?.windowScene?.keyWindow?.rootViewController = TabBarViewController()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    /// 목표 운동 시간 설정 실패
    private func setWorkOutGoalFail() {
        print(#function)
    }
}

// MARK: - Helpers
extension GoalTimeSettingView {
    private func setTimeText(hour: Int = 1, minute: Int = 0) -> NSMutableAttributedString {
        let timeText = "\(hour) 시간 \(minute) 분"
        let attributeString = NSMutableAttributedString(string: timeText)
        
        ["시간", "분"].forEach {
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0), range: (timeText as NSString).range(of: $0))
        }
        
        return attributeString
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct GoalTimeSettingViewPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        GoalTimeSettingView()
    }
}

struct GoalTimeSettingViewPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        GoalTimeSettingViewPresentable()
            .ignoresSafeArea()
    }
}

#endif
