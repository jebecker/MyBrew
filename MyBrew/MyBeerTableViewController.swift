//
//  MyBeerTableViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 2/21/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class MyBeerTableViewController: UITableViewController {
    
    //add property for search bar
    let searchController = UISearchController(searchResultsController: nil)
    
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
    
    var filterdBeers = [Beer]()
    
    @IBAction func unwindBackToMyBeer(_ segue: UIStoryboardSegue) {
        //make sure the segue has the correct identifier
        if segue.identifier == "unwindFromAddBeer" {
            if let _ = segue.source as? AddBeerTableViewController {
                print("unwinding back to my beer")
            }
        }
    }
    
    @IBAction func deleteBeerButton(_ sender: AnyObject) {
        
        //confirm with user
        let alertController = UIAlertController(title: "Confirm Delete", message: "Are you sure want to delete?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self](alert) in
             self.deleteBeerFromCellar(atIndex: sender.tag)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
       
    }

    //IBAction func to add a beer
    @IBAction func addBeerButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddBeerSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.init(red: 0.302, green: 0.58, blue: 0.678, alpha: 1)
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //call the beerCellar function
        beerCellar()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.beerCellar()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //reload the users data
        beerCellar()
    }
    
    func createCellHeightsArray() {
        self.cellHeights = Array(repeating: self.kCloseCellHeight, count: self.kRowsCount)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchController.isActive && searchController.searchBar.text != "" {
            return filterdBeers.count
        }
        
        return myBeers?.count ?? 0
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "ALL") {
        
        filterdBeers = (myBeers?.filter { beer in
            return beer.beerName.lowercased().contains(searchText.lowercased())
            })!
        
        tableView.reloadData()
    }
    

    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as! MyBeerCell
        
        let beer : Beer
        
        if searchController.isActive && searchController.searchBar.text != "" {
            beer = filterdBeers[(indexPath as NSIndexPath).row]
        }
        else {
            beer = (myBeers?[(indexPath as NSIndexPath).row])!
        }

        cell.ibuNumberLabel.text = "\(beer.beerIBU)"
        cell.abvPercentageLabel.text = beer.beerABV.convertToTenthsDecimal() + "%"
        cell.breweryLabel.text = beer.breweryName ?? "420 Blaze It"
        cell.beerStyleLabel.text = beer.beerStyle ?? "Hipster Style"
        cell.beerNameLabel.text = beer.beerName
        cell.deleteButton.tag = (indexPath as NSIndexPath).row
        
        //set detail outlets
        cell.ibuNumberLabelD.text = "\(beer.beerIBU)"
        cell.abvPercentageLabelD.text = beer.beerABV.convertToTenthsDecimal() + "%"
        cell.breweryNameD.text = beer.breweryName ?? "420 Blaze It"
        cell.beerStyleD.text = beer.beerStyle ?? "Hipster Style"
        cell.beerNameD.text = beer.beerName
        cell.breweryLocationLabel.text = beer.breweryLocation
        cell.beerDescriptionLabel.text = beer.beerDescription
        cell.deleteButtonD.tag = (indexPath as NSIndexPath).row
        
        
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
}

//code to hadle api calls
extension MyBeerTableViewController {
    
    //function to get the beer cellar of user from our API and configure the cell
    func beerCellar() {
        let beerCellarUrlString = "https://api-mybrew.rhcloud.com/api/cellar"
        //let token = dataCollector.token
        let paramString = "Bearer \(DataCollector.token!)"
        
        dataCollector.beerCellarRequest(beerCellarUrlString, paramString: paramString) { beers, errorString in
            if let unwrappedErrorString = errorString {
                print(unwrappedErrorString)
            }
            else {
                //save the beer data returned
                self.myBeers = beers
            }
        }
    }
    
    //function to delete the specific beer from a users cellar
    func deleteBeerFromCellar(atIndex index: Int) {
       
        var flag : Int
        var beer : Beer
        
        if searchController.isActive && searchController.searchBar.text != "" {
            beer = self.filterdBeers.remove(at: index)
            
            flag = 1
        }
        else {
            beer = (self.myBeers?.remove(at: index))!
            flag = 0
        }
        
        let paramString = "beer=\(beer.beerID)"
        let headerString = "Bearer \(DataCollector.token!)"
        
        dataCollector.deleteBeerFromCellar(paramString, headerString: headerString) { status, errorString in
            if let unwrappedErrorString = errorString {
                print(unwrappedErrorString)
                
                //alert user that beer couldnt be removed
                let alertController = UIAlertController(title: "Oops!", message: "We couldn't delete your beer", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                
                if flag == 1 {
                    self.filterdBeers.append(beer)
                    self.tableView.reloadData()
                }
                else {
                    self.myBeers?.append(beer)
                    self.tableView.reloadData()
                }
                
            }
            else {
                print("delete succesfful")
            }
        }
        
        //reload table
        self.tableView.reloadData()
    }
}


extension MyBeerTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
