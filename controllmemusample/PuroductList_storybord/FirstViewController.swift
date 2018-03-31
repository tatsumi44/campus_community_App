//
//  FirstViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import NVActivityIndicatorView
import Instructions

class FirstViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CoachMarksControllerDataSource,CoachMarksControllerDelegate  {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationbar: UINavigationBar!
    
    
    var db1: Firestore!
    var db: DatabaseReference!
    var getmainArray = [StorageReference]()
    var getcontents: String!
    var productArray = [Product]()
    var imagePathArray = [String]()
    var cellOfNum: Int!
    var photoCount: Int!
    let sectionID: Int = 1
    var posArray = [CGFloat]()
    let coachMarksController = CoachMarksController()
    let pointOfInterest = UIView()
    let pointOfInterest1 = UIView()
    let pointOfInterest2 = UIView()
    let pointOfInterest3 = UIView()
    let pointOfInterest4 = UIView()
    let pointOfInterest5 = UIView()
    var firstViewIntroduction: Bool!
    var cellOfPosArray = [[CGFloat]]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        posArray = appDelegate.posArray
        self.coachMarksController.dataSource = self
        print(posArray)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil{
            print("ユーザーいるよ")
            
        }else{
            print("戻ろうか")
            let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let nextView = storyboard.instantiateInitialViewController()
            present(nextView!, animated: true, completion: nil)
        }
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.photoCount = appDelegate.photoCount
        print("これは\(self.photoCount)")
        self.mainCollectionView.reloadData()
        productArray = [Product]()
        getmainArray = [StorageReference]()
        imagePathArray = [String]()
        let storage = Storage.storage().reference()
        db1 = Firestore.firestore()
    
