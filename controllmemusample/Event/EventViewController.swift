//
//  EventViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/06.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class EventViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var maintableView: UITableView!
    
    var db: Firestore!
    var eventArray = [Event]()
    var numOfCell:Int!
    var name : String!
    var profilePath : StorageReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        maintableView.dataSource = self
        maintableView.delegate = self
        self.navigationItem.title = "イベント情報"

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        db = Firestore.firestore()
        eventArray = [Event]()
        maintableView.separatorColor = UIColor.clear
        self.db.collection("event").getDocuments { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
                print(error.localizedDescription)
            }else{
                for document in (snap?.documents)!{
                    let data = document.data()
                    self.eventArray.append(Event(postUserID: data["postUser"] as! String, EventID: document.documentID, eventDate: data["eventDate"] as! String, eventTitle: data["eventTitle"] as! String, evetDetail: data["eventDetail"] as! String))
                }
                self.maintableView.reloadData()
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = maintableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor

        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        let dateLabel = cell.contentView.viewWithTag(3) as! UILabel
        let detailLabel = cell.contentView.viewWithTag(4) as! UILabel
        let nameLabel = cell.contentView.viewWithTag(5) as! UILabel
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        detailLabel.numberOfLines = 0
        
        titleLabel.sizeToFit()
        detailLabel.sizeToFit()
        dateLabel.sizeToFit()
        nameLabel.sizeToFit()
        
        titleLabel.text = self.eventArray[indexPath.row].eventTitle
        detailLabel.text = self.eventArray[indexPath.row].evetDetail
        dateLabel.text = self.eventArray[indexPath.row].eventDate
        db.collection("users").document(eventArray[indexPath.row].postUserID).getDocument { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
                print("\(error)")
            }else{
                let data = snap?.data()
                nameLabel.text = data!["name"] as? String
                self.name = data!["name"] as? String
                let imagePath = data!["profilePath"] as? String
                
                let storage = Storage.storage().reference()
                let path = storage.child("image/profile/\(imagePath!)")
                self.profilePath = storage.child("image/profile/\(imagePath!)")
                path.downloadURL { url, error in
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        numOfCell = indexPath.row
        performSegue(withIdentifier: "goDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail"{
            let eventDetailViewController = segue.destination as! EventDetailViewController
            eventDetailViewController.event = self .eventArray[numOfCell]
            eventDetailViewController.name = self.name
            eventDetailViewController.profilePath = self.profilePath
        }
    }

}

