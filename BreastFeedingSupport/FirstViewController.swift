//
//  FirstViewController.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 3/15/17.
//  Copyright © 2017 CHONG W GUO. All rights reserved.
//
//the tab for recording breastfeeding data

import UIKit

class FirstViewController: UITableViewController {
    //variables for stop watch component
    var startTimeGlobal = Date()
    var stopTimeGlobal = Date()
    var durationGlobal = ""
    var timer2 = Timer()
    var startTime = TimeInterval()
    var started = false
    
    //data holder
    var bfd : BreastfeedingData = BreastfeedingData()
    
    let patientID : String = "Patient/171428" //hardcoded for patient Marla

    
    var canSubmit = false
    
    //variables for alerts
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?

    //convert string to dictionary
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
    
    
    
//check if can submit, and parse data to json and post it to fhir server
    @IBAction func submitButtonAction(_ sender: Any) {
        
        if(canSubmit){
            bfd.patientID = patientID
            bfd.pDetail = checkP()
            bfd.leftDetail = checkBFL()
            bfd.rightDetail = checkBFR()
            let jsonString = "{\"resourceType\": \"QuestionnaireResponse\",  \"author\": {\"reference\": \"\(patientID)\" },\"source\": {  \"reference\": \"\(bfd.patientID)\" }, \"identifier\": \"data\", \"group\": { \"linkId\": \"root\",\"title\": \"Patient Generated Breastfeeding Data \", \"question\": [  {\"linkId\": \"1\",\"text\": \"What date is this\", \"answer\": [{  \"valueDate\": \"\(bfd.sDate)\"} ]},{\"linkId\": \"2\",  \"text\": \"Start time\", \"answer\":[{ \"valueString\": \"\(bfd.sStart)\"}]}, {\"linkId\": \"3\",\"text\": \"Stop time\", \"answer\": [ {\"valueString\": \"\(bfd.sStop)\"} ] },{ \"linkId\": \"4\", \"text\": \"Duration\", \"answer\": [{\"valueString\": \"\(bfd.sDuration)\"}] },{ \"linkId\": \"5\",\"text\": \"Diaper poop and/or pee\",\"answer\":{\"valueString\": \"\(bfd.pDetail)\"} },{\"linkId\": \"6\", \"text\": \"Breastfeeding left breast\",\"answer\":{\"valueString\": \"\(bfd.leftDetail)\"}}, {\"linkId\": \"7\",\"text\": \"Breastfeeding right breast\",\"answer\": {\"valueString\": \"\(bfd.rightDetail)\"}}]}}"
            
            
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
        }
    }

    @IBOutlet weak var timer: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
//stop watch component, set start time when start button is pressed
    @IBAction func startButtonAction(_ sender: Any) {
        if !timer2.isValid {
            started = true
            let aSelector : Selector = #selector(FirstViewController.updateTime)
            timer2 = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
            startTimeGlobal = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let startTimeString = formatter.string(from: startTimeGlobal)
            startTimeDetail.text = startTimeString
            bfd.sStart = startTimeString
            canSubmit = false
            submitButtonOutlet.isEnabled = false
        }
    }
    
//stop watch component, set stop time when start button is pressed
    @IBAction func stopButtonAction(_ sender: Any) {
        if started {
            started = false
            timer2.invalidate()
            timer2 == nil
            
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            
            // let startTimeString = formatter.string(from: startTimeGlobal)
            stopTimeGlobal = Date()
            let stopTimeString = formatter.string(from: stopTimeGlobal)
            
            //startTimeDetail.text = startTimeString
            stopTimeDetail.text = stopTimeString
            bfd.sStop = stopTimeString
            let interval = stopTimeGlobal.timeIntervalSince(startTimeGlobal)
            let minutes = UInt8(interval / 60.0)
            let durationString = String(format: "%02d", minutes)
            durationGlobal = durationString
            durationDetail.text = durationString + " minute(s)"
            bfd.sDuration = durationString + " minute(s)"
            //let seconds = calendar.component(.second, from: date)
            //print("hours = \(hour):\(minutes):\(seconds)")
            canSubmit = true
            submitButtonOutlet.isEnabled = true
        }
    }

//stop watch component, update the stop watch timer
    func updateTime() {
        
        var currentTime = NSDate.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        //   let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        // let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        // timer.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        timer.text = "\(strMinutes):\(strSeconds)"
        
        
    }
    

    
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    
//alert after submit button is pressed
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
    
    
    @IBOutlet weak var poopButton: CheckBox!
    @IBOutlet weak var peeButton: CheckBox!
    
    @IBAction func poopAction(_ sender: Any) {
        
        poopButton.isChecked = !poopButton.isChecked
        
    }
    
    @IBAction func peeAction(_ sender: Any) {
        peeButton.isChecked = !peeButton.isChecked
    }
    
    @IBOutlet weak var peeAction: CheckBox!
    func checkP() -> String {
        if(poopButton.isChecked) && (peeButton.isChecked){
            bfd.pDetail = "poop and pee"
        }
        else if (poopButton.isChecked){
            bfd.pDetail = "poop"
        }
        else if(peeButton.isChecked){
            bfd.pDetail = "pee"
        }else{
            bfd.pDetail = "n/a"
        }
        return bfd.pDetail
    }
    
    @IBOutlet weak var leftFirstOutlet: CheckBox!
    @IBOutlet weak var leftSecondOutlet: CheckBox!
    
    @IBAction func leftFirstAction(_ sender: Any) {
        leftFirstOutlet.isChecked = !leftFirstOutlet.isChecked
      
        leftSecondOutlet.isChecked = !leftFirstOutlet.isChecked
        rightFirstOutlet.isChecked = false
        }
    @IBAction func leftSecondAction(_ sender: Any) {
        leftSecondOutlet.isChecked = !leftSecondOutlet.isChecked
        leftFirstOutlet.isChecked = !leftSecondOutlet.isChecked
        rightSecondOutlet.isChecked = false
        
    }
    @IBOutlet weak var rightFirstOutlet: CheckBox!
    
    @IBOutlet weak var rightSecondOutlet: CheckBox!
    @IBAction func rightFirstAction(_ sender: Any) {
        
        rightFirstOutlet.isChecked = !rightFirstOutlet.isChecked
       
        rightSecondOutlet.isChecked = !rightFirstOutlet.isChecked
        leftFirstOutlet.isChecked = false
        
    }
    @IBAction func rightSecondAction(_ sender: Any) {
        rightSecondOutlet.isChecked = !rightSecondOutlet.isChecked
        rightFirstOutlet.isChecked = !rightSecondOutlet.isChecked
        leftSecondOutlet.isChecked = false
        
    }
    
    func checkBFL () -> String {
        if leftFirstOutlet.isChecked {
            bfd.leftDetail = "1st"
        }else{
            bfd.leftDetail = "2nd"
        }
        return bfd.leftDetail
    }
    
    func checkBFR () -> String {
        if rightFirstOutlet.isChecked {
            bfd.rightDetail = "1st"
        }else{
            bfd.rightDetail = "2nd"
        }
        
        return bfd.rightDetail
    }
    
    @IBOutlet weak var dateDetail: UILabel!
    
    @IBOutlet weak var startTimeDetail: UILabel!
    
    @IBOutlet weak var stopTimeDetail: UILabel!
    
    @IBOutlet weak var testButton: UIButton!
    
    @IBOutlet weak var durationDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let date = Date()
        let formatter = DateFormatter()
        // Give the format you want to the formatter:
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        let result = formatter.string(from: date)
        //  Set your label:
        
        dateDetail.text = result
        bfd.sDate = result
        submitButtonOutlet.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
