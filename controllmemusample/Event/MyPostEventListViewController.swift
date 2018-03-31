//
//  MyPostEventListViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/15.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
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
        
        let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
        let dateLabel = cell.contentView.viewWithTag(2) as! UILabel
        let detailLabel = cell.contentView.viewWithTag(3) as! UILabel
       
        titleLabel.text = eventArray[indexPath.row].eventTitle
        dateLabel.text = eventArray[indexPath.row].eventDate
        detailLabel.text = eventArray[indexPath.row].evetDetail
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
           
            let eventID: String = eventArray[indexPath.row].EventID
            eventArray.remove(at: indexPath.row)
            db.collection("event").document(eventID).delete(completion: { (error) in
                if let error = error {
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
