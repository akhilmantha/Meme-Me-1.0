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
    var memedImage : UIImage
}

class MemeMe_ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK Outlets Of The View
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    
    //MARK stating the text field attributes
    let attributes : [String : Any] = [
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "ComicSansMS", size: 40) ?? UIFont.systemFont(ofSize: 30),
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.strokeWidth.rawValue : -3.0
        
    ]
    
    
    //MARK View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        topText.delegate = self
        bottomText.delegate = self
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        configure(textField: bottomText, withText: "BOTTOM")
        configure(textField: topText, withText: "TOP")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK IBActions of the view
    
    @IBAction func pickAnImageCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        }
    
    @IBAction func pickAnImageAlbums(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage],applicationActivities: nil)
        
        present(activityViewController, animated: true)
        activityViewController.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if (completed){
                self.save(memedImage: memedImage)
            }
            if((error) != nil){
                let alert = UIAlertController(title: "Error", message: "There was a problem saving, go out and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        ImagePickerView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        dismiss(animated: true, completion: nil)
    }
    
   //MARK Required Functions
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImagePickerView.contentMode = UIViewContentMode.scaleAspectFit
            ImagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    ImagePickerView.image = nil
    dismiss(animated: true, completion: nil)
    }
    
    func save(memedImage : UIImage){
        let meme  = Meme(topText: topText.text!, bottomText: bottomText.text!,
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
    
    func toolbarState(hiddenBar : Bool){
        topToolbar.isHidden = hiddenBar
        bottomToolbar.isHidden = hiddenBar
    }
    
    
    //Mark keyboard state and text field methods
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomText.isFirstResponder){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if (bottomText.isFirstResponder){
            view.frame.origin.y += getKeyboardHeight(notification as Notification)
        }
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    func configure(textField :UITextField, withText text: String){
        textField.defaultTextAttributes = attributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = text
    }
    
}
