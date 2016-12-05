//
//  Extensions.swift
//  BangocChatAppFirebase
//
//  Created by Ngoc on 10/15/16.
//  Copyright © 2016 GDG. All rights reserved.
//

import UIKit

let imagesCache = NSCache<NSString, UIImage>()

extension UIImageView{
    func loadImageUsingCacheWithUrlString(urlString: String){
        if let image = imagesCache.object(forKey: urlString as NSString){
            self.image = image
        }else{
            
            URLSession.shared.dataTask(with: URLRequest(url: URL(string: urlString)!) , completionHandler: { (data, response, error) in
                if(error != nil){
                    print(error)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    
                    if let image = UIImage(data: data!){
                        self.image = image
                        imagesCache.setObject(image, forKey: urlString as NSString)
                    }
                    
                })
            }).resume()
        }
    }

}
