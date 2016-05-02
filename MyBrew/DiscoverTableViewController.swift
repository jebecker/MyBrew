//
//  DiscoverTableViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 2/21/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit


enum QuizState {
    case Questions, Results
}


class DiscoverTableViewController: UITableViewController {

    
    //add properties for the cell
    let kCloseCellHeight: CGFloat = 140
    var kOpenCellHeight: CGFloat {
        get {
            return self.quizState == .Questions ? 520 : 360
        }
    }
    //dynamically set the height of the open Questions cell so it expands the whole scrren
    var openQuestionCellHeight: CGRect = UIScreen.mainScreen().bounds
    
    var kRowsCount = 1
    
    var cellHeights = [CGFloat]()
    
    //create variable to hold number of results returned
    var numOfResults = 6
    
    var dataCollector = DataCollector()
    
    var quizBeers: [Beer]?
    
    var beerToAdd : Int?
   
    var quizState : QuizState = .Questions {
        didSet {
            if quizState == .Results {
                
                kRowsCount = quizBeers!.count
                self.createCellHeightsArray()
                self.createRetakeButton()
                self.tableView.reloadData()
            }
            else {
                
                self.quizBeers?.removeAll()
                self.removeBarButtonItem()
                kRowsCount = 1
                self.createCellHeightsArray()
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addBeerQuizBeerButton(sender: AnyObject) {
        
        self.beerToAdd = sender.tag
        performSegueWithIdentifier("beerQuizToRateBeerSegue", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCellHeightsArray()
    }
    
    
    func createCellHeightsArray() {
        self.cellHeights = Array(count: self.kRowsCount, repeatedValue: self.kCloseCellHeight)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.quizState == .Questions ? 1 : self.quizBeers!.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell
        

            var duration = 0.0
            if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
                cellHeights[indexPath.row] = kOpenCellHeight //(screenSize.height - 64)
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

        if self.quizState == .Questions {
            guard let questionsCell = tableView.dequeueReusableCellWithIdentifier("QuestionsCell", forIndexPath: indexPath) as? QuestionsCell else {
                
                return UITableViewCell()
                
            }
            
            questionsCell.delegate = self
            
            return questionsCell

        }
        else {
            
            guard let cell = tableView.dequeueReusableCellWithIdentifier("BeerQuizResultsCell", forIndexPath: indexPath) as? MyBeerCell else {
                return UITableViewCell()
            }
            
            guard let beer = quizBeers?[indexPath.row] else {
                
                return UITableViewCell()
            }
            
            cell.ibuNumberLabel.text = "\(beer.beerIBU)"
            cell.abvPercentageLabel.text = beer.beerABV.convertToTenthsDecimal() + "%"
            cell.breweryLabel.text = beer.breweryName ?? "420 Blaze It"
            cell.beerStyleLabel.text = beer.beerStyle ?? "Hipster Style"
            cell.beerNameLabel.text = beer.beerName
            cell.addButton.tag = indexPath.row
            
            //set detail outlets
            cell.ibuNumberLabelD.text = "\(beer.beerIBU)"
            cell.abvPercentageLabelD.text = beer.beerABV.convertToTenthsDecimal() + "%"
            cell.breweryNameD.text = beer.breweryName ?? "420 Blaze It"
            cell.beerStyleD.text = beer.beerStyle ?? "Hipster Style"
            cell.beerNameD.text = beer.beerName
            cell.breweryLocationLabel.text = beer.breweryLocation
            cell.beerDescriptionLabel.text = beer.beerDescription
            cell.addButtonD.tag = indexPath.row
            
            
            return cell
            
        }
    }
}

//MARK: Extra methods

extension DiscoverTableViewController {

    @IBAction func unwindBackToAddBeer(segue: UIStoryboardSegue) {
        //make sure the segue has the correct identifier
        if segue.identifier == "unwindFromRating" {
            if let sourceVC = segue.sourceViewController as? RateViewController {
                self.addBeerToCellar(withRating: sourceVC.rating ?? 3)
            }
        }
    }
    
    func prepareForDataCollect(responses: Set<NSIndexPath>, answers: [[String]]) {
        
        var responseString: String = ""
        
        // Convert the set into an array and sort them by section index
        let responseArray = Array(responses).sort({ $0.section < $1.section })
        
        var numberOfFruits = 0
        var numberOfFlavors = 0
        
        for indexPath in responseArray {
            switch indexPath.section {
            case 0 :
                responseString += "keywords=\(answers[indexPath.section][indexPath.row])&"
                break
            case 1 :
                responseString += "fruits[\(numberOfFruits)]=\(answers[indexPath.section][indexPath.row])&"
                numberOfFruits += 1
                break
            case 2 :
                let response = indexPath.row == 0 ? 1 : 0
                responseString += "aroma=\(response)&"
                break
            case 3 :
                responseString += "flavors[\(numberOfFlavors)]=\(answers[indexPath.section][indexPath.row])&"
                numberOfFlavors += 1
                break
            case 4 :
                let response = indexPath.row == 3 ? 0 : indexPath.row
                responseString += "bitterness=\(response)&"
                break
            case 5 :
                let response = indexPath.row == 3 ? 0 : indexPath.row
                responseString += "color=\(response)&"
                break
            case 6 :
                let response = indexPath.row == 1 ? 0 : indexPath.row == 0 ? 1 : indexPath.row - 2
                responseString += "maltiness=\(response)"
                break
            default :
                debugPrint("none")
            }
        }
        
        print(responseString)
        
        self.beerQuiz(responseString)
    }
    
    func beerQuiz(parameterString: String) {
        
        let paramString = parameterString
        let headerString = "Bearer \(DataCollector.token!)"
        
        dataCollector.beerQuizRequest(withHeaderString: headerString, withParamString: paramString) { quizBeers, errorString  in
            
            if let unwrappedErrorString = errorString {
                print(unwrappedErrorString)
                
                let alertController = UIAlertController(title: "Sorry!", message: "We could not get any results based on your answers!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.quizBeers?.removeAll()
                    self.quizBeers = quizBeers!
                    self.quizState = .Results
                })
            }
        }
    }
    
    //func to make the api call to add the beer to the cellear
    func addBeerToCellar(withRating rating: Int) {
        
        //grab the index of the beer to add and set it to a beer object
        guard let beerToAdd = self.beerToAdd, beer = self.quizBeers?[beerToAdd] else {
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
                
                //remove beer from quiz reslts list
                self.quizBeers?.removeAtIndex(beerToAdd)
                self.tableView.reloadData()
            }
        })
    }
    
    
    func createRetakeButton() {
        
        //create bar button item
        let barButton = UIBarButtonItem(title: "Retake", style: .Plain, target: self, action: #selector(resetQuiz))
        
        //configure it
        barButton.tintColor = UIColor.whiteColor()
        
        //add button to nav bar
        self.navigationItem.setLeftBarButtonItem(barButton, animated: true)
        
    }
    
    func resetQuiz() {
        self.quizState = .Questions
    }
    
    
    func removeBarButtonItem() {
        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
    }
    
    
    
}

extension DiscoverTableViewController : QuestionsCellDelegate {
    
    func questionsCell(questionsCell: QuestionsCell, didSubmitResponses responses: Set<NSIndexPath>, forAnswers answers: [[String]]) {
        
        self.prepareForDataCollect(responses, answers: answers)
        
    }
    
    func displayAlert(title: String, message: String, actionTitle: String) {
        //alert user that beer couldnt be removed
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    
    
}




















