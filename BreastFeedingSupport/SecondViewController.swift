//
//  SecondViewController.swift
//  BreastFeedingSupport
//
//  Created by CHONG W GUO on 3/15/17.
//  Copyright © 2017 CHONG W GUO. All rights reserved.
//
// the class for data log tab

import UIKit

class SecondViewController: UITableViewController {
    let patientID = "Patient/171428" //patient Marla
    var bfData: [BreastfeedingData] = [] {
        didSet {
          tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        
        let when = DispatchTime.now() + 0.5 //delay reloading data
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl?.addTarget(self, action: #selector(SecondViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged) // refresh control
        
    }
    //refresh control
    func handleRefresh(_ refreshControl: UIRefreshControl) {
 
        updateTable()

        refreshControl.endRefreshing()
    }
    
    //update table
    func updateTable(){
        bfData = []
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://secure-api.hspconsortium.org/FHIRPit/open/QuestionnaireResponse?source=\(patientID)")! //restful api GET the resource with specific patientID
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    // pull data from fhir and load into bfData
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        
                        var count = 0
                        count = json["total"] as! Int
                        
                        if(count>0){
                           
                            // parse json data from fhir into BreastfeedingData
                            var responseEntry : NSArray = json["entry"] as! NSArray
                            for response in responseEntry {
                                var bd : BreastfeedingData = BreastfeedingData()
                                var answerArray : [String] = []
                                let d2 = (response as! NSDictionary)["resource"] as! NSDictionary
                                bd.patientID = ((d2["author"]) as! NSDictionary)["reference"] as! String
                                let type = d2["group"] as! NSDictionary
                                if (type["title"] as! String != "Patient Generated Breastfeeding Data "){
                                    continue
                                }
                                let d3 = (d2["group"] as! NSDictionary)["question"] as! NSArray
                               
                                
                                for answer in d3{
                    
                                    let value = (answer as! NSDictionary)["answer"] as! NSArray
                                    let s1 = value[0] as! NSDictionary
                                    if(nil == s1["valueString"]){
                                        answerArray.append(s1["valueDate"] as! String)
                                    }else{
                                        answerArray.append(s1["valueString"] as! String)
                                    }
                                }
                                bd.sDate = answerArray[0]
                                bd.sStart = answerArray[1]
                                bd.sStop = answerArray[2]
                                bd.sDuration = answerArray[3]
                                bd.pDetail = answerArray[4]
                                bd.leftDetail = answerArray[5]
                                bd.rightDetail = answerArray[6]
                                self.bfData.append(bd)
                            }
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return bfData.count
    }
    
    // generating log table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "logTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! logTableCell
        cell.dataLabel?.text = self.bfData[indexPath.row].sDate
        cell.startLabel?.text = self.bfData[indexPath.row].sStart
        cell.stopLabel?.text = self.bfData[indexPath.row].sStop
        cell.durationLabel?.text = self.bfData[indexPath.row].sDuration
        cell.leftLabel?.text = self.bfData[indexPath.row].leftDetail
        cell.rightLabel?.text = self.bfData[indexPath.row].rightDetail
        cell.diaperLabel?.text = self.bfData[indexPath.row].pDetail
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    

    
    
    
}

