//
//  MyBeerCell.swift
//  MyBrew
//
//  Created by Jayme Becker on 2/21/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class MyBeerCell: FoldingCell {

    override func awakeFromNib() {
        
        // Declared in superclass
        self.itemCount = 4      // number of folds in the cell
        self.backViewColor = UIColor.blackColor()       // color of the back of the card as it (un)folds
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        let durations = [0.4, 0.2, 0.2, 0.2]
        assert(durations.count == self.itemCount)
        return durations[itemIndex]
    }

}
