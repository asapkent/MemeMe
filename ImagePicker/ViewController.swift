//
//  ViewController.swift
//  ImagePicker
//
//  Created by Robert Jeffers on 8/27/20.
//  Copyright © 2020 AsapInc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButtonOutlet: UIBarButtonItem!
    
    let textfieldDelegate = textFieldDelegate()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButtonOutlet.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        self.topTextField.delegate = self.textfieldDelegate
        self.bottomTextField.delegate = self.textfieldDelegate
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }


    @IBAction func pickButtonTapped(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                  imageViewOutlet.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func camerabuttonPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    //MARK: Keyboard functions
    
    @objc func keyboardWillShow(_ notification:Notification) {
         view.frame.origin.y -= getKeyboardHeight(notification)
     }
     
     @objc func keyboardWillHide(_ notification:Notification) {
          view.frame.origin.y = 0
     }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
           let userInfo = notification.userInfo
           let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
           return keyboardSize.cgRectValue.height
       }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
      // MARK: Meme Object
}

