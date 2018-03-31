//
//  PostEvaluationViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/08.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class PostEvaluationViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UITextFieldDelegate {
    
    var db: Firestore!
    
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var teacherNameTextField: UITextField!
    @IBOutlet weak var yearSelectTextField: UITextField!
    @IBOutlet weak var courseSelectTextField: UITextField!
    @IBOutlet weak var attendanceTextField: UITextField!
    @IBOutlet weak var textbookTextField: UITextField!
    @IBOutlet weak var courseEvaluationTextField: UITextField!
    @IBOutlet weak var difflenceTextField: UITextField!
    @IBOutlet weak var courseDetailTextField: UITextView!
    @IBOutlet weak var middleExamination: UITextField!
    @IBOutlet weak var finalExamination: UITextField!
    
    @IBOutlet weak var detailText: UILabel!
    
    let yearArray = ["2015","2016","2017","2018"]
    let courseArray = ["経済学部","商学部","法学部","社会学部"]
    let attendanceArray = ["毎回出席あり","たまに出席を取る","出席は取らない"]
    let textbookArray = ["教科書は必須","教科書はあったほうがいい","教科書は無し・不要"]
    let middleExaminationArray = ["テストのみ","レポートのみ","テストとレポート","両方無し"]
    let finalExaminationArray = ["テストのみ","レポートのみ","テストとレポート","両方無し"]
    let evaluationArray = ["★","★★","★★★","★★★★","★★★★★"]
    let differentArray = ["★","★★","★★★","★★★★","★★★★★"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        let pickerView1 = UIPickerView()
        let pickerView2 = UIPickerView()
        let pickerView3 = UIPickerView()
        let pickerView4 = UIPickerView()
        let pickerView5 = UIPickerView()
        let pickerView6 = UIPickerView()
        let pickerView7 = UIPickerView()
        pickerView.tag = 1
        pickerView1.tag = 2
        pickerView2.tag = 3
        pickerView3.tag = 4
        pickerView4.tag = 5
        pickerView5.tag = 6
        pickerView6.tag = 7
        pickerView7.tag = 8
        pickerView.dataSource = self
        pickerView1 .dataSource = self
        pickerView2.dataSource = self
        pickerView3.dataSource = self
        pickerView4.dataSource = self
        pickerView5.dataSource = self
        pickerView6.dataSource = self
        pickerView7.dataSource = self
        pickerView.delegate = self
        pickerView1.delegate = self
        pickerView2.delegate = self
        pickerView3.delegate = self
        pickerView4.delegate = self
        pickerView5.delegate = self
        pickerView6.delegate = self
        pickerView7.delegate = self
        courseDetailTextField.delegate = self
        classNameTextField.delegate = self
        teacherNameTextField.delegate = self
        yearSelectTextField.inputView = pickerView
        courseSelectTextField.inputView = pickerView1
        attendanceTextField.inputView = pickerView2
        textbookTextField.inputView = pickerView3
        courseEvaluationTextField.inputView = pickerView4
        difflenceTextField.inputView = pickerView5
        middleExamination.inputView = pickerView6
        finalExamination.inputView = pickerView7
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
       
        toolbar.setItems([doneItem], animated: true)
        yearSelectTextField.inputAccessoryView = toolbar
        courseSelectTextField.inputAccessoryView = toolbar
        attendanceTextField.inputAccessoryView = toolbar
        textbookTextField.inputAccessoryView = toolbar
        courseEvaluationTextField.inputAccessoryView = toolbar
        difflenceTextField.inputAccessoryView = toolbar
        courseDetailTextField.inputAccessoryView = toolbar
        middleExamination.inputAccessoryView = toolbar
        finalExamination.inputAccessoryView = toolbar
        courseDetailTextField.inputAccessoryView = toolbar
        classNameTextField.layer.borderColor = UIColor.black.cgColor
        classNameTextField.layer.borderWidth = 0.3
        courseDetailTextField.layer.borderColor = UIColor.black.cgColor
        courseDetailTextField.layer.borderWidth = 1.0
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
           return Int(yearArray.count)
        case 2:
           return Int(courseArray.count)
        case 3:
           return Int(attendanceArray.count)
        case 4:
            return Int(textbookArray.count)
        case 5:
            return Int(evaluationArray.count)
        case 6:
            return Int(differentArray.count)
        case 7:
            return Int(middleExaminationArray.count)
        case 8:
            return Int(finalExaminationArray.count)
        default:
            return 0
        }
        
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return yearArray[row]
        case 2:
            return courseArray[row]
        case 3:
            return attendanceArray[row]
        case 4:
            return textbookArray[row]
        case 5:
            return evaluationArray[row]
        case 6:
            return differentArray[row]
        case 7:
            return middleExaminationArray[row]
        case 8:
            return finalExaminationArray[row]
        default:
            return attendanceArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            yearSelectTextField.text = yearArray[row]
        case 2:
            courseSelectTextField.text = courseArray[row]
        case 3:
            attendanceTextField.text = attendanceArray[row]
        case 4:
            textbookTextField.text = textbookArray[row]
        case 5:
            courseEvaluationTextField.text = evaluationArray[row]
        case 6:
            difflenceTextField.text = differentArray[row]
        case 7:
            middleExamination.text = middleExaminationArray[row]
        case 8:
            finalExamination.text = finalExaminationArray[row]
        default:
            attendanceTextField.text = attendanceArray[row]
        }
        
    }
    
    @objc func done() {
        view.endEditing(true)
    }
    
   
    @IBAction func postButton(_ sender: UIButton) {
        db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid{
            guard classNameTextField.text != "" else{
                self.alert(message: "クラスの名前を入力してください" )
                print("クラスの名前を入力してください")
                return
            }
            guard teacherNameTextField.text != "" else{
                 self.alert(message: "先生の名前を打ち込んで" )
                print("を打ち込んで")
                return
            }
            guard yearSelectTextField.text != "" else{
                 self.alert(message: "年度を打ち込んで" )
                print("年度を打ち込んで")
                return
            }
            guard courseSelectTextField.text != "" else {
                 self.alert(message: "年度を打ち込んで")
                print("年度を打ち込んで")
                return
            }
            guard  attendanceTextField.text != "" else {
                 self.alert(message: "年度を打ち込んで")
                print("年度を打ち込んで")
                return
            }
            guard textbookTextField.text != "" else {
                 self.alert(message: "教科書の有無を打ち込んで")
                print("教科書の有無を打ち込んで")
                return
            }
            guard courseEvaluationTextField.text != "" else {
                 self.alert(message: "評価を打ち込んで")
                print("評価を打ち込んで")
                return
            }
            guard difflenceTextField.text != "" else {
                 self.alert(message: "難易度を打ち込んで")
                print("難易度を打ち込んで")
                return
            }
            guard courseDetailTextField.text != "" else {
                 self.alert(message: "詳細を打ち込んで")
                print("詳細を打ち込んで")
                return
            }
            guard middleExamination.text != "" else {
                 self.alert(message: "中間試験の詳細を打ち込んで")
                print("中間試験の詳細を打ち込んで")
                return
            }
            guard finalExamination.text != "" else {
                 self.alert(message: "期末試験の詳細を打ち込んで")
                print("期末試験の詳細を打ち込んで")
                return
            }
            
            
            db.collection("courseEvaluation").addDocument(data: [
                
                "courseName": classNameTextField.text!,
                "teacherName": teacherNameTextField.text!,
                "year" : yearSelectTextField.text! ,
                "course": courseSelectTextField.text!,
                "attendance": attendanceTextField.text!,
                "textbook": textbookTextField.text!,
                "courseEvaluation": courseEvaluationTextField.text!,
                "middleExamination": middleExamination.text!,
                "finalExamination": finalExamination.text!,
                "different": difflenceTextField.text!,
                "courseDetail": courseDetailTextField.text!,
                "postUserID": uid
                
                ])
            
            self.navigationController?.popViewController(animated: true)
        }
        
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
        if (courseDetailTextField.text?.isEmpty)!{
            detailText.isHidden = false
            print("ここまで呼ばれている")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
