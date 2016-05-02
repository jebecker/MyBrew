//
//  RecommendationTableViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 4/12/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class RecommendationTableViewController: UITableViewController {
    
    //add properties for the cell
    let kCloseCellHeight: CGFloat = 140
    let kOpenCellHeight: CGFloat = 360
    
    var kRowsCount = 10
    
    var cellHeights = [CGFloat]()
    
    var dataCollector = DataCollector()
    
    var rating : Int?
    
    var beerToAdd : Int?
    
    var dailyBeerTagNum = 500
    
    //set property observer for whenever the beers array is set
    var recommendBeers : [Beer]? {
        didSet {
            self.kRowsCount = recommendBeers!.count
            self.createCellHeightsArray()
            self.tableView.reloadData()
        }
    }
    
    var dailyBeer : [Beer]? {
        didSet {
            self.kRowsCount = dailyBeer!.count
            self.createCellHeightsArray()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addBeerButton(sender: AnyObject) {
        
        //grab the beer id before adding a rating
        self.beerToAdd = sender.tag
        performSegueWithIdentifier("recommendToRateBeer", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDailyBeer()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func createCellHeightsArray() {
        self.cellHeights = Array(count: self.kRowsCount, repeatedValue: self.kCloseCellHeight)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.getRecommendedBeers()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

// MARK: - Table view delegate and data source methods

extension RecommendationTableViewController {
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create the view
        let header = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 24.0))
        header.backgroundColor = UIColor.darkGrayColor()
        
        // Create the Label
        let label = UILabel(frame: CGRect(x: 15.0, y: 1.0, width: self.view.frame.width - 15.0, height: 24.0))
        label.textColor = UIColor.whiteColor()
        label.text = section == 0 ? "Daily Pick!" : "Recommended Beers!"
        
        
        header.addSubview(label)
        
        return header
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0) {
            if let _ = self.dailyBeer {
                return 1
            }
            
            return 0
        }
        else {
            //number of beers returned
            if let numOfRecommendaiton = recommendBeers?.count {
                return numOfRecommendaiton
            }
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCellWithIdentifier("RecommendationsBeerCell") as? MyBeerCell else {
            print("cell failed")
            return UITableViewCell()
        }
        
        let beer : Beer
        
        //check the section of the table view to determine what to populate the cell with
        if indexPath.section == 0 {
            beer = (dailyBeer?[0])!
            cell.addButton.tag = dailyBeerTagNum
            cell.addButtonD.tag = dailyBeerTagNum
        }
        else {
            beer = (recommendBeers?[indexPath.row])!
            cell.addButton.tag = indexPath.row
            cell.addButtonD.tag = indexPath.row
        }
        
        //populate cell data
        cell.ibuNumberLabel.text = "\(beer.beerIBU)"
        cell.abvPercentageLabel.text = beer.beerABV.convertToTenthsDecimal() + "%"
        cell.breweryLabel.text = beer.breweryName ?? "420 Blaze It"
        cell.beerStyleLabel.text = beer.beerStyle ?? "Hipster Style"
        cell.beerNameLabel.text = beer.beerName
        
        //set detail outlets
        cell.ibuNumberLabelD.text = "\(beer.beerIBU)"
        cell.abvPercentageLabelD.text = beer.beerABV.convertToTenthsDecimal() + "%"
        cell.breweryNameD.text = beer.breweryName ?? "420 Blaze It"
        cell.beerStyleD.text = beer.beerStyle ?? "Hipster Style"
        cell.beerNameD.text = beer.beerName
        cell.breweryLocationLabel.text = beer.breweryLocation
        cell.beerDescriptionLabel.text = beer.beerDescription
        
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

//MARK: Code to handle api calls
extension RecommendationTableViewController {
    
    //func to grab the daily beer
    func getDailyBeer() {
        
        let headerString = "Bearer \(DataCollector.token!)"
        
        dataCollector.grabDailyBeer(headerString) { dailyBeer, errorString in
            
            if let unwrappedErrorString = errorString {
                print(unwrappedErrorString)
            }
            else {
                
                //grab the daily beer and then get the recommended beers
                self.dailyBeer = dailyBeer
                self.getRecommendedBeers()
            }
        }
    }
    
    //func to grab the recommended beers
    func getRecommendedBeers() {
        
        let headerString = "Bearer \(DataCollector.token!)"
        
        dataCollector.recommendedBeersListRequest(headerString) { recommendBeers, errorString in
            
            if let unwrappedErrorString = errorString {
                print(unwrappedErrorString)
            }
            else {
                
                //grab the recommended beers
                self.recommendBeers = recommendBeers
            }
        }
    }
    
    //func to make the api call to add the beer to the cellear
    func addBeerToCellar(withRating rating: Int) {
        
        //declare variables
        let paramString : String
        let headerString : String
        
        //determine if the daily beer was clicked to be added, if not, grab beer from the recommend beers array
        if self.beerToAdd == dailyBeerTagNum {
            guard let beer = self.dailyBeer?[0] else {
                print("could not find daily beer at index 0")
                return
            }
            
            //set parameter and header string
            paramString = "beer=\(beer.beerID)&rating=\(rating)"
            headerString = "Bearer \(DataCollector.token!)"
        }
        else {
            
            //grab the index of the beer to add and set it to a beer object
            guard let beerToAdd = self.beerToAdd, beer = self.recommendBeers?[beerToAdd] else {
                // TODO: handle this
                print("beer not found at index")
                return
            }
            
            //set parameter and header string
            paramString = "beer=\(beer.beerID)&rating=\(rating)"
            headerString = "Bearer \(DataCollector.token!)"
        }
        

        //call the addBeerToCellar method from the data collector to add the beer the users cellar
        dataCollector.addBeerToCellar(paramString, headerString: headerString, completionHandler: { (status, errorString) -> Void in
            
                if let unwrappedErrorString = errorString {
                    //alert the user that they couldnt add the beer
                    print(unwrappedErrorString)
                    let alertController = UIAlertController(title: "Add Beer Failed", message: unwrappedErrorString, preferredStyle:    UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                
                    self.presentViewController(alertController, animated: true, completion: nil)
                
                }
                else {
                    //remove beer from quiz reslts list
                    self.recommendBeers?.removeAtIndex(self.beerToAdd!)
                }
            }
        )
    }
    
    //MARK: TableViewController unwind segue to return back to the add beer page
    
    @IBAction func unwindBackToAddBeer(segue: UIStoryboardSegue) {
        //make sure the segue has the correct identifier
        if segue.identifier == "unwindFromRating" {
            if let sourceVC = segue.sourceViewController as? RateViewController {
                self.addBeerToCellar(withRating: sourceVC.rating ?? 3)
            }
        }
    }
}
































