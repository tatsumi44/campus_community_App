//
//  OtherMenuViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
class OtherMenuViewController: UIViewController,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate {
    
    
    //異なるStorybordに画面遷移するのでこれを用いる、nameでStorybordの名前を指定
    let storybord: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    var uid: String!
    var profielArray = [String]()
    var db: Firestore!
    let titleArray = ["アプリチュートリアル","その他"]
    let logoutArray = ["ログアウト"]
    let tutorialArray = ["商品の受け取り場所","商品の受け渡し方法","チャットで決定するべき事項"]
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        menuTableView.dataSource = self
        menuTableView.delegate = self
        menuTableView.rowHeight = 60
        self.navigationItem.title = "その他"
        imageView.layer.cornerRadius = 75.0
        imageView.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = Auth.auth().currentUser
        uid = user?.uid
        db = Firestore.firestore()
        let ref = Storage.storage().reference()
        //db接続
        if user != nil{
            db.collection("users").document(uid).getDocument { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let data = snap?.data()
                    let name = data!["name"] as? String
                    let course = data!["course"] as? String
                    let grade = data!["grade"] as? String
                    self.profielArray = ["\(name!)さん","\(course!)学部","\(grade!)年生"]
                    print(self.profielArray)
                    self.mainTableView.reloadData()
                }

            }
        }else{
            let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let nextView = storyboard.instantiateInitialViewController()
            present(nextView!, animated: true, completion: nil)
            print("ログインいるで")
        }
        
        if Auth.auth().currentUser != nil{
            
            db.collection("users").document(uid).getDocument { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                }else{
                    let data = snap?.data()
                    
                    if let profilePath = data!["profilePath"]{
                        ref.child("image").child("profile").child(profilePath as! String).downloadURL { url, error in
                            if let error = error {
                                // Handle any errors
                                print("\(error)")
                            } else {
                                //imageViewに描画、SDWebImageライブラリを使用して描画
                                self.imageView.sd_setImage(with: url!, completed: nil)
                            }
                        }
                    }else{
                        print("nil")
                    }
                }
            }
        }
    }
    //一つのセクションにおける個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return profielArray.count
        }
        switch section {
        case 0:
            return tutorialArray.count
        case 1:
            return logoutArray.count
        default:
            return 0
        }
    }
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        if tableView.tag == 1{
            cell.textLabel?.text = profielArray[indexPath.row]
        }
        
        if tableView.tag == 2{
            switch indexPath.section{
            case 0:
                cell.textLabel?.text = tutorialArray[indexPath.row]
            case 1:
                cell.textLabel?.text = logoutArray[indexPath.row]
            default :
                break
            }
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        return cell
    }
    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 2{
            return titleArray.count
        }
        return 1
    }
    
    //tableViewのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1{
            return nil
        }
        return titleArray[section]
    }
    //タイトルの色を決定
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.orange
        }
    }
    //セルのクリックイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section\(indexPath.section):row\(indexPath.row)")
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                print("まだ")
            case 1:
                performSegue(withIdentifier: "placePoint", sender: nil)
            case 2:
                performSegue(withIdentifier: "postPoint", sender: nil)
            case 3:
                performSegue(withIdentifier: "chatPoint", sender: nil)
            default:
                return
            }
        }

       
        if indexPath.section == 1 && indexPath.row == 0{
            logout()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //指定したStorybordの一番最初に画面遷移
            let nextView = storybord.instantiateInitialViewController()
            present(nextView!, animated: true, completion: nil)
            print("通っている")
            
        } catch let signOutError as NSError {
//            alert(message: ("Error signing out: %@", signOutError.))
            print ("Error signing out: %@", signOutError.localizedDescription)
        }
    }
    
    
    @IBAction func choiceLibraly(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        let date = NSDate()
        //時間を文字列に整形
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        //整形した文字列を画像のpathに整形
        let datePath = format.string(from: date as Date)
        
        db.collection("users").document(uid).updateData(["profilePath" : "\(datePath)_\(uid!).jpg"]) { (error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
                print("\(error)")
                
            }else{
                let data: Data = UIImageJPEGRepresentation(image!, 0.1)!
                //ストレージの保存先のpathを指定
                let ref = Storage.storage().reference()
                let imagePath = ref.child("image").child("profile").child("\(datePath)_\(self.uid!).jpg")
                let uploadTask = imagePath.putData(data, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    let downloadURL = metadata.downloadURL
                    print(downloadURL)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
