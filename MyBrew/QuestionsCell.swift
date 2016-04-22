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

    var questionsArray = ["Pick what appeals most to you", "Which fruits do you like (check all that apply)", "Do you like the aroma of spices such as pine, ginger, and oak?", "Check with flavors appeal to you (check all that apply)", "How do you like your beers?", "What color of beer appeals to you the most", "Do you like malty beers?"]
    
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
                "Lemons/Citris",
                "Berries",
                "Pears/Apples",
                "None"
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

    var selectedAnswers = Set<NSIndexPath>()
    
    override func awakeFromNib() {
        
        
        // Declared in superclass
        self.itemCount = 4      // number of folds in the cell
        self.backViewColor = UIColor.blackColor()       // color of the back of the card as it (un)folds
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        // REQUIRED: durations.count == self.itemCount
        let durations = [0.4, 0.2, 0.2, 0.2]
        assert(durations.count == self.itemCount)
        return durations[itemIndex]
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        guard self.selectedAnswers.count >= self.questionsArray.count else {
            // Display an alert
            
            return
        }
        
        // Call the delegate method
        self.delegate?.questionsCell(self, didSubmitResponses: self.selectedAnswers, forAnswers: self.answersArray)
        
    }

    
}


extension QuestionsCell: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                self.selectedAnswers.remove(indexPath)
            } else {
                cell.accessoryType = .Checkmark
                self.selectedAnswers.insert(indexPath)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Create the label
        let headerLabel = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: UIScreen.mainScreen().bounds.width-15.0, height: 0.0))
        headerLabel.text = self.questionsArray[section]
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .ByWordWrapping
        headerLabel.textColor = UIColor.blackColor()
        headerLabel.sizeToFit()
        //headerLabel.backgroundColor = UIColor.lightGrayColor()
        
        // Create the view
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: headerLabel.frame.width, height: headerLabel.frame.height))
        headerView.backgroundColor = UIColor.lightGrayColor()

        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let headerLabel = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: UIScreen.mainScreen().bounds.width-15, height: 0.0))
        headerLabel.text = self.questionsArray[section]
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = .ByWordWrapping
        headerLabel.textColor = UIColor.blackColor()
        headerLabel.backgroundColor = UIColor.lightGrayColor()
        
        headerLabel.sizeToFit()
        
        return headerLabel.frame.size.height
    }
}




extension QuestionsCell: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.questionsArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return self.answersArray[section].count
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.questionsArray[section]
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let possibleAnswersCell = tableView.dequeueReusableCellWithIdentifier("PossibleAnswersCell", forIndexPath: indexPath) as? PossibleAnswersCell {
            
            possibleAnswersCell.possibleAnswerLabel.text = answersArray[indexPath.section][indexPath.row]
            
            // Checkmark the cell if its indexPath is in the selected answers set
            possibleAnswersCell.accessoryType = self.selectedAnswers.contains(indexPath) ? .Checkmark : .None
            
            return possibleAnswersCell
        }
        
     
        return UITableViewCell()
        
    }
    
    
}

//declare protocol 
protocol QuestionsCellDelegate {
    func questionsCell(questionsCell: QuestionsCell, didSubmitResponses responses: Set<NSIndexPath>, forAnswers answers: [[String]])
}




















