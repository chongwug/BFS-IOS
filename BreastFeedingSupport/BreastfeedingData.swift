//
//  BreastfeedingData.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/6/17.
//  Copyright © 2017 CHONG W GUO. All rights reserved.
//

//the class for Breastfeeding data 
import Foundation

class BreastfeedingData{

    
    var patientID : String = ""
    var sStart = "" //start string
    var sStop = ""//stop string
    var sDuration = ""//duration string

    var sDate = ""//date string
    var pDetail = ""//poop/pee string
    var leftDetail : String = "" //left breast string
    var rightDetail : String = ""//right breast string
    
    init(){
        patientID = ""
        sStart = ""
        sStop = ""
        sDuration = ""
        sDate = ""
        pDetail = ""
        leftDetail = ""
        rightDetail = ""
        
    }
    init(patientID: String, sDate: String,sStart: String, sStop: String, Sduration: String, pDetail: String, leftDetail: String, rightDetail: String){
        self.patientID = patientID
        self.sDate = sDate
        self.sStart = sStart
        self.sStop = sStop
        self.sDuration = Sduration
        self.pDetail = pDetail
        self.leftDetail = leftDetail
        self.rightDetail = rightDetail
    }
}
