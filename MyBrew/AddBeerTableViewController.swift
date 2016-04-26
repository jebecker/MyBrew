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
    
    var rating : Int?
    
    var beerToAdd : Int?
    
    //set property observer for whenever the beers array is set
  
    var globalBeers : [Beer]? {
        didSet {
            kRowsCount = globalBeers!.count
            self.createCellHeightsArray()
            self.tableView.reloadData()
        }
    }
    
    var filterdBeers = [Beer]()
    
    //addBeer action 
    @IBAction func addBeer(sender: AnyObject) {
       
        //grab the beer id before adding a rating
        self.beerToAdd = sender.tag
        performSegueWithIdentifier("rateBeerSegue", sender: nil)
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
        let paramString = "Bearer \(DataCollector.token!)"
        
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
    
    
    func filterContentForSearchText(searchText: String, scope: String = "ALL") {
        
        filterdBeers = (globalBeers?.filter { beer in
            return beer.beerName.lowercaseString.containsString(searchText.lowercaseString)
            })!
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchController.active && searchController.searchBar.text != "" {
            return filterdBeers.count
        }
        
        return globalBeers?.count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCellWithIdentifier("AddBeerCell") as? MyBeerCell else {
            return UITableViewCell()
        }
        
        let beer : Beer
        
        if searchController.active && searchController.searchBar.text != "" {
            beer = filterdBeers[indexPath.row]
        }
        else {
            beer = (globalBeers?[indexPath.row])!
        }
        
        //populate cell data
        cell.ibuNumberLabel.text = "\(beer.beerIBU)"
        cell.abvPercentageLabel.text = beer.beerABV.convertToTenthsDecimal() + "%"
        cell.breweryLabel.text = beer.breweryName ?? "420 Blaze It"
        cell.beerStyleLabel.text = beer.beerStyle ?? "Hipster Style"
        cell.beerNameLabel.text = beer.beerName
        cell.addButton.tag = indexPath.row
        
        //set detail outlets
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
    
    //func to make the api call to add the beer to the cellear
    func addBeerToCellar(withRating rating: Int) {
        
        //grab the index of the beer to add and set it to a beer object
        guard let beerToAdd = self.beerToAdd, beer = self.globalBeers?[beerToAdd] else {
            // TODO: handle this
            print("beer not found at index")
            return
        }
        
        //decalre parameter string
        let paramString = "beer=\(beer.beerID)&rating=\(rating)"
        let headerString = "Bearer \(DataCollector.token!)"
        
        //call the addBeerToCellar method from the data collector to add the beer the users cellar
        dataCollector.addBeerToCellar(paramString, headerString: headerString, completionHandler: { (status, errorString) -> Void in
            
                if let unwrappedErrorString = errorString {
                    //alert the user that they couldnt add the beer
                    print(unwrappedErrorString)
                    let alertController = UIAlertController(title: "Add Beer Failed", message: unwrappedErrorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                else {
                    //remove beer from global beers array
                    self.globalBeers?.removeAtIndex(beerToAdd)
                }
            }
        )
    }
    
    
}

//MARK: TableViewController unwind segue to return back to the add beer page

extension AddBeerTableViewController {
    
    @IBAction func unwindBackToAddBeer(segue: UIStoryboardSegue) {
        //make sure the segue has the correct identifier
        if segue.identifier == "unwindFromRating" {
            if let sourceVC = segue.sourceViewController as? RateViewController {
                self.addBeerToCellar(withRating: sourceVC.rating ?? 3)
            }
        }
        
    }
}

extension AddBeerTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

}
