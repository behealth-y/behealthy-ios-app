//
//  RegisterViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/27.
//

import UIKit
import SnapKit
import Then

class RegisterViewController: UIViewController {
    
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct RegisterViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        RegisterViewController()
    }
}

struct RegisterViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        RegisterViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif
