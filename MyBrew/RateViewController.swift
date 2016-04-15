//
//  RateViewController.swift
//  MyBrew
//
//  Created by Jayme Becker on 4/11/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    var rating : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.floatRatingView.delegate = self

        // Do any additional setup after loading the view.
    }
}

// MARK: FloatRatingViewDelegate

extension RateViewController: FloatRatingViewDelegate {
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        //self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        //self.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
        self.rating = Int(rating)
    }
}