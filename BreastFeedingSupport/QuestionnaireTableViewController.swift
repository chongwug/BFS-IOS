//
//  QuestionnaireTabViewController.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 4/12/17.
//  Copyright © 2017 CHONG W GUO. All rights reserved.
//
//
// THIS CLASS IS FOR QUESTIONNAIRE SUBMISSION.

import Foundation
import UIKit
class QuestionnaireTabViewController: UITableViewController {
    
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?
    var bfq : BreastfeedingQuestionnaire = BreastfeedingQuestionnaire()
    let patientID : String = "Patient/171428" //Marla
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sumbitButton.isEnabled = false
        
    }
    func enableSubmit() -> Bool{
        if((yes1b.isChecked  || no1b.isChecked) && (yes2b.isChecked || no2b.isChecked) && (yes3b.isChecked || no3b.isChecked) && (yes4b.isChecked || no4b.isChecked) && (yes5b.isChecked || no5b.isChecked) && ( yes6b.isChecked || no6b.isChecked)){
            return true
        }
        
        else{
            return false
        }
    }
  
    @IBOutlet weak var yes1b: CheckBox!
    @IBOutlet weak var no1b: CheckBox!
    @IBOutlet weak var yes2b: CheckBox!
    @IBOutlet weak var no2b: CheckBox!
    @IBOutlet weak var yes3b: CheckBox!
    @IBOutlet weak var no3b: CheckBox!
    @IBOutlet weak var yes4b: CheckBox!
    @IBOutlet weak var no4b: CheckBox!
    @IBOutlet weak var yes5b: CheckBox!
    @IBOutlet weak var no5b: CheckBox!
    @IBOutlet weak var yes6b: CheckBox!
    @IBOutlet weak var no6b: CheckBox!
    @IBOutlet weak var concerns: UITextField!
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func yes1(_ sender: CheckBox) {
        yes1b.isChecked = !yes1b.isChecked
        no1b.isChecked = false
    }

    @IBAction func no1(_ sender: CheckBox) {
        no1b.isChecked = !no1b.isChecked
        yes1b.isChecked = false
    }
 
    @IBAction func yes2(_ sender: Any) {
        yes2b.isChecked = !yes2b.isChecked
        no2b.isChecked = false
    }
    
    @IBAction func no2(_ sender: Any) {
        no2b.isChecked = !no2b.isChecked
        yes2b.isChecked = false
    }
    
    
    @IBAction func yes3(_ sender: Any) {
        yes3b.isChecked = !yes3b.isChecked
        no3b.isChecked = false
    }

    
    @IBAction func no3(_ sender: Any) {
        no3b.isChecked = !no3b.isChecked
        yes3b.isChecked = false
    }
    
    
    @IBAction func yes4(_ sender: Any) {
        yes4b.isChecked = !yes4b.isChecked
        no4b.isChecked = false
    }
    
    
    @IBAction func no4(_ sender: Any) {
        no4b.isChecked = !no4b.isChecked
        yes4b.isChecked = false
    }
    @IBAction func yes5(_ sender: Any) {
        yes5b.isChecked = !yes5b.isChecked
        no5b.isChecked = false
    }
    
    @IBAction func no5(_ sender: Any) {
        no5b.isChecked = !no5b.isChecked
        yes5b.isChecked = false
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func showAlertMsg(_ title: String, message: String, time: Int) {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.baseMessage = message
        self.remainingTime = time
        
        self.alertController = UIAlertController(title: title, message: self.baseMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            print("Alert was cancelled")
            self.alertController=nil;
            self.alertTimer?.invalidate()
            self.alertTimer=nil
        }
        
        self.alertController!.addAction(cancelAction)
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    func countDown() {
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        } else {
            self.alertController!.message = self.alertMessage()
        }
        
    }
    
    func alertMessage() -> String {
        var message=""
        if let baseMessage=self.baseMessage {
            message=baseMessage+" "
        }
        return(message+"\(self.remainingTime)")
    }

    @IBOutlet weak var sumbitButton: UIButton!
    
    @IBAction func submitAction(_ sender: Any) {
        let canSubmit : Bool = enableSubmit()
        if(canSubmit){
            
            bfq.concern = concerns.text ?? ""
            bfq.patientID = patientID
            bfq.q1 = yes1b.isChecked
            bfq.q2 = yes2b.isChecked
            bfq.q3 = yes3b.isChecked
            bfq.q4 = yes4b.isChecked
            bfq.q5 = yes5b.isChecked
            bfq.q6 = yes6b.isChecked
            
            let jsonString = "{\"resourceType\": \"QuestionnaireResponse\",  \"author\": {\"reference\": \"\(bfq.patientID)\" },\"source\": {  \"reference\": \"\(bfq.patientID)\" }, \"identifier\": \"questionnaire\", \"group\": { \"linkId\": \"root\",\"title\": \"Patient questionnaire responses\", \"question\": [  {\"linkId\": \"1\",\"text\": \"Do you feel breastfeeding is going well so far?\", \"answer\": [{  \"valueBoolean\": \"\(bfq.q1)\"} ]},{\"linkId\": \"2\",  \"text\": \"Do you have any concerns?\", \"answer\":[{ \"valueString\": \"\(bfq.concern)\"}]}, {\"linkId\": \"3\",\"text\": \"Has your milk come in? (Between the 2nd and 4th postpartum days, did your breast get firm?\", \"answer\": [ {\"valueBoolean\": \"\(bfq.q2)\"} ] },{ \"linkId\": \"4\", \"text\": \"Does your baby nurse approximately every two or three hours, with no more than one longer interval at night (up to 5 hours)?\", \"answer\": [{\"valueBoolean\": \"\(bfq.q3)\"}] },{ \"linkId\": \"5\",\"text\": \"Is your baby having bowel movements that look like yellow, seedy mustard?\",\"answer\":{\"valueBoolean\": \"\(bfq.q4)\"} },{\"linkId\": \"6\", \"text\": \"Is your baby having at least six wet diapers a day?\",\"answer\":{\"valueBoolean\": \"\(bfq.q5)\"}}, {\"linkId\": \"7\",\"text\": \"Is your baby being fed any infant formula, water, or other liquids\",\"answer\": {\"valueBoolean\": \"\(bfq.q6)\"}}]}}"
            
            let jsonDic = convertToDictionary(text: jsonString)
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDic)
            let url = URL(string: "https://secure-api.hspconsortium.org/FHIRPit/open/QuestionnaireResponse/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            task.resume()
            self.showAlertMsg("Result",message: "Succesfully sumbitted", time: 5)
            
        }else{
            self.showAlertMsg("Result",message: "Please answer all questions", time: 5)
        }
    }
    @IBAction func yes6(_ sender: Any) {
        yes6b.isChecked = !yes6b.isChecked
        no6b.isChecked = false
    }
    
    @IBAction func no6(_ sender: Any) {
        no6b.isChecked = !no6b.isChecked
        yes6b.isChecked = false
       
    }
    
}
