//
//  Event.swift
//  controllmemusample
//
//  Created by tatsumi kentaro on 2018/03/06.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class Event {
    var postUserID: String!
    var EventID: String!
    var eventDate: String!
    var eventTitle: String!
    var evetDetail: String!
    var postUserName: String!
    
    init(postUserID: String,EventID: String,eventDate: String,eventTitle: String,evetDetail: String) {
        self.postUserID = postUserID
        self.EventID = EventID
        self.eventDate = eventDate
        self.eventTitle = eventTitle
        self.evetDetail = evetDetail
        
    }
}
