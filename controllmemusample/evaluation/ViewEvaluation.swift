//
//  ViewEvaluation.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/29.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class ViewEvaluation {
    var className: String!
    var teacherName: String!
    var course: String!
    var year: String!
    var courseEvaluation: String!
    var different: String!
    var postuid: String!
    
    
    
    init(className: String,teacherName: String,course: String,year: String,courseEvaluation: String,different: String,postuid: String) {
        self.className = className
        self.teacherName = teacherName
        self.course = course
        self.year = year
        self.courseEvaluation = courseEvaluation
        self.different = different
    }
}
