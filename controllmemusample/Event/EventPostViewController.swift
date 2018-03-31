//
//  EventPostViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/06.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
class EventPostViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var db: Firestore!
    var toolBar:UIToolbar!
    var myDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextField.layer.borderColor = UIColor.black.cgColor
        detailTextField.layer.borderWidth = 0.3
        detailTextField.delegate = self
        titleTextField.delegate = self
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        detailTextField.inputAccessoryView = toolbar
        toolbar.setItems([doneItem], animated: true)
   // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        detailText.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(showingKeybord), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidingKeyboard), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
        print("開始")
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("終了")
        NotificationCenter.default.removeObserver(self)
        if (detailTextField.text?.isEmpty)!{
            detailText.isHidden = false
            print("ここまで呼ばれている")
        }
    }
   
    
    @IBAction func post(_ sender: Any) {
        
        guard detailTextField.text.characters.count < 200 else {
            self.alert(message: "文字数が多すぎます")
            print("文字数が多すぎます")
            return
        }
        guard detailTextField.text != "" else{
            self.alert(message: "詳細を入力してください")
            print("何か入力してください")
            return
        }
        guard titleTextField.text != "" else {
            self.alert(message: "タイトルを入力してください")
            print("何か入力してください")
            return
        }
        let date = datePicker.date
        let format = DateFormatter()
        format.dateFormat = "yyyy年MM月dd日HH時mm分"
        let datePath = format.string(from: date as Date)
        db = Firestore.firestore()
        let uid: String = (Auth.auth().currentUser?.uid)!
        db.collection("event").addDocument(data:[
            "postUser": uid,
            "eventTitle": titleTextField.text!,
            "eventDate": datePath,
            "eventDetail": detailTextField.text!,
            "postDate":  NSDate()
            ])
        print(datePath)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func done(){
        detailTextField.resignFirstResponder() 
    }
    

}
