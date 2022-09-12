//
//  CalendarViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/12.
//

import UIKit
import Then
import SnapKit

class CalendarViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension CalendarViewController {
    fileprivate func setupLayout() {
        view.backgroundColor = .systemYellow
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct CalendarViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        CalendarViewController()
    }
}

struct CalendarViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        CalendarViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif



