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

class MemeMe_ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    // MARK Outlets Of The View
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    //MARK View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
}
