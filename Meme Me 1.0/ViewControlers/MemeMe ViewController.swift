//
//  MemeMe ViewController.swift
//  Meme Me 1.0
//
//  Created by akhil mantha on 03/03/18.
//  Copyright © 2018 akhil mantha. All rights reserved.
//

import UIKit
import Foundation

class MemeMe_ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets Of The View
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbarBottomConstraint: NSLayoutConstraint!
    
    
    let textfieldDelegate = TopBottomTextFieldDelegate()
    
    
    //MARK: stating the text field attributes
    let attributes : [String : Any] = [
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) ?? UIFont.systemFont(ofSize: 30),
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.strokeWidth.rawValue : -3.0
        
    ]
    
    
    //MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(textField: topText)
        configureTextField(textField: bottomText)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }

    
    //MARK: IBActions of the view
    
    @IBAction func pickAnImageCamera(_ sender: Any) {
        chooseSourceType(sourceType: .camera)
        }
    
    @IBAction func pickAnImageAlbums(_ sender: Any) {
       chooseSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let originalImage = generateOriginalImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage],applicationActivities: nil)
        
        present(activityViewController, animated: true)
        activityViewController.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if (completed){
                self.save(memedImage: memedImage, originalImage: originalImage)
            }
            if((error) != nil){
                let alert = UIAlertController(title: "Error", message: "There was a problem saving, go out and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    
    //MARK: Required Functions
    
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImagePickerView.image = image
            ImagePickerView.sizeToFit()
            ImagePickerView.contentMode = .scaleAspectFit
            changeTextFields("TOP", "BOTTOM")
            changeTextFieldsStatus(false)
            dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ImagePickerView.image = nil
        dismiss(animated: true, completion: nil)
    }
    
    func save(memedImage : UIImage, originalImage : UIImage){
        let meme  = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage : originalImage,
                         memedImage: memedImage)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    func generateMemedImage() -> UIImage{
        changeBarStatus(true)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame , afterScreenUpdates: true )
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
        
    }
    func generateOriginalImage() -> UIImage{
        changeBarStatus(true)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let originalImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return originalImage
    }
    
    //Mark: keyboard state and text field methods
    
    func changeTextFields(_ top: String, _ bottom: String){
        topText.text = top
        bottomText.text = bottom
    }
    
    func changeTextFieldsStatus(_ status: Bool){
        topText.isHidden = status
        bottomText.isHidden = status
   }
    
    func changeBarStatus(_ status: Bool){
        topToolbar.isHidden = status
        bottomToolbar.isHidden = status
    }
    // MARK: Subscribtion for keyboard event
    @objc func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Unsubscribtion for keybaord event
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: right before keyboard showing
    @objc func keyboardWillShow(_ notification:Notification){
        if textfieldDelegate.activeTextField == self.bottomText {
            view.frame.origin.y = -getKeyboardHeight(notification) + 35
        }
    }
    
    // MARK: right before keyboard hide
    @objc func keyboardWillHide(_ notification:Notification){
        if textfieldDelegate.activeTextField == self.bottomText {
            view.frame.origin.y = 0
        }
    }
    
    // MARK: get Keyboard height.
    func getKeyboardHeight(_ notification:Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //Mark: configure text field
    func configureTextField(textField: UITextField){
        // Top and Bottom Text default attributes.
        textField.defaultTextAttributes = attributes
        textField.textAlignment = NSTextAlignment.center
        textField.autocorrectionType = .no 
        
        // Text fields delegates
        textField.delegate = textfieldDelegate
        
        
        changeTextFields("", "")
        changeTextFieldsStatus(true)
    }
}
