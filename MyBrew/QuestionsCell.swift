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
   
    @IBAction func submitButtonPressed(sender: AnyObject) {
        print("Answers submitted")
    }

    
    var numQuestions = 4
    
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        let durations = [0.2, 0.1, 0.05]
        return durations[itemIndex]
    }
    
}


extension QuestionsCell: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0)
        {
            //set height for all other rows in this section
            
            
        }
        else
        {
            if let selectedCell = tableView.cellForRowAtIndexPath(indexPath) where selectedCell.accessoryType == .Checkmark {
                if let accessoryView = selectedCell.accessoryView {
                    accessoryView.hidden = !accessoryView.hidden
                }
            }
 
        }
        
    }
    
}

extension QuestionsCell: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numQuestions
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get num of sections based on the number answers possible per question
        
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Question #\(section + 1)"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //check which cell to make
        if(indexPath.row == 0)
        {
            if let singleQuestionCell = tableView.dequeueReusableCellWithIdentifier("SingleQuestionCell", forIndexPath: indexPath) as? SingleQuestionCell {
                //TODO: configure cell with data for question before returning
                
                singleQuestionCell.questionLabel.text = "Question \(indexPath.row)"
                
                return singleQuestionCell
            }
            
        }
        else
        {
            if let possibleAnswersCell = tableView.dequeueReusableCellWithIdentifier("PossibleAnswersCell", forIndexPath: indexPath) as? PossibleAnswersCell {
                //TODO configure cell with data for possible answers before returning
                
                possibleAnswersCell.possibleAnswerLabel.text = "Answer \(indexPath.row)"
                
                return possibleAnswersCell
            }
        }
     
        return UITableViewCell()
        
    }
    
    
}




















