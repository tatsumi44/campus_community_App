//
//  EmailRegisterViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/02/23.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class EmailRegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var grade: UITextField!
    @IBOutlet weak var course: UITextField!
    
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        name.delegate = self
        grade.delegate = self
        course.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error{
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
                    let storyboard = UIStoryboard(name: "A", bundle: nil)
                    let dstView = storyboard.instantiateViewController(withIdentifier: "FirstViewController")
                    self.tabBarController?.present(dstView, animated: true, completion: nil)
                    //ウルトラ重要、おそらくrootViewControllerが重なっているので解放が必要。
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
