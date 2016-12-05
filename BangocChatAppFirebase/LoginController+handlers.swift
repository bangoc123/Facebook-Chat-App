//
//  LoginController+handlers.swift
//  BangocChatAppFirebase
//
//  Created by Ngoc on 10/14/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func handleSelectProfileImageView(sender: UITapGestureRecognizer? = nil){
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage
        }
        
        print(info)
        
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegister(){
        //print("Handle button successfully")
        
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text{
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if(error != nil){
                    print(error)
                    return
                }
                
                guard let uid = user?.uid else{
                    return
                }
                
                let imageName = NSUUID().uuidString
                
//                let storageRef = FIRStorage.storage().reference().child("profileImages").child("\(imageName).png")
                
                let storageRef = FIRStorage.storage().reference().child("profileImages").child("\(imageName).jpg")
                
                
                if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
                //if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        if(error != nil){
                            print(error)
                            return
                        }
                        
                        print(metadata)
                        
                        if let url = metadata?.downloadURL()?.absoluteString{
                            
                            let values = ["name": name, "email": email, "profileImageUrl": url]
                        
                            self.registerUserIntoDatabase(uid: uid, values: values as [String : AnyObject])
                        }
                    })
                }
            })
        }
    }
    
    private func registerUserIntoDatabase(uid: String, values: [String: AnyObject]){
        
        let ref = FIRDatabase.database().reference(fromURL: "https://facebookchat-3b976.firebaseio.com/")
        
        let usersReference = ref.child("users").child(uid)
        
        //ref.updateChildValues(values)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if(error != nil){
                print(error)
                return
            }
            
            self.messageController?.checkIfUserLoggedIn()
            
            self.dismiss(animated: true, completion: nil)
            
            print("Saved user successfully")
            
        })
        
        
        //successfully authenticated user
        
    }
    
    
}
