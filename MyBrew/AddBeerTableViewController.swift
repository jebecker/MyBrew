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
    @IBAction func addBeer(_ sender: AnyObject) {
       
        //grab the beer id before adding a rating
        self.beerToAdd = sender.tag
        performSegue(withIdentifier: "rateBeerSegue", sender: nil)
    }

    
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        
        print("user canceled adding beer")
        self.dismiss(animated: true, completion: nil)
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
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.globalBeersList()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
        self.cellHeights = Array(repeating: self.kCloseCellHeight, count: self.kRowsCount)
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "ALL") {
        
        filterdBeers = (globalBeers?.filter { beer in
            return beer.beerName.lowercased().contains(searchText.lowercased())
            })!
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchController.isActive && searchController.searchBar.text != "" {
            return filterdBeers.count
        }
        
        return globalBeers?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddBeerCell") as? MyBeerCell else {
            return UITableViewCell()
        }
        
        let beer : Beer
        
        if searchController.isActive && searchController.searchBar.text != "" {
            beer = filterdBeers[(indexPath as NSIndexPath).row]
        }
        else {
            beer = (globalBeers?[(indexPath as NSIndexPath).row])!
        }
        
        //populate cell data
        cell.ibuNumberLabel.text = "\(beer.beerIBU)"
        cell.abvPercentageLabel.text = beer.beerABV.convertToTenthsDecimal() + "%"
        cell.breweryLabel.text = beer.breweryName ?? "420 Blaze It"
        cell.beerStyleLabel.text = beer.beerStyle ?? "Hipster Style"
        cell.beerNameLabel.text = beer.beerName
        cell.addButton.tag = (indexPath as NSIndexPath).row
        
        //set detail outlets
        cell.aIbuNumberD.text = "\(beer.beerIBU)"
        cell.aAbvPercentageD.text = beer.beerABV.convertToTenthsDecimal() + "%"
        cell.aBreweryNameD.text = beer.breweryName ?? "420 Blaze It"
        cell.aBeerStyleD.text = beer.beerStyle ?? "Hipster Style"
        cell.aBeerNameD.text = beer.beerName
        cell.abreweryLocationD.text = beer.breweryLocation
        cell.aBeerDescriptionD.text = beer.beerDescription
        cell.addButtonD.tag = (indexPath as NSIndexPath).row
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeights[(indexPath as NSIndexPath).row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        var duration = 0.0
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
            cellHeights[(indexPath as NSIndexPath).row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
    }
    
    //func to make the api call to add the beer to the cellear
    func addBeerToCellar(withRating rating: Int) {
        
        let beerToAdd = self.beerToAdd!
        var beer : Beer
        var flag : Int
        
        //check to see if the search controller is active, if it is, use the filtered beers array to add the beer
        if searchController.isActive && searchController.searchBar.text != "" {
            beer = self.filterdBeers[beerToAdd]
            flag = 1
        }
        else {
            beer = (self.globalBeers?[beerToAdd])!
            flag = 0
        }
        
        //decalre parameter string
        let paramString = "beer=\(beer.beerID)&rating=\(rating)"
        let headerString = "Bearer \(DataCollector.token!)"
        
        //call the addBeerToCellar method from the data collector to add the beer the users cellar
        dataCollector.addBeerToCellar(paramString, headerString: headerString, completionHandler: { (status, errorString) -> Void in
            
                if let unwrappedErrorString = errorString {
                    //alert the user that they couldnt add the beer
                    print(unwrappedErrorString)
                    let alertController = UIAlertController(title: "Add Beer Failed", message: unwrappedErrorString, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else {
                    
                    if flag == 1 {
                        self.filterdBeers.remove(at: beerToAdd)
                        self.tableView.reloadData()
                    }
                    else {
                        
                        //remove beer from global beers array
                        self.globalBeers?.remove(at: beerToAdd)
                    }
                }
            }
        )
    }
}

//MARK: TableViewController unwind segue to return back to the add beer page

extension AddBeerTableViewController {
    
    @IBAction func unwindBackToAddBeer(_ segue: UIStoryboardSegue) {
        //make sure the segue has the correct identifier
        if segue.identifier == "unwindFromRating" {
            if let sourceVC = segue.source as? RateViewController {
                self.addBeerToCellar(withRating: sourceVC.rating ?? 3)
            }
        }
        
    }
}

extension AddBeerTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

}
