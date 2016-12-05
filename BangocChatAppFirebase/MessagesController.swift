//
//  ViewController.swift
//  BangocChatAppFirebase
//
//  Created by Ngoc on 10/9/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(handleNewMesasge))
        
        //user is not logged in
        
        checkIfUserLoggedIn()

//        observeMessages()
        
        observeUserMessages()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    var messages = [Message]()
    
    var messagesDictionary = [String : Message]()
    
    
    func observeUserMessages(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        
            ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            
            let messageRef = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print("Demo")
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    
                    let message = Message()
                    
                    message.setValuesForKeys(dictionary)
                    
                    self.messages.append(message)
                    
                    
                    if let toId = message.toId{
                        self.messagesDictionary[toId] = message
                        
                        self.messages = Array(self.messagesDictionary.values)
                        
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                    
                    
                    print(self.messagesDictionary)
                    
                }
                
                }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    
    
    func observeMessages(){
        
        let ref = FIRDatabase.database().reference().child("messages")
        
        ref.observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                let message = Message()
                
                message.setValuesForKeys(dictionary)

                self.messages.append(message)

                
                if let toId = message.toId{
                    self.messagesDictionary[toId] = message
                    
                    self.messages = Array(self.messagesDictionary.values)
                    
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                    })
                }
                
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData()
                })
                
                
                print(self.messagesDictionary)
                
            }
            
            }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell

        let message = messages[indexPath.row]
        
        //cell.textLabel?.text = message.toId
        
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    
    func handleNewMesasge(){
        let newMessagesController  =  NewMessagesController()
        
        newMessagesController.messageController = self
        
        let navigationController = UINavigationController(rootViewController: newMessagesController)
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func checkIfUserLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            fetchUserAndSetupNavBar()
            
        }
        
    }
    
    
    func fetchUserAndSetupNavBar(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
//                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User()
                user.setValuesForKeys(dictionary)
                
                self.setupNavBarWithUser(user: user)
            }
            }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: User){
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()

        let titleView = UIView()
        
        titleView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        
        //titleView.backgroundColor = UIColor.blue
        
        //Create a profileImageView
        
        let profileImageView = UIImageView()
        
        if let profileUrl = user.profileImageUrl{
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileUrl)
        }
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.layer.cornerRadius = 20
        
        profileImageView.contentMode = .scaleAspectFill
        
        profileImageView.clipsToBounds = true
        
        titleView.addSubview(profileImageView)
        
        profileImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.navigationItem.titleView = titleView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showChatController))
        
        titleView.addGestureRecognizer(tap)
    }
    
    
    func showChatController(user: User){
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        
        chatLogController.user = user
        
        navigationController?.pushViewController(chatLogController, animated: true)
        
        
    
    }
    
    
    func handleLogout(){
        
        
        do {
            try FIRAuth.auth()?.signOut()
            
        }catch let loggoutError{
            print(loggoutError)
        }
        
        //Change
        
        let loginController = LoginViewController()
        loginController.messageController = self
        present(loginController, animated: true, completion: nil)
    }


    
    
    
    
}

