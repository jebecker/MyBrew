//
//  QuestionsCell.swift
//  MyBrew
//
//  Created by Jayme Becker on 2/28/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class QuestionsCell: FoldingCell {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var questionsAnswersTableView: UITableView!
    
    var delegate : QuestionsCellDelegate?
    
    var discoverController : DiscoverTableViewController?
    
    var numAnswers : [(min: Int, max: Int)] = [(1, 1), (1, 6), (1, 1), (1, 5), (1, 1), (1, 1), (1, 1)]

    var questionsArray = ["Pick what appeals most to you", "Which fruits do you like (check all that apply)", "Do you like the aroma of spices such as pine, ginger, and oak?", "Check which flavors appeal to you (check all that apply)", "How do you like your beers?", "What color of beer appeals to you the most", "Do you like malty beers?"]
    
    var answersArray: [[String]] =
        [
            [
                "Chocolate",
                "Coffee",
                "Fruit",
                "Cinnamon Swirl Cake",
                "Banana Bread"
            ],
            [
                "Orange",
                "Grapefruit",
                "Peach",
                "Lemons/Citrus",
                "Berries",
                "Pears/Apples"
            ],
            [
                "Yes",
                "No"
            ],
            [
                "Mint",
                "Pumpkin",
                "Meaty",
                "Floral",
                "Molasses"
            ],
            [
                "Not bitter at all",
                "Somewhat bitter",
                "Very bitter",
                "Not Sure"
            ],
            [
                "Very Light",
                "Medium Color",
                "Dark",
                "Doesnt matter"
            ],
            [
                "Yes",
                "No",
                "Not sure"
            ]
    ]

    var selectedAnswers = Set<IndexPath>()
    
    override func awakeFromNib() {
        
        
        // Declared in superclass
        self.itemCount = 4      // number of folds in the cell
        self.backViewColor = UIColor.black       // color of the back of the card as it (un)folds
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        // REQUIRED: durations.count == self.itemCount
        let durations = [0.4, 0.2, 0.2, 0.2]
        assert(durations.count == self.itemCount)
        return durations[itemIndex]
    }
    
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
        
        // Create a set of unique sections from the selected answer's sections
        let selectedSections : Set<Int> = Set(self.selectedAnswers.flatMap({ ($0 as IndexPath).section }))
        if selectedSections.count != self.questionsAnswersTableView.numberOfSections {
            // Display an alert
            self.delegate?.displayAlert("Ooops!", message: "Please select at least 1 answer for each quiz question.", actionTitle: "Ok")
            return
        }
        
        guard self.selectedAnswers.count >= self.questionsArray.count else {
            // Display an alert
            self.delegate?.displayAlert("Ooops!", message: "Sorry, we could not get any beers for you based on your answers!", actionTitle: "Ok")

            return
        }
        
        // Call the delegate method
        self.delegate?.questionsCell(self, didSubmitResponses: self.selectedAnswers, forAnswers: self.answersArray)
        
    }
    
}

//MARK: Table View Delegate methods

extension QuestionsCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                self.selectedAnswers.remove(indexPath)
            } else {
                cell.accessoryType = .checkmark
                self.selectedAnswers.insert(indexPath)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //get only index paths corresponding to the current section
        var filteredIndexPaths = self.selectedAnswers.filter({ ($0 as IndexPath).section == (indexPath as IndexPath).section })
        
        //check to see if the filtered arrays count is greater than the max for that section in the num answers array
        guard filteredIndexPaths.count > self.numAnswers[(indexPath as IndexPath).section].max else {
            return
        }
        
        for (i, idxPath) in filteredIndexPaths.enumerated() where idxPath.row != indexPath.row {
            // Get the cell
            if let cell = tableView.cellForRow(at: idxPath) , cell.accessoryType == .checkmark {
                cell.accessoryType = .none // uncheck the cell
                self.selectedAnswers.remove(idxPath) // remove the indexPath from the saved answers
                filteredIndexPaths.remove(at: i)
            }
            
            // Break if the number of selected rows is now equal or less than the max
            if filteredIndexPaths.count <= self.numAnswers[(indexPath as NSIndexPath).section].max {
                return
            }
        }
        
//        for (index, idxPath) in filteredIndexPaths.enumerated() where (idxPath as IndexPath).row != (indexPath as IndexPath).row {
//            // Get the cell
//            if let cell = tableView.cellForRow(at: idxPath) , cell.accessoryType == .checkmark {
//                cell.accessoryType = .none // uncheck the cell
//                self.selectedAnswers.remove(idxPath) // remove the indexPath from the saved answers
//                filteredIndexPaths.remove(at: index)
//            }
//            
//            // Break if the number of selected rows is now equal or less than the max
//            if filteredIndexPaths.count <= self.numAnswers[(indexPath as NSIndexPath).section].max {
//                return
//            }
//            
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Create the label
        let headerLabel = UILabel(frame: CGRect(x: 10.0, y: 0.0, width: tableView.frame.width - 10.0, height: 0.0))
        headerLabel.text = self.questionsArray[section]
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.textColor = UIColor.black
        headerLabel.sizeToFit()
        headerLabel.textAlignment = .left
        //headerLabel.backgroundColor = UIColor.lightGrayColor()
        
        // Create the view
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: headerLabel.frame.width, height: headerLabel.frame.height))
        headerView.backgroundColor = UIColor.lightGray

        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let headerLabel = UILabel(frame: CGRect(x: 10.0, y: 0.0, width: tableView.frame.width - 10.0, height: 0.0))
        headerLabel.text = self.questionsArray[section]
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.textColor = UIColor.black
        headerLabel.backgroundColor = UIColor.lightGray
        
        headerLabel.sizeToFit()
        
        return headerLabel.frame.size.height
    }
}




extension QuestionsCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.questionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return self.answersArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let possibleAnswersCell = tableView.dequeueReusableCell(withIdentifier: "PossibleAnswersCell", for: indexPath) as? PossibleAnswersCell {
            
            possibleAnswersCell.possibleAnswerLabel.text = answersArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            
            // Checkmark the cell if its indexPath is in the selected answers set
            possibleAnswersCell.accessoryType = self.selectedAnswers.contains(indexPath) ? .checkmark : .none
            
            return possibleAnswersCell
        }
        
     
        return UITableViewCell()
        
    }
    
    
}

//MARK: Delegate methods

protocol QuestionsCellDelegate {
    func questionsCell(_ questionsCell: QuestionsCell, didSubmitResponses responses: Set<IndexPath>, forAnswers answers: [[String]])
    func displayAlert(_ title: String, message: String, actionTitle: String)
}
