//
//  GoalTimeSettingView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/09.
//

import UIKit
import SnapKit
import Then

enum OpenGoalTimeSetting {
    case auth
    case home
    case setting
}

class GoalTimeSettingView: BaseViewController {
    private let goalTimeSubject = GoalTimeSubject.shared
    
    // 어느 경로를 통해서 유입되었는지
    private var openProcess: OpenGoalTimeSetting
    
    private let workoutService = WorkoutService()
    
    // 목표 운동시간
    private var hour: Int = 1
    private var minute: Int = 0
    
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
        $0.attributedText = setTimeText(hour: hour, minute: minute)
        
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
        
        setupViews()
        setupData()
    }
    
    init(openProcess: OpenGoalTimeSetting) {
        self.openProcess = openProcess
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions
extension GoalTimeSettingView {
    // MARK: View
    /// 레이아웃 설정
    private func setupViews() {
        view.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        
        contentView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(18)
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
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(25)
        }
    }
    
    // MARK: Data
    private func setupData() {
        workoutService.getWorkoutGoal { [weak self] data in
            guard let data = data.result, let self = self else { return }
            
            if let hour = data.hour, let minute = data.minute {
                self.hour = hour
                self.minute = minute
                
                self.timeLabel.attributedText = self.setTimeText(hour: hour, minute: minute)
            }
        }
    }
    
    // MARK: Actions
    @objc private func didTapSubmitButton() {
        workoutService.setWorkoutGoal(hour: hour, minute: minute) { [weak self] data in
            if let statusCode = data.statusCode {
                switch statusCode {
                case 200:
                    self?.setWorkoutGoalSuccess()
                default:
                    guard let errorData = data.errorData else { return }
                    
                    self?.setWorkoutGoalFail(reason: errorData.reason)
                }
            }
        }
    }
    
    /// 목표 시간 설정 모달 화면 열기
    @objc private func didTapTimeLabel(sender: UITapGestureRecognizer){
        let vc = GoalTimeSettingModalView()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    // MARK: 목표 운동 시간 설정 처리
    /// 목표 운동 시간 설정 성공
    private func setWorkoutGoalSuccess() {
        print(#function)
        
        let goalTime = (hour * 60) + minute
        self.goalTimeSubject.setGoalTime(goalTime)
        print(hour)
        print(minute)
        print(self.goalTimeSubject.goalTime)
        
        switch openProcess {
        case .auth:
            self.view.window?.windowScene?.keyWindow?.rootViewController = TabBarViewController()
        case .home:
            self.dismiss(animated: true)
        case .setting:
            navigationController?.popViewController(animated: true)
        }
    }
    
    /// 목표 운동 시간 설정 실패
    private func setWorkoutGoalFail(reason: String?) {
        print(#function)
        
        if let reason = reason {
            print(reason)
        }
    }
    
    // MARK: Helpers
    private func setTimeText(hour: Int, minute: Int) -> NSMutableAttributedString {
        let timeText = "\(hour) 시간 \(minute) 분"
        let attributeString = NSMutableAttributedString(string: timeText)
        
        ["시간", "분"].forEach {
            attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0), range: (timeText as NSString).range(of: $0))
        }
        
        return attributeString
    }
}

// MARK: - GoalTimeSettingModalViewDelegate
extension GoalTimeSettingView: GoalTimeSettingModalViewDelegate {
    func setGoalTime(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
        
        timeLabel.attributedText = setTimeText(hour: hour, minute: minute)
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct GoalTimeSettingViewPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        GoalTimeSettingView(openProcess: .auth)
    }
}

struct GoalTimeSettingViewPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        GoalTimeSettingViewPresentable()
            .ignoresSafeArea()
    }
}

#endif