        db1.collection("1").getDocuments { (snap, error) in
            if let error = error{
                self.alert(message: "Error getting documents: \(error.localizedDescription)")
                print("Error getting documents: \(error)")
            }else{
                for document in snap!.documents {
                    let image1 = document.data()["imagePath"]! as? [String]
                    print(image1![0])
                    print(String(describing: type(of: image1![0])))
                    
                    self.productArray.append(Product(productName: "\(document.data()["productName"] as! String)", productID: "\(document.documentID)", price: "\(document.data()["price"] as! String)", imageArray: image1!, detail: "\(document.data()["detail"] as! String)", uid: "\(document.data()["uid"] as! String)",place: "\(document.data()["place"] as! String)"))
                    
                    self.imagePathArray.append(image1![0])
                    
                }
                print(self.productArray)
                for path in self.imagePathArray{
                    let ref = storage.child("image/goods/\(path)")
                    self.getmainArray.append(ref)
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.productArray = self.productArray
                print("いいね")
                print(self.getmainArray)
                self.mainCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        db1 = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid{
            db1.collection("users").document(uid).getDocument(completion: { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    print("\(error)")
                }else{
                  let data = snap?.data()
                    //ここでInstructionsスタート
                    self.firstViewIntroduction = data!["firstViewIntroduction"] as! Bool
                    if self.firstViewIntroduction == false{
                        self.coachMarksController.start(on: self)
                    }
                }
            })
        }else{
                        let storybord: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                        let nextView = storybord.instantiateInitialViewController()
                        present(nextView!, animated: true, completion: nil)
        }
        
        //        self.coachMarksController.overlay.color = UIColor.blue
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let uid = Auth.auth().currentUser?.uid{
            if self.firstViewIntroduction == false{
                //ここでInstructionsストップ
                self.coachMarksController.stop(immediately: true)
                self.firstViewIntroduction = true
                //firstViewIntroductionをtrueに切り替え、以後表示されない
                db1.collection("users").document(uid).updateData(["firstViewIntroduction" : true])
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getmainArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        print("これは\([cell.frame.origin.x,cell.frame.origin.y,cell.frame.width,cell.frame.height])")
        cellOfPosArray.append([cell.frame.origin.x,cell.frame.origin.y,cell.frame.width,cell.frame.height])
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.frame.size.width = cell.frame.width
        imageView.frame.size.height = cell.frame.height/4 * 3
//        cell.backgroundColor = UIColor.orange
        cell.layer.borderColor = UIColor.orange.cgColor
        cell.layer.borderWidth = 1
        imageView.layer.cornerRadius = 4.0
        cell.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        let nameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let priceLabel = cell.contentView.viewWithTag(3) as! UILabel
        let placeLabel = cell.contentView.viewWithTag(4) as! UILabel
        nameLabel.text = productArray[indexPath.row].productName
//        nameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        priceLabel.text = "¥\(productArray[indexPath.row].price!)"
        placeLabel.text = productArray[indexPath.row].place
        //getmainArrayにあるpathをurl型に変換しimageViewに描画
        getmainArray[indexPath.row].downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print("\(error)")
            } else {
                print(url!)
                //imageViewに描画、SDWebImageライブラリを使用して描画
                imageView.sd_setImage(with: url!, completed: nil)
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize1:CGFloat = mainCollectionView.frame.size.width/3 - 3
        let cellSize2: CGFloat = mainCollectionView.frame.size.height/3 - 3
        return CGSize(width: cellSize1, height: cellSize2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cellOfNum = indexPath.row
        appDelegate.cellOfNum = self.cellOfNum
        appDelegate.sectionID = self.sectionID
    }
    
    //Instructionsライブラリを使うために必須
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        let coachViews1 = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        let coachViews2 = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        let coachViews3 = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        let coachViews4 = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        let coachViews5 = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = "この画面では商品の取引や投稿を行うよ"
        coachViews.bodyView.nextLabel.text = "OK"
        coachViews1.bodyView.hintLabel.text = "この画面では取引相手とのチャットや自分の投稿を管理することができるよ"
        coachViews1.bodyView.nextLabel.text = "OK"
        coachViews2.bodyView.hintLabel.text = "この画面ではイベントの投稿をすることができるよ"
        coachViews2.bodyView.nextLabel.text = "OK"
        coachViews3.bodyView.hintLabel.text = "この画面では授業の評価を見たり、投稿することができるよ"
        coachViews3.bodyView.nextLabel.text = "OK"
        coachViews4.bodyView.hintLabel.text = "このボタンを押すと自分の持っているノート、過去問、レジュメを投稿することができるよ"
        coachViews4.bodyView.nextLabel.text = "OK"
        coachViews5.bodyView.hintLabel.text = "商品をタップすると商品の詳細を確認できて、出品者との取引を行うことができるよ"
        coachViews5.bodyView.nextLabel.text = "OK"
        let coachViewArray = [coachViews,coachViews1,coachViews2,coachViews3,coachViews4,coachViews5]
        
        //        coachViews.bodyView.backgroundColor = UIColor.orange
        return (bodyView: coachViewArray[index].bodyView, arrowView: coachViewArray[index].arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        pointOfInterest.frame = CGRect(x: 0, y: posArray[1], width: posArray[2]/5, height: posArray[3])
        pointOfInterest1.frame = CGRect(x: posArray[2]/5, y: posArray[1], width: posArray[2]/5, height: posArray[3])
        pointOfInterest2.frame = CGRect(x: posArray[2]/5 * 2, y: posArray[1], width: posArray[2]/5, height: posArray[3])
        pointOfInterest3.frame = CGRect(x: posArray[2]/5 * 3, y: posArray[1], width: posArray[2]/5, height: posArray[3])
        pointOfInterest4.frame = CGRect(x: 300, y:0, width: 70, height: 60)
        pointOfInterest5.frame = CGRect(x: cellOfPosArray[0][0], y: cellOfPosArray[0][1], width: cellOfPosArray[0][2], height: cellOfPosArray[0][3])
        
        
        let pointOfInterestArray = [pointOfInterest,pointOfInterest1,pointOfInterest2,pointOfInterest3,pointOfInterest4,pointOfInterest5]
        //        pointOfInterest.backgroundColor = UIColor.orange
        return coachMarksController.helper.makeCoachMark(for: pointOfInterestArray[index])
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 6
    }

}
