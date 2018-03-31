//
//  helper.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/31.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

extension UIViewController{
    @objc func  showingKeybord(notification: Notification) {
        if let keybordHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height{
            
            self.view.frame.origin.y = -keybordHeight 
        }
        
    }
    
    @objc func hidingKeyboard(){
        self.view.frame.origin.y = 0
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
