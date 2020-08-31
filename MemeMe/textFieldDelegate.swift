//
//  textFieldDelegate.swift
//  ImagePicker
//
//  Created by Robert Jeffers on 8/30/20.
//  Copyright © 2020 AsapInc. All rights reserved.
//

import UIKit

class textFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
           textField.text = ""
           
       }
    
    
    
    
}
