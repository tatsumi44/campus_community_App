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
    func selectSegment(num:Int) -> String {
          let fruits = ["投稿内容が具体性に乏しい","いたずら目的・取引の意図がない", "わいせつ目的", "他人を傷つける投稿", "法令違反・危険行為につながる", "投稿内容がアプリのコンセプトに合わない", "その他"]
        switch num {
        case 0:
            return "\(fruits[0])"
        case 1:
            return "\(fruits[1])"
        case 2:
            return "\(fruits[2])"
        case 3:
            return "\(fruits[3])"
        case 4:
            return "\(fruits[4])"
        case 5:
            return "\(fruits[5])"
        case 6:
            return "\(fruits[6])"
        default:
            return "error"
        }
    }
}
