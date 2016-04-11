//
//  AddBeerTableViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 3/24/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class AddBeerTableViewController: UITableViewController {
    
    //add property for search bar
    let searchController = UISearchController(searchResultsController: nil)
    
    //add properties for the cell
    let kCloseCellHeight: CGFloat = 140
    let kOpenCellHeight: CGFloat = 360
    
    var kRowsCount = 10
    
    var cellHeights = [CGFloat]()
    
    var dataCollector = DataCollector()

    var status : String?

    
    //set property observer for whenever the beers array is set
  
    var globalBeers : [Beer]? {
        didSet {
            kRowsCount = globalBeers!.count
            self.createCellHeightsArray()
            self.tableView.reloadData()
        }
    }
    
    //addBeer action 
    @IBAction func addBeer(sender: AnyObject) {
        
        guard let beer = globalBeers?[sender.tag] else {
            return
        }
        
        /* 
        TODO:
        
        grab rating of beer from user
         
        END TODO 
        */
        
        //decalre parameter string
        let paramString = "beer=\(beer.beerID)&rating=3"
        let headerString = "Bearer \(DataCollector.token)"
        
        //call the addBeerToCellar method from the data collector to add the beer the users cellar
        dataCollector.addBeerToCellar(paramString, headerString: headerString, completionHandler: { (status, errorString) -> Void in
            
                if let unwrappedErrorString = errorString
                {
                    //alert the user that they couldnt add the beer
                    print(unwrappedErrorString)
                    let alertController = UIAlertController(title: "Add Beer Failed", message: unwrappedErrorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)

                }
                else
                {
                    //save the status and message returned
                    //self.status = status
                    
                    //alert the user upon success
                    let alertController = UIAlertController(title: "Add Beer Successful!", message: "Succesfully Added!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                        self.cancelButton(self)
                    })
                    
                    alertController.addAction(action)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            
            }
        
        )
        
    }

    
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        print("user canceled adding beer")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.init(red: 0.302, green: 0.58, blue: 0.678, alpha: 1)
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //call the beerCellar function
        globalBeersList()
        
    }
    
    //function to get the beer cellar of user from our API and configure the cell
    func globalBeersList()
    {
        let globalBeerListString = "https://api-mybrew.rhcloud.com/api/beers"
        //let token = dataCollector.token
        let paramString = "Bearer \(DataCollector.token)"
        
        dataCollector.globalBeersListRequest(globalBeerListString, paramString: paramString) { globalBeers, errorString in
            if let unwrappedErrorString = errorString
            {
                print(unwrappedErrorString)
            }
            else
            {
                //save the beer data returned
                self.globalBeers = globalBeers
            }
        }
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
        return globalBeers?.count ?? 0
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "ALL")
    {
        tableView.reloadData()
    }
    
    
    // MARK: Table View Data Source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCellWithIdentifier("AddBeerCell") as? MyBeerCell else {
            return UITableViewCell()
        }
        
        guard let beer = globalBeers?[indexPath.row] else{
            return cell
        }
        
        cell.ibuNumberLabel.text = "\(beer.beerIBU)"
        cell.abvPercentageLabel.text = beer.beerABV.convertToTenthsDecimal() + "%"
        cell.breweryLabel.text = beer.breweryName ?? "420 Blaze It"
        cell.beerStyleLabel.text = beer.beerStyle ?? "Hipster Style"
        cell.beerNameLabel.text = beer.beerName
        cell.addButton.tag = indexPath.row
        
        //set detail outlest
        cell.aIbuNumberD.text = "\(beer.beerIBU)"
        cell.aAbvPercentageD.text = beer.beerABV.convertToTenthsDecimal() + "%"
        cell.aBreweryNameD.text = beer.breweryName ?? "420 Blaze It"
        cell.aBeerStyleD.text = beer.beerStyle ?? "Hipster Style"
        cell.aBeerNameD.text = beer.beerName
        cell.abreweryLocationD.text = beer.breweryLocation
        cell.aBeerDescriptionD.text = beer.beerDescription
        cell.addButtonD.tag = indexPath.row
        
        
        return cell
    }
    
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


extension AddBeerTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

}
