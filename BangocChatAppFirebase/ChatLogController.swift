//
//  ChatLogController.swift
//  BangocChatAppFirebase
//
//  Created by Ngoc on 10/16/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate{
    
    var inputTextField: UITextField?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = user?.name
        
        setupInputComponents()
        
        collectionView?.backgroundColor = UIColor.white
        
        inputTextField?.delegate = self
        
    }
    
    
    func setupInputComponents(){
        
        let containerView = UIView()
        
//        containerView.backgroundColor = UIColor.brown
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //x, y, w, h
        
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //Create a text field
        
        inputTextField = UITextField()
        
        inputTextField?.placeholder = "Type something..."
        
        inputTextField?.translatesAutoresizingMaskIntoConstraints = false
        
        inputTextField?.clearsOnBeginEditing = true
        
        containerView.addSubview(inputTextField!)
        
        //x, y, w, h

        inputTextField?.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        
        inputTextField?.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        inputTextField?.widthAnchor.constraint(equalToConstant: 330).isActive = true
        
        inputTextField?.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //Create a Send button

        let sendButton = UIButton(type: .system)

        sendButton.setTitle("Send", for: .normal)

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
//        sendButton.tintColor = UIColor.setRgb(r: <#T##CGFloat#>, g: <#T##CGFloat#>, b: <#T##CGFloat#>)
        
        containerView.addSubview(sendButton)
        

        //x, y, w, h
        
        sendButton.leftAnchor.constraint(equalTo: (inputTextField?.rightAnchor)!, constant: 10).isActive = true
        
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        
        //Create a separator
        
        let messageSeparator = UIView()
        
        messageSeparator.backgroundColor = UIColor.setRgb(r: 220, g: 220, b: 220)
        
        messageSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(messageSeparator)
        
        //x, y, w, h
        
        messageSeparator.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        messageSeparator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        
        messageSeparator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        messageSeparator.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        
        
    }
    
    func handleSendMessage(){
        if let text = inputTextField?.text{
            
            let toId = user!.id! as String
            
            let fromId = FIRAuth.auth()!.currentUser!.uid
            
            let timeStamp = Int(NSDate().timeIntervalSince1970)

            let values = ["text": text, "toId": toId, "fromId" : fromId, "timestamp" : timeStamp] as [String : Any]
            
            let ref = FIRDatabase.database().reference().child("messages")
            
            let childRef = ref.childByAutoId()
            
//            childRef.updateChildValues(values)

            childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if(error != nil){
                    print(error)
                    return
                }
                
                let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
                
                let messageId = childRef.key
                
                userMessagesRef.updateChildValues([messageId: 1])
                
                let userRecipentRef = FIRDatabase.database().reference().child("user-messages").child(toId)
                
                userRecipentRef.updateChildValues([messageId: 1])
                
                
            })
            
            inputTextField?.text = ""
            
            
//            print(text)
            
//            inputTextField.re
            
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSendMessage()
        return true
    }
    

}
