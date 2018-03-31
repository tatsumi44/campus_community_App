//
//  MyPostProductListViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/14.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
class MyPostProductListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    var db: Firestore!
    let titleArray = ["教科書","ノート","過去問"]
    var textBookArray = [Product]()
    var noteBookArray = [Product]()
    var pastExaminatioArray = [Product]()
    let storage = Storage.storage().reference()
    
    
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
            db.collection("1").whereField("uid", isEqualTo: "\(uid)").getDocuments(completion: { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                }else{
                    for document in (snap?.documents)!{
                        let data = document.data()
                        self.textBookArray.append(Product(productName: data["productName"] as! String, productID: document.documentID, price: data["price"] as! String, imageArray: data["imagePath"] as! [String], detail: data["detail"] as! String, uid: data["uid"] as! String, place: data["place"] as! String))
                    }
                }
            })
            db.collection("2").whereField("uid", isEqualTo: "\(uid)").getDocuments(completion: { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                }else{
                    for document in (snap?.documents)!{
                        let data = document.data()
                        self.noteBookArray.append(Product(productName: data["productName"] as! String, productID: document.documentID, price: data["price"] as! String, imageArray: data["imagePath"] as! [String], detail: data["detail"] as! String, uid: data["uid"] as! String, place: data["place"] as! String))
                    }
                }
            })
            db.collection("3").whereField("uid", isEqualTo: "\(uid)").getDocuments(completion: { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                }else{
                    for document in (snap?.documents)!{
                        let data = document.data()
                        self.pastExaminatioArray.append(Product(productName: data["productName"] as! String, productID: document.documentID, price: data["price"] as! String, imageArray: data["imagePath"] as! [String], detail: data["detail"] as! String, uid: data["uid"] as! String, place: data["place"] as! String))
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleArray[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return textBookArray.count
        case 1:
            return noteBookArray.count
        case 2:
            return pastExaminatioArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let image = cell.contentView.viewWithTag(1) as! UIImageView
        let productName = cell.contentView.viewWithTag(2) as! UILabel
        let price = cell.contentView.viewWithTag(3) as! UILabel
        let place = cell.contentView.viewWithTag(4) as! UILabel
        switch indexPath.section {
        case 0:
            productName.text = textBookArray[indexPath.row].productName
            price.text = textBookArray[indexPath.row].price
            place.text = textBookArray[indexPath.row].place
            let imagePath = textBookArray[indexPath.row].imageArray[0]
            let ref = storage.child("image/goods/\(imagePath)")
            ref.downloadURL { url, error in
                if let error = error {
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                    // Handle any errors
                } else {
                    print(url!)
                    //imageViewに描画、SDWebImageライブラリを使用して描画
                    image.sd_setImage(with: url!, completed: nil)
                }
            }
        case 1:
            productName.text = noteBookArray[indexPath.row].productName
            price.text = noteBookArray[indexPath.row].price
            place.text = noteBookArray[indexPath.row].place
            let imagePath = noteBookArray[indexPath.row].imageArray[0]
            let ref = storage.child("image/goods/\(imagePath)")
            ref.downloadURL { url, error in
                if let error = error {
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                    // Handle any errors
                } else {
                    print(url!)
                    //imageViewに描画、SDWebImageライブラリを使用して描画
                    image.sd_setImage(with: url!, completed: nil)
                }
            }
        case 2:
            productName.text = pastExaminatioArray[indexPath.row].productName
            price.text = pastExaminatioArray[indexPath.row].price
            place.text = pastExaminatioArray[indexPath.row].place
            let imagePath = pastExaminatioArray[indexPath.row].imageArray[0]
            let ref = storage.child("image/goods/\(imagePath)")
            ref.downloadURL { url, error in
                if let error = error {
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                    // Handle any errors
                } else {
                    print(url!)
                    //imageViewに描画、SDWebImageライブラリを使用して描画
                    image.sd_setImage(with: url!, completed: nil)
                }
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            switch indexPath.section {
            case 0:
                let productID: String = textBookArray[indexPath.row].productID
                textBookArray.remove(at: indexPath.row)
                db.collection("1").document("\(productID)").delete(completion: { (error) in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                        print("\(error)")
                    }else{
                        print("Document successfully removed!")
                    }
                    tableView.deleteRows(at: [indexPath], with:  .fade)
                })
            case 1:
                let productID: String = noteBookArray[indexPath.row].productID
                noteBookArray.remove(at: indexPath.row)
                db.collection("2").document("\(productID)").delete(completion: { (error) in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                        print("\(error)")
                    }else{
                        print("Document successfully removed!")
                    }
                    tableView.deleteRows(at: [indexPath], with:  .fade)
                })
            case 2:
                let productID: String = pastExaminatioArray[indexPath.row].productID
                pastExaminatioArray.remove(at: indexPath.row)
                db.collection("3").document("\(productID)").delete(completion: { (error) in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                        print("\(error)")
                    }else{
                        print("Document successfully removed!")
                        tableView.deleteRows(at: [indexPath], with:  .fade)
                        print("削除した")
                    }

                })
            default:
                break
            }
        }
    }
    
}
