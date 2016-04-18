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
    
    var questionsArray: [[String]] =
        [
            ["Pick what appeals most to you",
                "Chocolate",
                "Coffee",
                "Fruit",
                "Cinnamon Swirl Cake",
                "Banana Bread"
            ],
            ["Which fruits do you like (check all that apply)",
                "Orange",
                "Grapefruit",
                "Peach",
                "Lemons/Citris",
                "Berries",
                "Pears/Apples",
                "None"
            ],
            ["Do you like the aroma of spices such as pine, ginger, and oak?",
                "Yes",
                "No"
            ],
            ["Check with flavors appeal to you (check all that apply)",
                "Mint",
                "Pumpkin",
                "Meaty",
                "Floral",
                "Molasses"
            ],
            ["How do you like your beers?",
                "Not bitter at all",
                "Somewhat bitter",
                "Very bitter",
                "Not Sure"
            ],
            ["What color of beer appeals to you the most",
                "Very Light",
                "Medium Color",
                "Dark",
                "Doesnt matter",
                "Not sure"
            ],
            ["Do you like malty beers?",
                "Yes",
                "No",
                "Not sure"
            ]
    ]

    
    //var numQuestions = 4
    var checked = [Bool](count: 80, repeatedValue: false)
    override func awakeFromNib() {
        //numQuestions = questionsArray[].count();
        
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
    
}


extension QuestionsCell: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0)
        {
            //set height for all other rows in this section
            
            
        }
        else
        {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if indexPath.section != 1 && indexPath.section != 3 {
                    //if cell.accessoryType == .Checkmark {
                        cell.accessoryType = .None
                        for i in indexPath.section*10...indexPath.section*10+10 {
                            checked[i] = false
                            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i-indexPath.section*10, inSection: indexPath.section))?.accessoryType = .None
                        }
                    
                    
                        debugPrint("lskjdflk")
                        checked[10*indexPath.section+indexPath.row] = true
                        cell.accessoryType = .Checkmark
                    //}
                }
                    else {
                        if cell.accessoryType == .Checkmark {
                            cell.accessoryType = .None
                            checked[10*indexPath.section+indexPath.row] = false
                        } else {
                            cell.accessoryType = .Checkmark
                            checked[10*indexPath.section+indexPath.row] = true
                        }

                    
                    }
                
                
                
            }
            
            
           // debugPrint("select")
            
            /*if let selectedCell = tableView.cellForRowAtIndexPath(indexPath) where selectedCell.accessoryType == .Checkmark {
                if let accessoryView = selectedCell.accessoryView {
                    accessoryView.hidden = !accessoryView.hidden
                }
            }*/
 
        }
        
    }
    
}

extension QuestionsCell: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return questionsArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get num of sections based on the number answers possible per question
        
        return questionsArray[section].count
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
                
                singleQuestionCell.questionLabel.text = questionsArray[indexPath.section][0]//"Question \(indexPath.row)"
                
                
                return singleQuestionCell
            }
            
        }
        else
        {
            if let possibleAnswersCell = tableView.dequeueReusableCellWithIdentifier("PossibleAnswersCell", forIndexPath: indexPath) as? PossibleAnswersCell {
                //TODO configure cell with data for possible answers before returning
                
                possibleAnswersCell.possibleAnswerLabel.text = questionsArray[indexPath.section][indexPath.row]
                
                // Hide the checkmark until selection
                if let accessoryView = possibleAnswersCell.accessoryView where possibleAnswersCell.accessoryType == .Checkmark {
                    accessoryView.hidden = true
                }
                
                if !checked[10*indexPath.section+indexPath.row] {
                    possibleAnswersCell.accessoryType = .None
                } else if checked[10*indexPath.section+indexPath.row] {
                    possibleAnswersCell.accessoryType = .Checkmark
                }
                //return cell
                
                return possibleAnswersCell
            }
        }
     
        return UITableViewCell()
        
    }
    
    
}




















