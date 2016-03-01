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
    let kCloseCellHeight: CGFloat = 185
    let kOpenCellHeight: CGFloat = 330
    
    let kRowsCount = 3
    
    var cellHeights = [CGFloat]()
    
    //create flag to determine which card to display
    var isQuestionsCard = true
    
    //create variable to hold number of results returned
    var numOfResults = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createCellHeightsArray()
    }
    
    
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
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
