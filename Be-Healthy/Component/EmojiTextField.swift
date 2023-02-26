//
//  EmojiTextField.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/03.
//

import UIKit

protocol emojiTextFieldDelegate: NSObject {
    func checkSubmitButtonEnable()
}

class EmojiTextField: UITextField {
    weak var emojiTextFieldDelegate: emojiTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var textInputMode: UITextInputMode? {
        .activeInputModes.first(where: { $0.primaryLanguage == "emoji" })
    }
}

extension EmojiTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty {
            textField.text = string
            emojiTextFieldDelegate?.checkSubmitButtonEnable()
        }
        
        return false
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
