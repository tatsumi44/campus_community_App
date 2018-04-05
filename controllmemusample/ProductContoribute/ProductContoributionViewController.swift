//
//  ProductContoributionViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import DKImagePickerController

class ProductContoributionViewController: UIViewController,UICollectionViewDataSource,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UICollectionViewDelegateFlowLayout {
   
    
    var categorynum: Int!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var getProductDecideTextField: UITextField!
    @IBOutlet weak var productDetailTextField: UITextView!
    
    var imageArray = [UIImage]()
    var imagePathArray = [String]()
    var imageview:UIImageView!
    var pathArray: String!
    var imageNumber = 1
    var selectImage: UIImage!
    var db: Firestore!
    var uid: String!
    var name: String!
    var course: String!
    var grade: String!
    var photoCount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        imageCollectionView.dataSource = self
        let user = Auth.auth().currentUser
        uid = user?.uid
        productNameTextField.delegate = self
        priceTextField.delegate = self
        getProductDecideTextField.delegate = self
        productDetailTextField.delegate = self
        productDetailTextField.layer.borderColor = UIColor.black.cgColor
        productDetailTextField.layer.borderWidth = 1.0
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        productDetailTextField.inputAccessoryView = toolbar
        toolbar.setItems([doneItem], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0
        let imageview = cell.contentView.viewWithTag(1) as! UIImageView
        imageview.frame.size.width = imageCollectionView.frame.width/3 - 3
        imageview.frame.size.height = imageCollectionView.frame.width/3 - 3
        if imageArray.isEmpty == false{
            imageview.image = imageArray[indexPath.row]
        }else{
            print("まだ何もないよ")
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageButton(_ sender: UIButton) {
        //写真を選択し、選択した写真を表示
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 3
        pickerController.didSelectAssets = {(assets: [DKAsset]) in
            // 選択された画像はassetsに入れて返却されますのでfetchして取り出す
            for asset in assets {
                asset.fetchFullScreenImage(true, completeBlock: { (image, info) in
                    self.imageArray.append(image!)
                    print("これが\(String(describing: type(of: image!)))")
                })
                print(self.imageArray)
                self.imageCollectionView.reloadData()
                print("ええで")
            }
            print(self.imageArray.count)
        }
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func decideButton(_ sender: UIButton) {
        //写真のデータはストレージに保存、その他のデータはfirestoreに保存
        //strageに保存
        let storage = Storage.storage()
        let ref = storage.reference()
        let date = NSDate()
        //時間を文字列に整形
        let format = DateFormatter()
        for image in imageArray{
            format.dateFormat = "yyyy_MM_dd_HH_mm_ss_\(self.imageNumber)"
            let datePath = format.string(from: date as Date)
            imagePathArray.append("\(datePath).jpg")
            self.imageNumber += 1
            //画像をjpgのデータ形式に変換
            selectImage = image
            let imageData: Data = UIImageJPEGRepresentation(selectImage, 0.1)!
            let imagePath = ref.child("image").child("goods").child("\(datePath).jpg")
//            db.collection("\(categorynum!)").document(uid).setData(["image\(self.imageNumber)" : "\(datePath).jpg"], options: SetOptions.merge())
            let uploadTask = imagePath.putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    self.alert(message: "アップロード失敗")
                    print("アップロード失敗")
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata.downloadURL
                print(downloadURL)
            }
            
        }
        photoCount = imageArray.count
        guard imageArray.count != 0 else{
            self.alert(message: "画像を選択してください")
            print("画像を選択してください")
            return
        }
        guard productNameTextField.text != "" else {
            self.alert(message: "名前を決定してください")
            print("名前を決定してください")
            return
        }
        guard priceTextField.text != "" else {
            self.alert(message: "価格を決定してください")
            print("価格を決定してください")
            return
        }
        guard getProductDecideTextField.text != "" else {
            self.alert(message: "場所を決定してください")
            print("場所を決定してください")
            return
        }
        guard productDetailTextField.text != "" else {
            self.alert(message: "詳細を決定してください")
            print("詳細を決定してください")
            return
        }
    
        db.collection("\(categorynum!)").addDocument(data: [
            "uid": "\(uid!)",
            "category": "\(categorynum!)",
            "productName": "\(productNameTextField.text!)",
            "price": "\(priceTextField.text!)",
            "place": "\(getProductDecideTextField.text!)",
            "detail": "\(productDetailTextField.text!)",
            "imagePath": imagePathArray,
            ])
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.photoCount = self.photoCount
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func done(){
        productDetailTextField.resignFirstResponder() //キーボードを閉じる
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize1:CGFloat = imageCollectionView.frame.size.width/3 - 3
        return CGSize(width: cellSize1, height: cellSize1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showingKeybord), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidingKeyboard), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        NotificationCenter.default.removeObserver(self)
        return true
    }

}
