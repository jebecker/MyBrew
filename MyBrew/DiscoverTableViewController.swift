//
//  DiscoverTableViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 2/21/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class DiscoverTableViewController: UITableViewController {

    //add properties for the cell
    let kCloseCellHeight: CGFloat = 140
    //dynamically set the height of the open Questions cell so it expands the whole scrren
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    let kRowsCount = 10
    
    var cellHeights = [CGFloat]()
    
    //create flag to determine which card to display
    var isQuestionsCard = true
    
    //create variable to hold number of results returned
    var numOfResults = 6
    
    var responseString: String = ""
    var dataCollector = DataCollector()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.setNavigationBarHidden(true, animated: false)

        createCellHeightsArray()
    }
    
    
    func createCellHeightsArray() {
        self.cellHeights = Array(count: self.kRowsCount, repeatedValue: self.kCloseCellHeight)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(isQuestionsCard)
        {
            return 1
        }
        
        return numOfResults
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = (screenSize.height - 64)
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if(isQuestionsCard)
        {
            if let questionsCell = tableView.dequeueReusableCellWithIdentifier("QuestionsCell", forIndexPath: indexPath) as? QuestionsCell {
                
                questionsCell.questionsAnswersTableView.delegate = questionsCell
                questionsCell.questionsAnswersTableView.dataSource = questionsCell
                
                return questionsCell
            }
        }
        else
        {
            if let resultsCell = tableView.dequeueReusableCellWithIdentifier("ResultsCell", forIndexPath: indexPath) as? ResultsCell {
                
                return resultsCell
            }
        }
        
        
        return UITableViewCell()
    }

    func prepareForDataCollect(responses: [Bool], questions: [[String]])
    {
        
       
        var z = 0
        var y = 0
        for i in 0...responses.count-1 {
            if responses[i] == true {

                switch i {
                case 0..<10 :
                        self.responseString += "keywords=\(questions[0][i])&"
                case 10..<20 :
                        //self.fruits![z] = questions[1][i - 10]
                        self.responseString += "fruits[\(z)]=\(questions[1][i - 10])&"
                        z += 1
                    
                case 20..<30 :
                        self.responseString += "aroma=\(i - 20)&"
                
                case 30..<40 :
                       self.responseString += "flavors[\(y)]=\(questions[3][i - 30])&"
                            y += 1
                case 40..<50 :
                        self.responseString += "bitterness=\(i - 40)&"
                case 50..<60 :
                        self.responseString += "color=\(i - 50)&"
                    
                case 60..<70 :
                       self.responseString += "maltiness=\(i - 60)"
                
                default:
                    debugPrint("none")
                }
            }
        }
        print(responseString)
        
        self.beerQuiz()
        
        
        
    }
    
    func beerQuiz() {
        
        let paramString = self.responseString
        let headerString = "Bearer \(DataCollector.token)"
        
        //dataCollector.beer
    }

}
