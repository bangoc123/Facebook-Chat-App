//
//  NewMessagesController.swift
//  BangocChatAppFirebase
//
//  Created by Ngoc on 10/11/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import UIKit
import Firebase


class NewMessagesController: UITableViewController {

    let cellId = "cellId"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        fectchUser()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        print("Final Users\(users)")
    }
    
    
    func fectchUser(){
        FIRDatabase.database().reference().child("users").observe( .childAdded , with: { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
                user.id = snapshot.key
                //Set property value for user by using dictionary
                user.setValuesForKeys(dictionary)
                //print("User name" + user.name!)
                //print("Email" + user.email!)
                
                self.users.append(user)
                // This will crash because of background thread , so lets use dispatch_async to fix
                
                
                //Changed
                DispatchQueue.main.async(execute: { 
                    self.tableView.reloadData()
                })
                
                
            }
            
            }, withCancel: nil)
    
    }
    
    func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        
        
        UITableViewCell {
        
            //Hack
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
        
        let user = users[indexPath.item]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.profileImageView.image = nil
        
            

        if let profileImageUrl = user.profileImageUrl{
                    cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    var messageController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        dismiss(animated: true) { 
            print("Dismissed")
            self.messageController?.showChatController(user: self.users[indexPath.item])
        }
        
    }

}





