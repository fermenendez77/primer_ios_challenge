//
//  PrimerTextField.swift
//  
//
//  Created by Fernando Menendez on 11/10/2021.
//

import Foundation
import UIKit

class PrimerTextField : UITextField {
    
    weak var textBinding : Binding<String>? {
        didSet {
            self.addTarget(self,
                           action: #selector(textFieldDidChange(_:)),
                           for: .editingChanged)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        textBinding?.value = text
    }
}
