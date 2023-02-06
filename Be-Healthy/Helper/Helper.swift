//
//  Helper.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/15.
//

import UIKit

/// ActionSheet 액션
enum ActionSheet {
    case edit
    case delete
}

class Helper {
    /// Alert 생성
    func alert(title: String, msg: String, action: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let action = action else { return }
            action()
        }
        alert.addAction(okAction)
        
        return alert
    }
    
    /// Action Sheet 생성
    func actionSheet(delete: Bool = false, completion: @escaping (ActionSheet) -> Void) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "편집", style: .default) { _ in
            completion(.edit)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [editAction, cancelAction].forEach {
            actionSheet.addAction($0)
        }
        
        if delete == true {
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                completion(.delete)
            }
            
            actionSheet.addAction(deleteAction)
        }
        
        return actionSheet
    }
}
