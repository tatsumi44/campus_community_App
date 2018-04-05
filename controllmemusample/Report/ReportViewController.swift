//
//  ReportViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/04/05.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class ReportViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    let fruits = ["投稿内容が具体性に乏しい","いたずら目的・取引の意図がない", "わいせつ目的", "他人を傷つける投稿", "法令違反・危険行為につながる", "投稿内容がアプリのコンセプトに合わない", "その他"]
    
    @IBOutlet weak var mainTable: UITableView!
    var numOfCell:Int!
    
    var db:Firestore!
    var contents: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.allowsMultipleSelection = false
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        print(indexPath.row)
        // チェックマークを入れる
        numOfCell = indexPath.row
        contents = selectSegment(num: numOfCell)
        cell?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        print(indexPath.row)
        // チェックマークを外す
        cell?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = fruits[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    @IBAction func report(_ sender: Any) {
        db = Firestore.firestore()
        guard numOfCell != nil else {
            self.alert(message: "何か選択してください")
            return
        }
        let alert: UIAlertController = UIAlertController(title: "確認", message: "通報してもよろしいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        let okAction:UIAlertAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            if let id = appDelegate.id,let segment = appDelegate.segment{
                self.db.collection(segment).addDocument(data: [
                    "productID" : id,
                    "reportContents": self.contents
                    ])
                print("OK")
                self.navigationController?.popViewController(animated: true)
            }else{
                print("error")
            }
            
            
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}
