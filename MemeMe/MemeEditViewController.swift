//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by Huong Tran on 12/15/19.
//  Copyright © 2019 RiRiStudio. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    var memedImage: UIImage!
    var memeToEdit: Meme!
    var cancelButonIsEnabled: Bool!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if let memeToEdit = memeToEdit {
            topText.text = memeToEdit.topText
            bottomText.text = memeToEdit.bottomText
            imageView.image = memeToEdit.originalImage
        }
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        checkShareButton()
        subcribeToKeyboardNotification()
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        if let cancelButonIsEnabled = cancelButonIsEnabled {
            cancelButton.isEnabled = cancelButonIsEnabled
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        unSubcribeToKeyboardNotification()
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTextField(topText)
        initTextField(bottomText)
    }
    
    func initTextField(_ text: UITextField) {
        text.text = "TEXT"
        text.defaultTextAttributes = memeTextAttributes
        text.textAlignment = .center
        text.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            checkShareButton()
            dismiss(animated: true, completion: nil)
        } else {
            print("Fail to get image")
        }
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4
    ]
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }

    func saveMeme() {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func pickAnImageFromAlbum (_ sender: Any) {
        showImagePicker(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        showImagePicker(source: .camera)
    }
    
    @IBAction func cancelEditing(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func showImagePicker(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareSNS(_ sender: Any) {
        memedImage = generateMemedImage()
        let imageToShare = [memedImage]
        let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if(!completed) {
                return
            }
            self.saveMeme()
            self.navigationController?.popToRootViewController(animated: true)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomText.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subcribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unSubcribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        hideToolbar(isHiden: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbar(isHiden: false)
        return memeImage
    }
    
    func checkShareButton() {
        if imageView.image != nil {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    

    func hideToolbar(isHiden: Bool) {
        if isHiden {
            topToolBar.isHidden = true
            bottomToolBar.isHidden = true
        } else {
            topToolBar.isHidden = false
            bottomToolBar.isHidden = false
        }
    }

}

