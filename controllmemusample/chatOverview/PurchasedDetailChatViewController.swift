//
//  PurchasedDetailChatViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/27.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import SDWebImage
import FirebaseStorage
class PurchasedDetailChatViewController: MessagesViewController  {
    
    var cellOfNum: Int!
    var realTimeDB: DatabaseReference!
    var db: Firestore!
    var myName: String!
    var cellDetailArray = [PurchasedList]()
    var messagesList: [ChatModel] = []
    var sender:Sender!
    var sender1:Sender!
    let official = Sender(id: "123456", displayName: "official")
    let officialAvatar = Avatar(image: UIImage(named:"kanematsu.jpg"), initials: "official")
    var contentsArray = [String:Any]()
    var uid1:String!
    var myImagepath: String!
    var otherImagePath: String!
    var myPath: URL!
    var otherPath: URL!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        realTimeDB = Database.database().reference()
        let storage = Storage.storage().reference()
        if let uid = Auth.auth().currentUser?.uid{
            uid1 = uid
            db = Firestore.firestore()
            db.collection("users").document(uid).getDocument { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                }else{
                    let data = snap?.data()
                    self.myName = data!["name"] as! String
                    self.myImagepath = data!["profilePath"] as! String
                    self.sender = Sender(id: uid, displayName: self.myName)
                    self.db.collection("users").document(self.cellDetailArray[self.cellOfNum].buyerID).getDocument(completion: { (snap, error) in
                        if let error = error{
                            self.alert(message: error.localizedDescription)
                            print(error.localizedDescription)
                        }else{
                            let data = snap?.data()
                            self.otherImagePath = data!["profilePath"] as! String
                            
                            if let myPath = self.myImagepath,let otherPath = self.otherImagePath{
                                storage.child("image/profile/\(myPath)").downloadURL(completion: { (url, error) in
                                    if let error = error{
                                        self.alert(message: error.localizedDescription)
                                        print(error.localizedDescription)
                                    }else{
                                        self.myPath = url
                                        self.messagesCollectionView.reloadData()
                                    }
                                })
                                storage.child("image/profile/\(otherPath)").downloadURL(completion: { (url, error) in
                                    if let error = error{
                                        self.alert(message: error.localizedDescription)
                                        print(error.localizedDescription)
                                    }else{
                                        self.otherPath = url
                                        self.messagesCollectionView.reloadData()
                                    }
                                })
                            }
                        }
                    })
                }
                
                self.realTimeDB.ref.child("realtimechat").child("message").child(self.cellDetailArray[self.cellOfNum].roomID!).observe(.value) { (snap) in
                    self.messagesList = [ChatModel]()
                    for item in snap.children{
                        let child = item as! DataSnapshot
                        let dic = child.value as! NSDictionary
                        let attributedText = NSAttributedString(string: dic["text"] as! String, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                        self.sender1 = Sender(id: dic["senderID"] as! String, displayName: dic["senderName"] as! String )
                        let message = ChatModel(attributedText: attributedText, sender: self.sender1, messageId: UUID().uuidString, date: Date())
                        self.messagesList.append(message)
                    }
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
//表示内容系
extension PurchasedDetailChatViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return sender
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messagesList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messagesList[indexPath.section]
    }
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        struct ConversationDateFormatter {
            static let formatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter
            }()
        }
        let formatter = ConversationDateFormatter.formatter
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}
//レイアウト系
extension PurchasedDetailChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 200
    }
    //アバター
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if isFromCurrentSender(message: message){
            avatarView.sd_setImage(with: myPath, completed: nil)
        }else{
            avatarView.sd_setImage(with: otherPath, completed: nil)
        }
        if message.sender == official{
            avatarView.set(avatar: officialAvatar)
        }
    }
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isFromCurrentSender(message: message) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
        }
    }
    
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
    
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        } else {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
    }
}
//打ち込んだ文字をどうにかする系
extension PurchasedDetailChatViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
        
        for component in inputBar.inputTextView.components {
            
            if let image = component as? UIImage {
                
                let imageMessage = ChatModel(image: image, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                messagesList.append(imageMessage)
                messagesCollectionView.insertSections([messagesList.count - 1])
                
            } else if let text = component as? String {
                print(text)
                contentsArray = ["text":text,"senderID": uid1,"senderName":self.sender.displayName]
                realTimeDB.ref.child("realtimechat").child("message").child(cellDetailArray[cellOfNum].roomID!).childByAutoId().setValue(contentsArray)
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
                
                let message = ChatModel(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                messagesList.append(message)
                messagesCollectionView.insertSections([messagesList.count - 1])
            }
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
    
}

