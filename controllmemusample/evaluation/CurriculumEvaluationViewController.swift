//
//  CurriculumEvaluationViewController.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/08.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
class CurriculumEvaluationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    
    
    @IBOutlet weak var mainTable: UITableView!
    
    @IBOutlet weak var postButtonItem: UIBarButtonItem!
    var db: Firestore!
    var evaluationArray = [Evaluation]()
    var numOfcell: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
//        postButtonItem.tintColor = UIColor.orange
        mainTable.dataSource = self
        mainTable.delegate = self
//        mainTable.rowHeight = 200
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        evaluationArray = [Evaluation]()
        db = Firestore.firestore()
        db.collection("courseEvaluation").getDocuments { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
                print("\(error)")
            }else{
                for document in (snap?.documents)!{
                    let data = document.data()
                    self.evaluationArray.append(Evaluation(className: data["courseName"] as! String, teacherName: data["teacherName"] as! String, course: data["course"] as! String, year: data["year"] as! String, attendance: data["attendance"] as! String, textbook: data["textbook"] as! String, courseEvaluation: data["courseEvaluation"] as! String, different: data["different"] as! String, coursedetail: data["courseDetail"] as! String, postuid: data["postUserID"] as! String, middleExamination: data["middleExamination"] as! String, finalExamination: data["finalExamination"] as! String, evaluationId: document.documentID))
                }
                self.mainTable.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let courseName = cell.contentView.viewWithTag(1) as! UILabel
        let teacherName = cell.contentView.viewWithTag(2) as! UILabel
        let year = cell.contentView.viewWithTag(3) as! UILabel
        let course = cell.contentView.viewWithTag(4) as! UILabel
        let courseEvaluation = cell.contentView.viewWithTag(6) as! UILabel
        let difference = cell.contentView.viewWithTag(5) as! UILabel
       
        courseName.text = evaluationArray[indexPath.row].className
        year.text = "\(evaluationArray[indexPath.row].year!)年"
        course.text = evaluationArray[indexPath.row].course
        teacherName.text = "\(evaluationArray[indexPath.row].teacherName!) 教諭"
        courseEvaluation.text = evaluationArray[indexPath.row].courseEvaluation!
        courseEvaluation.textColor = UIColor.orange
        difference.text = evaluationArray[indexPath.row].different!
        difference.textColor = UIColor.orange
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        numOfcell = indexPath.row
        performSegue(withIdentifier: "DetailView", sender: nil)
        print("クリック")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailView"{
            let curriculumDetailViewController = segue.destination as! CurriculumDetailViewController
            curriculumDetailViewController.evaluation = self.evaluationArray[numOfcell]
        }

    }
    
    @IBAction func post(_ sender: Any) {
        performSegue(withIdentifier: "go", sender: nil)
    }
    
    
}
