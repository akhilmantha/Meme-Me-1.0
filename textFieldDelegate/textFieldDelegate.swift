//
//  textFieldDelegate.swift
//  Meme Me 1.0
//
//  Created by akhil mantha on 07/04/18.
//  Copyright © 2018 akhil mantha. All rights reserved.
//

import Foundation
import UIKit

class TopBottomTextFieldDelegate: NSObject, UITextFieldDelegate{
    
    var activeTextField: UITextField?
    var isTextEditing: Bool
    
    
    override init() {
        self.isTextEditing = false
        super.init()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       self.activeTextField = textField
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.isTextEditing = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    
}
