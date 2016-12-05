//
//  UserCell.swift
//  BangocChatAppFirebase
//
//  Created by Ngoc on 10/17/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import UIKit
import Firebase
//import Foundation

class UserCell: UITableViewCell{
    
    var message: Message?{
        didSet{
            setupNameAndProfileImage()
            
        }
    
    }
    
    
    private func setupNameAndProfileImage(){
        
        let chatParnerId: String?
        
        if message?.fromId == FIRAuth.auth()?.currentUser?.uid{
            chatParnerId = (message?.toId)!
        }else{
            chatParnerId = (message?.fromId)!
        }

        if let id = chatParnerId{
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observe(.value, with: { (snapshop) in
                if let dictionary = snapshop.value as? [String: AnyObject]{
                    let user = User()
                    user.setValuesForKeys(dictionary)
                    self.textLabel?.text = user.name
                    
                    if let profileUrl = user.profileImageUrl{
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileUrl)
                    }
                }
                
                }, withCancel: nil)
        }
        
        self.detailTextLabel?.text = message?.text
        
        if let seconds = message?.timestamp?.doubleValue{
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
            print("TimeStamp \(timestampDate)")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            
            timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            
        }
    
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 54, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.size.width)!, height: (textLabel?.frame.size.height)!)
        
//        textLabel?.backgroundColor = UIColor.green
        
        detailTextLabel?.frame = CGRect(x: 54, y: (detailTextLabel?.frame.origin.y)!, width: (detailTextLabel?.frame.size.width)!, height: (detailTextLabel?.frame.size.height)!)
        
    }
    
    
    let profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "HH:MM:SS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        
        //x, y, width, height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        addSubview(timeLabel)
        //x,y,width,height
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
//        timeLabel.centerYAnchor.constraint(equalTo: (textLabel?.centerYAnchor)!).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
