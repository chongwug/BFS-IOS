//
//  BreastfeedingQuestionnaire.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/16/17.
//  Copyright © 2017 CHONG W GUO. All rights reserved.
//

//the class for breastfeeding questionnaire
import Foundation

class BreastfeedingQuestionnaire{
    
    
    var patientID : String = ""
    var q1 : Bool = true
    var concern : String = ""
    var q2 : Bool = true
    var q3 : Bool = true
    var q4 : Bool = true
    var q5 : Bool = true
    var q6 : Bool = true
    init(){
         patientID = ""
         q1 = true
         concern = ""
         q2 = true
         q3 = true
         q4 = true
         q5 = true
         q6 = true
    }
    init(patientID: String, q1: Bool, q2 : Bool, q3: Bool, q4 : Bool, q5 : Bool, q6 : Bool , concern : String){
        self.patientID = patientID
        self.q1 = q1
        self.q2 = q2
        self.q3 = q3
        self.q4 = q4
        self.q5 = q5
        self.q6 = q6
        self.concern = concern
    }
}
