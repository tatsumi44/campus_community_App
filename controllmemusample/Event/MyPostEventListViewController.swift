//
//  MyPostEventListViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/15.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class MyPostEventListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    var db: Firestore!
    var eventArray = [Event]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid{
            db.collection("event").whereField("postUser", isEqualTo: uid).getDocuments(completion: { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                }else{
                    for document in (snap?.documents)!{
                        let data = document.data()
                        self.eventArray.append(Event(postUserID: data["postUser"] as! String, EventID: document.documentID, eventDate: data["eventDate"] as! String, eventTitle: data["eventTitle"] as! String, evetDetail: data["eventDetail"] as! String))
                    }
                    self.mainTableView.reloadData()
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        let dateLabel = cell.contentView.viewWithTag(3) as! UILabel
        let detailLabel = cell.contentView.viewWithTag(4) as! UILabel
        let nameLabel = cell.contentView.viewWithTag(5) as! UILabel
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        titleLabel.text = eventArray[indexPath.row].eventTitle
        dateLabel.text = eventArray[indexPath.row].eventDate
        detailLabel.text = eventArray[indexPath.row].evetDetail
        db = Firestore.firestore()
        let storage = Storage.storage().reference()
        if let uid = Auth.auth().currentUser?.uid{
            db.collection("users").document(uid).getDocument(completion: { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                   let data = snap?.data()
                    let name = data!["name"] as! String
                    nameLabel.text = name
                    let path = data!["profilePath"] as! String
                    let profilePath = storage.child("image/profile/\(path)")
                    profilePath.downloadURL { url, error in
                        if let error = error {
                            self.alert(message: error.localizedDescription)
                            print(error.localizedDescription)
                            // Handle any errors
                        } else {
                            //imageViewに描画、SDWebImageライブラリを使用して描画
                            imageView.sd_setImage(with: url!, completed: nil)
                        }
                    }
                }
            })
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
           
            let eventID: String = eventArray[indexPath.row].EventID
            eventArray.remove(at: indexPath.row)
            db.collection("event").document(eventID).delete(completion: { (error) in
                if let error = error {
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                }else{
                    print("remove succesfully")
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    print("削除完了")
                }
            })
        }
    }
}
