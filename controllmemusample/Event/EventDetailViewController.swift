//
//  EventDetailViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/31.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
class EventDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var chatPostTextField: UITextField!
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDetail: UILabel!
    @IBOutlet weak var postName: UILabel!
    
    var event: Event! 
    var realtimeDB: DatabaseReference!
    var db: Firestore!
    var name : String!
    var profilePath : StorageReference!
    var contentsArray = [String: String]()
    var getArray = [String]()
    var getMainArray = [[String]]()
    var myname: String!
    
    @IBOutlet weak var labelView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showingKeybord), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidingKeyboard), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)

        mainTable.delegate = self
        mainTable.dataSource = self
        chatPostTextField.delegate = self
        labelView.layer.borderColor = UIColor.orange.cgColor
        labelView.layer.borderWidth = 5.0
        labelView.layer.cornerRadius = 5.0
        labelView.layer.masksToBounds = true
        db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid{
            db.collection("users").document(uid).getDocument(completion: { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    print(error.localizedDescription)
                }else{
                    let data = snap?.data()
                    self.myname = data!["name"] as! String
                }
            })
        }
        eventName.text = event.eventTitle
        eventDate.text = event.eventDate
        eventDetail.text = event.evetDetail
        postName.text = event.postUserName
        profilePath.downloadURL { url, error in
            if let error = error {
                self.alert(message: error.localizedDescription)
                print(error.localizedDescription)
                // Handle any errors
            } else {
                //imageViewに描画、SDWebImageライブラリを使用して描画
                self.imageView.sd_setImage(with: url!, completed: nil)
                
            }
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        realtimeDB = Database.database().reference()
        realtimeDB.ref.child("event").child("message").child(event.EventID).observe(.value) { (snap) in
            self.getMainArray = [[String]]()
            for item in snap.children {
                //ここは非常にハマるfirebaseはjson形式なので変換が必要
                let child = item as! DataSnapshot
                let dic = child.value as! NSDictionary
                self.getArray = [dic["name"]! as! String, dic["contents"]! as! String]
                self.getMainArray.append(self.getArray)
            }
            print(self.getMainArray)
            self.mainTable.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func post(_ sender: UIButton) {
        
        guard chatPostTextField.text != "" else {
            self.alert(message: "何か入力してください")
            print("何か入力してください")
            return
        }
        contentsArray = ["name": myname,"contents": chatPostTextField.text!]
        realtimeDB = Database.database().reference()
        realtimeDB.ref.child("event").child("message").child(event.EventID).childByAutoId().setValue(contentsArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return getMainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if tableView.tag == 2{
            let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
            let contentsLabel = cell.contentView.viewWithTag(2) as! UILabel
            nameLabel.text = getMainArray[indexPath.row][0]
            contentsLabel.text = getMainArray[indexPath.row][1]
            
        }
        
        return cell
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func report(_ sender: Any) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.id = event.EventID
        appDelegate.segment = "eventReport"
        performSegue(withIdentifier: "go", sender: nil)
    }
    
}
