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
