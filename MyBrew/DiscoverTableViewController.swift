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
        var trueResponses: String = ""
        var z = 0
        var y = 0
        for i in 0...responses.count {
            switch i {
            case 0..<10 :
                if responses[i] == true {
                    trueResponses += "{\"key\": \"keywords\", \"value\": \"\(questions[0][i - 10*0])\", \"type\": \"text\", \"enabled\": true},\n"
                    //print(trueResponses)
                }
                
            case 10..<20 :
                 if responses[i] == true {
                    trueResponses += "{\"key\": \"fruits[\(z)]\", \"value\": \"\(questions[1][i - 10])\", \"type\": \"text\", \"enabled\": true},\n"
                 z += 1
                 
                 }
            case 20..<30 :
                if responses[i] == true {
                    trueResponses += "{\"key\": \"aroma\", \"value\": \"1\", \"type\": \"text\", \"enabled\": true},\n"
                }
            case 30..<40 :
                    if responses[i] == true {
                        trueResponses += "{\"key\": \"flavors[\(y)]\", \"value\": \"\(questions[3][i - 30])\", \"type\": \"text\", \"enabled\": true},\n"
                        y += 1
                }
                
            case 40..<50 :
                if responses[i] == true {
                    trueResponses += "{\"key\": \"bitterness\", \"value\": \"\(i - 40)\", \"type\": \"text\", \"enabled\": true},\n"
                }
            case 50..<60 :
                if responses[i] == true {
                    trueResponses += "{\"key\": \"color\", \"value\": \"\(i-50)\", \"type\": \"text\", \"enabled\": true},\n"
                }
            case 60..<70 :
                if responses[i] == true {
                    trueResponses += "{\"key\": \"maltiness\", \"value\": \"\(i-60)\", \"type\": \"text\", \"enabled\": true},\n"
                }
            
            default:
                debugPrint("none")
            }
        }
        
        print(trueResponses)
        
        
        
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
