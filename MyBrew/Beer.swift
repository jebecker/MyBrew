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
    let beerStyle : String?
    
    var beerURL : URL? {
        get{
          return URL(string: beerUrlString)
        }
    }
    
    let beerDescription : String
    let beerID : Int
    var breweryName  : String?
    var breweryLocation : String?

    convenience init?(withGlobalJson globalJson : [String : AnyObject]) {
        
        //make sure you can extract the specific beer info or return nil
        guard let beerName = globalJson["name"] as? String,
            let beerID  = globalJson["id"] as? Int,
            let beerSRM = globalJson["srm"] as? Int,
            let beerABV = globalJson["abv"] as? String,
            let beerIBU = globalJson["ibu"] as? Int,
            let beerURL = globalJson["url"] as? String,
            let beerDescription = globalJson["description"] as? String else {
                return nil
        }
        
        //grab the style object from the beer and get the style name
        guard let style = globalJson["style"] as? [String : AnyObject], let beerStyle = style["name"] as? String else{
            return nil
        }
        
        //initialize a beer object
        self.init(beerName: beerName, beerID: beerID, beerSRM: beerSRM, beerABV: beerABV, beerIBU: beerIBU, beerStyle: beerStyle, beerUrlString: beerURL, beerDescription: beerDescription, breweryName: nil,breweryLocation: nil)
        
        //look to see if the beer has a brewery associated with it and if so, extract that data and update that property
        if let brewery = globalJson["brewery"] as? [String : AnyObject], let breweryName = brewery["name"] as? String, let breweryLocation = brewery["location"] as? String {
            self.breweryName = breweryName
            self.breweryLocation = breweryLocation
        }

        
    }
    
   convenience init?(withJson json : [String : AnyObject]) {
    
        //extract the beer dictionary or return nil
        guard let beer = json["beer"] as? [String : AnyObject] else {
            return nil
        }

        //make sure you can extract the specific beer info or return nil
        guard let beerName = beer["name"] as? String,
            let beerID  = beer["id"] as? Int,
            let beerSRM = beer["srm"] as? Int,
            let beerABV = beer["abv"] as? String,
            let beerIBU = beer["ibu"] as? Int,
            let beerURL = beer["url"] as? String,
            let beerDescription = beer["description"] as? String else {
                return nil
        }
        
        //grab the style object from the beer and get the style name
        guard let style = beer["style"] as? [String : AnyObject], let beerStyle = style["name"] as? String else{
            return nil
        }
        
        //initialize a beer object
        self.init(beerName: beerName, beerID: beerID, beerSRM: beerSRM, beerABV: beerABV, beerIBU: beerIBU, beerStyle: beerStyle, beerUrlString: beerURL, beerDescription: beerDescription, breweryName: nil,breweryLocation: nil)
        
        //look to see if the beer has a brewery associated with it and if so, extract that data and update that property
        if let brewery = beer["brewery"] as? [String : AnyObject], let breweryName = brewery["name"] as? String, let breweryLocation = brewery["location"] as? String {
            self.breweryName = breweryName
            self.breweryLocation = breweryLocation
        }

    }
    
    convenience init?(withDailyBeerJson beer : [String : AnyObject]) {
        
        //make sure you can extract the specific beer info or return nil
        guard let beerName = beer["name"] as? String,
            let beerID  = beer["id"] as? Int,
            let beerSRM = beer["srm"] as? Int,
            let beerABV = beer["abv"] as? String,
            let beerIBU = beer["ibu"] as? Int,
            let beerURL = beer["url"] as? String,
            let beerDescription = beer["description"] as? String else {
                return nil
        }
        
        //grab the style object from the beer and get the style name
        guard let style = beer["style"] as? [String : AnyObject], let beerStyle = style["name"] as? String else{
            return nil
        }
        
        //initialize a beer object
        self.init(beerName: beerName, beerID: beerID, beerSRM: beerSRM, beerABV: beerABV, beerIBU: beerIBU, beerStyle: beerStyle, beerUrlString: beerURL, beerDescription: beerDescription, breweryName: nil,breweryLocation: nil)
        
        //look to see if the beer has a brewery associated with it and if so, extract that data and update that property
        if let brewery = beer["brewery"] as? [String : AnyObject], let breweryName = brewery["name"] as? String, let breweryLocation = brewery["location"] as? String {
            self.breweryName = breweryName
            self.breweryLocation = breweryLocation
        }

    }
    
    init(beerName: String, beerID: Int, beerSRM : Int, beerABV: String, beerIBU: Int, beerStyle: String, beerUrlString: String, beerDescription: String, breweryName: String?, breweryLocation: String?) {
        
        self.beerName = beerName
        self.beerID = beerID
        self.beerSRM = beerSRM
        self.beerIBU = beerIBU
        self.beerUrlString = beerUrlString
        self.beerDescription = beerDescription
        self.breweryName = breweryName
        self.breweryLocation = breweryLocation
        self.beerABV = beerABV
        self.beerStyle = beerStyle
    }
}

extension String {
    
    func convertToTenthsDecimal() -> String {
        return String(format: "%0.1f", arguments: [NSString(string: self).floatValue])
    }
}
