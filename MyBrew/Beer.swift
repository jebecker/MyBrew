//
//  Beer.swift
//  MyBrew
//
//  Created by Jayme Becker on 3/21/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import Foundation

class Beer {
    
    let beerName : String
    let beerSRM  : Int
    var beerABV  : String
    let beerIBU  : Int
    let beerUrlString  : String
    let beerStyle : String? = nil
    
    var beerURL : NSURL? {
        get{
          return NSURL(string: beerUrlString)
        }
    }
    
    let beerDescription : String
    var breweryName  : String?
    var breweryLocation : String?
    
   convenience init?(withJson json : [String : AnyObject])
   {
        //extract the beer dictionary or return nil
        guard let beer = json["beer"] as? [String : AnyObject] else {
            return nil
        }
    
        //make sure you can extract the specific beer info or return nil
        guard let beerName = beer["name"] as? String,
            beerSRM = beer["srm"] as? Int,
            beerABV = beer["abv"] as? String,
            beerIBU = beer["ibu"] as? Int,
            beerURL = beer["url"] as? String,
            beerDescription = beer["description"] as? String else {
                return nil
        }
    
        //initialize a beer object
        self.init(beerName: beerName, beerSRM: beerSRM, beerABV: beerABV, beerIBU: beerIBU, beerUrlString: beerURL, beerDescription: beerDescription, breweryName: nil,breweryLocation: nil)
    
        //look to see if the beer has a brewery associated with it and if so, extract that data and update that property
        if let brewery = beer["brewery"] as? [String : AnyObject], breweryName = brewery["name"] as? String, breweryLocation = brewery["location"] as? String {
            self.breweryName = breweryName
            self.breweryLocation = breweryLocation
        }

    }
    
    init(beerName: String, beerSRM : Int, beerABV: String, beerIBU: Int, beerUrlString: String, beerDescription: String, breweryName: String?, breweryLocation: String?)
    {
        self.beerName = beerName
        self.beerSRM = beerSRM
        self.beerIBU = beerIBU
        self.beerUrlString = beerUrlString
        self.beerDescription = beerDescription
        self.breweryName = breweryName
        self.breweryLocation = breweryLocation
        self.beerABV = beerABV
    }
    
    
}

extension String {
    func convertToTenthsDecimal() -> String {
        return String(format: "%0.1f", arguments: [NSString(string: self).floatValue])
    }
}
