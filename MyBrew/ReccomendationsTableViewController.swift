//
//  ReccomendationsTableViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 4/10/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class ReccomendationsTableViewController: UITableViewController {

    //add properties for the cell
    let kCloseCellHeight: CGFloat = 140
    let kOpenCellHeight: CGFloat = 360
    
    var kRowsCount = 10
    
    var cellHeights = [CGFloat]()
    
    var dataCollector = DataCollector()

    //set property observer for whenever the beers array is set
    var myBeers : [Beer]? {
        didSet {
            kRowsCount = myBeers!.count
            self.createCellHeightsArray()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    func createCellHeightsArray() {
        self.cellHeights = Array(count: self.kRowsCount, repeatedValue: self.kCloseCellHeight)
    }

}

// MARK: - Table view delegate and data source methods

extension ReccomendationsTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0) {
            return 1
        }
        else {
            //number of beers returned -1 ---- still need
            return 5
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ReccomendationsBeerCell", forIndexPath: indexPath) as? MyBeerCell else {
            print("cell failed")
            return UITableViewCell()
        }
        
        // TODO: Configure cell
        
        return cell
        
    }
    
    //allow the card to unfold
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
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

}