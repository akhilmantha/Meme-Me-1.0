//
//  MemeMe ViewController.swift
//  Meme Me 1.0
//
//  Created by akhil mantha on 03/03/18.
//  Copyright © 2018 akhil mantha. All rights reserved.
//

import UIKit
import Foundation

struct Meme{
    
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memedImage : UIImage
}

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
        configureTextField()
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
        toolbarState(hiddenBar: false)
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        ImagePickerView.image = nil
        changeTextFields("", "")
        changeTextFieldsStatus(true)
        dismiss(animated: true, completion: nil)
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
        toolbarState(hiddenBar: true)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame , afterScreenUpdates: true )
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
        
    }
    func generateOriginalImage() -> UIImage{
        toolbarState(hiddenBar: true)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let originalImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return originalImage
    }
    
    func changeBarsStatus(_ status: Bool) {
        navBar.isHidden = status
        toolBar.isHidden = status
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
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    // MARK: right before keyboard hide
    @objc func keyboardWillHide(_ notification:Notification){
        if textfieldDelegate.activeTextField == self.bottomText {
            //view.frame.origin.y += getKeyboardHeight(notification)
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
    func configureTextField(){
        // Top and Bottom Text default attributes.
        topText.defaultTextAttributes = attributes
        bottomText.defaultTextAttributes = attributes
        topText.textAlignment = NSTextAlignment.center
        bottomText.textAlignment = NSTextAlignment.center
        
        // Text fields delegates
        topText.delegate = textfieldDelegate
        bottomText.delegate = textfieldDelegate
        
        changeTextFields("", "")
        changeTextFieldsStatus(true)
    }
}
