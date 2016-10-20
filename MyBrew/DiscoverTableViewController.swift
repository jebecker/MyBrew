//
//  DiscoverTableViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 2/21/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit


enum QuizState {
    case questions, results
}


class DiscoverTableViewController: UITableViewController {

    
    //add properties for the cell
    let kCloseCellHeight: CGFloat = 140
    var kOpenCellHeight: CGFloat {
        get {
            return self.quizState == .questions ? 520 : 360
        }
    }
    //dynamically set the height of the open Questions cell so it expands the whole scrren
    var openQuestionCellHeight: CGRect = UIScreen.main.bounds
    
    var kRowsCount = 1
    
    var cellHeights = [CGFloat]()
    
    //create variable to hold number of results returned
    var numOfResults = 6
    
    var dataCollector = DataCollector()
    
    var quizBeers: [Beer]?
    
    var beerToAdd : Int?
   
    var quizState : QuizState = .questions {
        didSet {
            if quizState == .results {
                
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
    
    @IBAction func addBeerQuizBeerButton(_ sender: AnyObject) {
        
        self.beerToAdd = sender.tag
        performSegue(withIdentifier: "beerQuizToRateBeerSegue", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCellHeightsArray()
    }
    
    
    func createCellHeightsArray() {
        self.cellHeights = Array(repeating: self.kCloseCellHeight, count: self.kRowsCount)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.quizState == .questions ? 1 : self.quizBeers!.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeights[(indexPath as NSIndexPath).row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        

            var duration = 0.0
            if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
                cellHeights[(indexPath as NSIndexPath).row] = kOpenCellHeight //(screenSize.height - 64)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.quizState == .questions {
            guard let questionsCell = tableView.dequeueReusableCell(withIdentifier: "QuestionsCell", for: indexPath) as? QuestionsCell else {
                
                return UITableViewCell()
                
            }
            
            questionsCell.delegate = self
            
            return questionsCell

        }
        else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerQuizResultsCell", for: indexPath) as? MyBeerCell else {
                return UITableViewCell()
            }
            
            guard let beer = quizBeers?[(indexPath as NSIndexPath).row] else {
                
                return UITableViewCell()
            }
            
            cell.ibuNumberLabel.text = "\(beer.beerIBU)"
            cell.abvPercentageLabel.text = beer.beerABV.convertToTenthsDecimal() + "%"
            cell.breweryLabel.text = beer.breweryName ?? "420 Blaze It"
            cell.beerStyleLabel.text = beer.beerStyle ?? "Hipster Style"
            cell.beerNameLabel.text = beer.beerName
            cell.addButton.tag = (indexPath as NSIndexPath).row
            
            //set detail outlets
            cell.ibuNumberLabelD.text = "\(beer.beerIBU)"
            cell.abvPercentageLabelD.text = beer.beerABV.convertToTenthsDecimal() + "%"
            cell.breweryNameD.text = beer.breweryName ?? "420 Blaze It"
            cell.beerStyleD.text = beer.beerStyle ?? "Hipster Style"
            cell.beerNameD.text = beer.beerName
            cell.breweryLocationLabel.text = beer.breweryLocation
            cell.beerDescriptionLabel.text = beer.beerDescription
            cell.addButtonD.tag = (indexPath as NSIndexPath).row
            
            
            return cell
            
        }
    }
}

//MARK: Extra methods

extension DiscoverTableViewController {

    @IBAction func unwindBackToAddBeer(_ segue: UIStoryboardSegue) {
        //make sure the segue has the correct identifier
        if segue.identifier == "unwindFromRating" {
            if let sourceVC = segue.source as? RateViewController {
                self.addBeerToCellar(withRating: sourceVC.rating ?? 3)
            }
        }
    }
    
    func prepareForDataCollect(_ responses: Set<IndexPath>, answers: [[String]]) {
        
        var responseString: String = ""
        
        // Convert the set into an array and sort them by section index
        let responseArray = Array(responses).sorted(by: { ($0 as NSIndexPath).section < ($1 as NSIndexPath).section })
        
        var numberOfFruits = 0
        var numberOfFlavors = 0
        
        for indexPath in responseArray {
            switch (indexPath as NSIndexPath).section {
            case 0 :
                responseString += "keywords=\(answers[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])&"
                break
            case 1 :
                responseString += "fruits[\(numberOfFruits)]=\(answers[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])&"
                numberOfFruits += 1
                break
            case 2 :
                let response = (indexPath as NSIndexPath).row == 0 ? 1 : 0
                responseString += "aroma=\(response)&"
                break
            case 3 :
                responseString += "flavors[\(numberOfFlavors)]=\(answers[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])&"
                numberOfFlavors += 1
                break
            case 4 :
                let response = (indexPath as NSIndexPath).row == 3 ? 0 : (indexPath as NSIndexPath).row
                responseString += "bitterness=\(response)&"
                break
            case 5 :
                let response = (indexPath as NSIndexPath).row == 3 ? 0 : (indexPath as NSIndexPath).row
                responseString += "color=\(response)&"
                break
            case 6 :
                let response = (indexPath as NSIndexPath).row == 1 ? 0 : (indexPath as NSIndexPath).row == 0 ? 1 : (indexPath as NSIndexPath).row - 2
                responseString += "maltiness=\(response)"
                break
            default :
                debugPrint("none")
            }
        }
        
        print(responseString)
        
        self.beerQuiz(responseString)
    }
    
    func beerQuiz(_ parameterString: String) {
        
        let paramString = parameterString
        let headerString = "Bearer \(DataCollector.token!)"
        
        dataCollector.beerQuizRequest(withHeaderString: headerString, withParamString: paramString) { quizBeers, errorString  in
            
            if let unwrappedErrorString = errorString {
                print(unwrappedErrorString)
                
                let alertController = UIAlertController(title: "Sorry!", message: "We could not get any results based on your answers!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            else {
                DispatchQueue.main.async(execute: {
                    self.quizBeers?.removeAll()
                    self.quizBeers = quizBeers!
                    self.quizState = .results
                })
            }
        }
    }
    
    //func to make the api call to add the beer to the cellear
    func addBeerToCellar(withRating rating: Int) {
        
        //grab the index of the beer to add and set it to a beer object
        guard let beerToAdd = self.beerToAdd, let beer = self.quizBeers?[beerToAdd] else {
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
                let alertController = UIAlertController(title: "Add Beer Failed", message: unwrappedErrorString, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            else {
                
                //remove beer from quiz reslts list
                self.quizBeers?.remove(at: beerToAdd)
                self.tableView.reloadData()
            }
        })
    }
    
    
    func createRetakeButton() {
        
        //create bar button item
        let barButton = UIBarButtonItem(title: "Retake", style: .plain, target: self, action: #selector(resetQuiz))
        
        //configure it
        barButton.tintColor = UIColor.white
        
        //add button to nav bar
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        
    }
    
    func resetQuiz() {
        self.quizState = .questions
    }
    
    
    func removeBarButtonItem() {
        self.navigationItem.setLeftBarButton(nil, animated: true)
    }
    
    
    
}

extension DiscoverTableViewController : QuestionsCellDelegate {
    
    func questionsCell(_ questionsCell: QuestionsCell, didSubmitResponses responses: Set<IndexPath>, forAnswers answers: [[String]]) {
        
        self.prepareForDataCollect(responses, answers: answers)
        
    }
    
    func displayAlert(_ title: String, message: String, actionTitle: String) {
        //alert user that beer couldnt be removed
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    
}




















