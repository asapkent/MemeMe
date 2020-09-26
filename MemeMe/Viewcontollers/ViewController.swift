import UIKit

class MeViewController: UIViewController {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    var toolBarsState = true
    
    var activeTextField: UITextField?
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    var sentTopText: String?
    var sentBottomText: String?
    var sentImage: UIImage?
    var meme: MemeData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapAnywhere = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapAnywhere)
        
        bottomTextField.delegate = self
        topTextField.delegate = self
        textFieldSetup(topTextField)
        textFieldSetup(bottomTextField)
        shareButton.isEnabled = false
    
        if sentTopText != nil && sentBottomText != nil && sentImage != nil{
            
            topTextField.text = sentTopText
            bottomTextField.text = sentBottomText
            imagePickerView.image = sentImage
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let meme = meme {
                imagePickerView.image = meme.memedImage
        }
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeToKeyboardNotifications()
    }
    
    func textFieldSetup(_ textfield: UITextField) {
        
        
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
        if textfield == topTextField && topTextField.text == "" {
            textfield.text = "TOP"
        }
        if textfield == bottomTextField && bottomTextField.text == "" {
            bottomTextField.text = "BOTTOM"
        }
        
    }
    

    func generateMemedImage() -> UIImage {
        bottomToolbar.isHidden = true
        topToolBar.isHidden = true
       
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        bottomToolbar.isHidden = false
        topToolBar.isHidden = false
        
        return memedImage
    }
    
    func save() {
      
        let meme = MemeData(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        print(appDelegate.memes.count)
    }
    
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let shareController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: [])
        shareController.completionWithItemsHandler = {(activity: UIActivity.ActivityType?, completed: Bool,  _: [Any]?, error: Error?) in
            if completed == false {
                return
            }
            self.save()
        }
        
        self.present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        activeTextField?.resignFirstResponder()
        
    }

    
    
}

extension MeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func pickFromLibraryButtonPressed(_ sender: Any) {
        
        setupPickerController(sourceType: .photoLibrary)
    }
    
    @IBAction func pickFromCameraButtonPressed(_ sender: Any) {
        
       setupPickerController(sourceType: .camera)
        
    }
    
    func setupPickerController(sourceType: UIImagePickerController.SourceType){
        
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageSelection = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            imagePickerView.image = imageSelection
        }
        else if let imageSelection = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = imageSelection
            
        }
        
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension MeViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        activeTextField = textField
        textField.text = ""
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
        
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        
        if activeTextField == bottomTextField {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0.0
        
    }
    
    func unsubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

