//
//  Evaluation.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/08.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class Evaluation {
    var className: String!
    var teacherName: String!
    var course: String!
    var year: String!
    var attendance: String!
    var textbook: String!
    var courseEvaluation: String!
    var different: String!
    var coursedetail: String!
    var postuid: String!
    var middleExamination: String!
    var finalExamination: String!
    var evaluationId: String!
    
    init(className: String,teacherName: String,course: String,year: String,attendance: String,textbook: String,courseEvaluation: String,different: String,coursedetail: String,postuid: String,middleExamination: String,finalExamination: String,evaluationId: String) {
        
        self.className = className
        self.teacherName = teacherName
        self.course = course
        self.year = year
        self.attendance = attendance
        self.textbook = textbook
        self.courseEvaluation = courseEvaluation
        self.different = different
        self.coursedetail = coursedetail
        self.postuid = postuid
        self.middleExamination = middleExamination
        self.finalExamination = finalExamination
        self.evaluationId = evaluationId
    }
    
    
}
