//
//  EmailRegisterViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class EmailRegisterViewController: UIViewController,UITextFieldDelegate ,UIPickerViewDelegate,UIPickerViewDataSource {
 
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var grade: UITextField!
    @IBOutlet weak var course: UITextField!
    
    var db: Firestore!
    let courseArray = ["経済学部","商学部","法学部","社会学部"]
    let gradeArray = ["1年","2年","3年","4年"]
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        name.delegate = self
        grade.delegate = self
        course.delegate = self
        let pickerView = UIPickerView()
        let pickerView1 = UIPickerView()
        pickerView.tag = 1
        pickerView1.tag = 2
        pickerView.dataSource = self
        pickerView1.dataSource = self
        pickerView.delegate = self
        pickerView1.delegate = self
        grade.inputView = pickerView
        course.inputView = pickerView1
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        toolbar.setItems([doneItem], animated: true)
        grade.inputAccessoryView = toolbar
        course.inputAccessoryView = toolbar
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
            return Int(gradeArray.count)
        case 2:
            return Int(courseArray.count)
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return gradeArray[row]
        case 2:
            return courseArray[row]
        default:
            return courseArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            return grade.text = gradeArray[row]
        case 2:
            return  course.text = courseArray[row]
        default:
            return course.text = courseArray[row]
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        guard emailTextField.text != "" else {
            self.alert(message: "emailを入力してください")
            return
        }
        guard passwordTextField.text != "" else {
            self.alert(message: "パスワードを入力してください")
            return
        }
        guard name.text != "" else {
            self.alert(message: "名前を入力してください")
            return
        }
        guard grade.text != "" else {
            self.alert(message: "学年を入力してください")
            return
        }
        guard course.text != "" else {
            self.alert(message: "学部を入力してください")
            return
        }
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
                print(error.localizedDescription)
                //後でアラートを出す処理とか書く予定
            }else{
                if let uid = Auth.auth().currentUser?.uid{
                    print("uid:\(uid)")
                    self.db = Firestore.firestore()
                    let name: String =  self.name.text!
                    let email: String = self.emailTextField.text!
                    let course = self.course.text!
                    let grade = self.grade.text!
                    self.db.collection("users").document(uid).setData([
                        "name" : name,
                        "email" : email,
                        "id" : uid,
                        "course" : course,
                        "grade" : grade,
                        "firstViewIntroduction" : false,
                        "produntDetailIntroduction": false,
                        ])
//                    let storyboard = UIStoryboard(name: "A", bundle: nil)
//                    let dstView = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
//                    self.tabBarController?.present(dstView, animated: true, completion: nil)
//                    //ウルトラ重要、おそらくrootViewControllerが重なっているので解放が必要。
//                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                    let actionCodeSettings = ActionCodeSettings()
                    actionCodeSettings.url = URL(string: "https://u8qgg.app.goo.gl/top1")
                    actionCodeSettings.handleCodeInApp = true
                    print(Bundle.main.bundleIdentifier!)
                    actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
                    Auth.auth().currentUser?.sendEmailVerification(with: actionCodeSettings, completion: { (error) in
                        if let error = error{
                            print(error.localizedDescription)
                        }else{
                            print("success")
                        }
                    })
                }

            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func done(){
        view.endEditing(true)
    }
}
