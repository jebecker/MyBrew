//
//  DataCollector.swift
//  MyBrew
//
//  Created by Jayme Becker on 3/12/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import Foundation

class DataCollector {
    
    static var token: String = "nothing"
    var beers = Array<Beer>()
    var globalBeersArray = Array<Beer>()
    var dailyBeerArray = Array<Beer>()
    var recommendedBeersArray = Array<Beer>()
    
    // MARK: login anad registration api calls
    
    //post to API for a login or registration confirmation and send the data received back to the parse method
    func loginOrRegistrationRequest(fromURLString: String, paramString: String, completionHandler: (String?, String?) -> Void) {
        
        //create the url from the string passed in
        if let url = NSURL(string: fromURLString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
            
            //start the session and call the parse login response method
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, error!.localizedDescription)
                    })
                } else {
                    self.parseLoginOrRegistrationResponse(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "invalid URL")
            })
        }
    }
    
    //parsepassed in json data response
    func parseLoginOrRegistrationResponse(jsonData: NSData, completionHandler: (String?, String?) -> Void) {
        
        var jsonResultWrapped: NSDictionary?
        
        do {
            jsonResultWrapped = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "exception on JSON parsing")
            })
        }
        
        //unwwrap the json data and make sure that results were returned
        guard let jsonResult = jsonResultWrapped where jsonResult.count > 0 else {
            completionHandler(nil, "exception on unwrapping or zero results returned")
            return
        }
        
        guard let status = jsonResult["status"] as? String where status == "ok" else {
             completionHandler(nil, "status was not ok")
            return
        }
    
        //check to make sure the status was ok and grab the token that was returned
        if let token = jsonResult["token"] as? String
        {
            DataCollector.token = token
            print("received token: \(token)")
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            completionHandler(status, nil)
            return
        }
        
    }
    
    // MARK: beer cellar api calls
    //function to send the get request to the api for the beer cellar
    func beerCellarRequest(fromURLString: String, paramString: String, completionHandler: ([Beer]?, String?) -> Void) {
        
        //create the url from the string passed in
        if let url = NSURL(string: fromURLString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "GET"
            urlRequest.addValue(paramString, forHTTPHeaderField: "Authorization")
            
            //start the session and call the parse beer cellar response 
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, error!.localizedDescription)
                    })
                } else {
                    self.parseBeerCellarResponse(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "invalid URL")
            })
        }
    }
    
    //function to pasre the beer cellar response
    func parseBeerCellarResponse(jsonData: NSData, completionHandler: ([Beer]?, String?) -> Void) {
        
        var jsonResultWrapped: NSDictionary?
        
        do {
            jsonResultWrapped = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "exception on JSON parsing")
            })
        }
        
        //unwrap the json data and make sure results were returned
        guard let jsonResult = jsonResultWrapped where jsonResult.count > 0 else {
            completionHandler(nil, "exception on JSON parsing or no result found")
            return
        }
        
        guard let status = jsonResult["status"] where status as? String == "ok" else{
            completionHandler(nil, "status was not ok")
            return
        }
        
        //make sure the status was ok and grab the cellar returned
        if let cellar = jsonResult["cellar"] as? NSArray {
            print("Cellar: \(cellar)")
            
            //clear the array
            self.beers.removeAll()
            
            //grab all of the beers in the cellars information
            for beerData in cellar {
                
                if let beer = Beer(withJson: beerData as! [String : AnyObject])
                {
                        //add specific beer to beers array to keep track of returned beers in cellar
                        self.beers.append(beer)
                        //log
                        print("\(beer.beerName) added")
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, "user has no beers in cellar")
                    })
                }
               
                
            }
            dispatch_async(dispatch_get_main_queue()) {
                // return the beers
                if !self.beers.isEmpty
                {
                    completionHandler(self.beers, nil)
                    return
                }
                else
                {
                    completionHandler(self.beers, "the user doesn't have any beers in their cellar")
                }
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "status was not ok or no cellar returned")
            })
        }
    }
    
    // MARK: global beers list api calls
    
    //functinn that sends the get call to the api to grab all the beers in the application
    func globalBeersListRequest(fromURLString: String, paramString: String, completionHandler: ([Beer]?, String?) -> Void) {
        
        //create the url from the string passed in
        if let url = NSURL(string: fromURLString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "GET"
            urlRequest.addValue(paramString, forHTTPHeaderField: "Authorization")
            
            //start the session and call the parse  global beer list response
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, error!.localizedDescription)
                    })
                } else {
                    self.parseGlobalBeersListResponse(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "invalid URL")
            })
        }
    }
 
    //function that parses the global beers list request response
    func parseGlobalBeersListResponse(jsonData: NSData, completionHandler: ([Beer]?, String?) -> Void) {
        
        var jsonResultWrapped: NSDictionary?
        
        do {
            jsonResultWrapped = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "exception on JSON parsing")
            })
        }
        
        //unwrap the json data and make sure results were returned
        guard let jsonResult = jsonResultWrapped where jsonResult.count > 0 else {
            completionHandler(nil, "exception on JSON parsing or no result found")
            return
        }
        
        guard let status = jsonResult["status"] where status as? String == "ok" else {
            completionHandler(nil, "status was not ok")
            return
        }
        
        //make sure the status was ok and grab the cellar returned
        if let beers = jsonResult["beers"] as? NSArray {
            print(beers)
            
            //clear the array
            self.globalBeersArray.removeAll()
            
            //grab all of the beers in the cellars information
            for beerData in beers {
                
                if let beer = Beer(withGlobalJson: beerData as! [String : AnyObject]) {
                    //add specific beer to beers array to keep track of returned beers in cellar
                    self.globalBeersArray.append(beer)
                    //log
                    print("\(beer.beerName) added to the global array")
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, "no beers added to the global array")
                    })
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                // return the beers
                if !self.globalBeersArray.isEmpty {
                    completionHandler(self.globalBeersArray, nil)
                    return
                }
                else {
                    completionHandler(self.globalBeersArray, "there are no beers")
                }
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "status was not ok or no cellar returned")
            })
        }
    }

    
    //MARK: Add Beer to cellar api calls
    
    //post to api to add the specific beer to the users cellar
    func addBeerToCellar(paramString: String, headerString: String, completionHandler: (String?, String?) -> Void) {
        
        let addBeerUrlString = "https://api-mybrew.rhcloud.com/api/cellar/add-beer"
        //create the url from the string passed in
        if let url = NSURL(string: addBeerUrlString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
            urlRequest.addValue(headerString, forHTTPHeaderField: "Authorization")
            
            //start the session and call the parse add beer to cellar response method
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, error!.localizedDescription)
                    })
                } else {
                    self.parseAddBeerToCellarResponse(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "invalid URL")
            })
        }

    }
    
    //pasre the add beer response
    func parseAddBeerToCellarResponse(jsonData: NSData, completionHandler: (String?, String?) -> Void) {
        
        var jsonResultWrapped: NSDictionary?
        
        do {
            jsonResultWrapped = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "exception on JSON parsing")
            })
        }
        
        //unwrap the json data and make sure results were returned
        guard let jsonResult = jsonResultWrapped where jsonResult.count > 0 else {
            completionHandler(nil, "exception on JSON parsing or no result found")
            return
        }
        
        let message = jsonResult["message"] as? String
        
        guard let status = jsonResult["status"] as? String where status == "ok" else {
            completionHandler(nil, message)
            return
        }
    
        dispatch_async(dispatch_get_main_queue()) {
            completionHandler(status, nil)
            return
        }
        
    }
    
    //MARK: Delete beer from cellar
    
    func deleteBeerFromCellar(paramString: String, headerString: String, completionHandler: (String?, String?) -> Void) {
        
        let cancelBeerUrlString = "https://api-mybrew.rhcloud.com/api/cellar/remove-beer"
        
        //create the url from the string passed in
        if let url = NSURL(string: cancelBeerUrlString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
            urlRequest.addValue(headerString, forHTTPHeaderField: "Authorization")
            
            //start the session and call the parse add beer to cellar response method
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, error!.localizedDescription)
                    })
                } else {
                    self.parseAddBeerToCellarResponse(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "invalid URL")
            })
        }
    }
    
    //parse the delete request
    func parseDeleteBeerFromCellarRequest(jsonData: NSData, completionHandler: (String?, String?) -> Void) {
        
        var jsonResultWrapped: NSDictionary?
        
        do {
            jsonResultWrapped = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "exception on JSON parsing")
            })
        }
        
        //unwrap the json data and make sure results were returned
        guard let jsonResult = jsonResultWrapped where jsonResult.count > 0 else {
            completionHandler(nil, "exception on JSON parsing or no result found")
            return
        }
        
        let message = jsonResult["message"] as? String
        
        guard let status = jsonResult["status"] as? String where status == "ok" else {
            completionHandler(nil, message)
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            completionHandler(status, nil)
            return
        }
    }
    
    //MARK: grab daily beer
    
    func grabDailyBeer(headerString: String, completionHandler: ([Beer]?, String?) -> Void) {
        
        let dailyBeerUrlString = "https://api-mybrew.rhcloud.com/api/beers/daily-beer"
        
        //create the url from the string passed in
        if let url = NSURL(string: dailyBeerUrlString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "GET"
            urlRequest.addValue(headerString, forHTTPHeaderField: "Authorization")
            
            //start the session and call the parse add beer to cellar response method
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, error!.localizedDescription)
                    })
                } else {
                    self.parseGrabDailyBeerResponse(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "invalid URL")
            })
        }
    }
    
    
    //parse the grabDailyBeer response
    func parseGrabDailyBeerResponse(jsonData: NSData, completionHandler: ([Beer]?, String?) -> Void) {
        
        var jsonResultWrapped: NSDictionary?
        
        do {
            jsonResultWrapped = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "exception on JSON parsing")
            })
        }
        
        //unwrap the json data and make sure results were returned
        guard let jsonResult = jsonResultWrapped where jsonResult.count > 0 else {
            completionHandler(nil, "exception on JSON parsing or no result found")
            return
        }
        
        guard let status = jsonResult["status"] where status as? String == "ok" else {
            completionHandler(nil, "status was not ok")
            return
        }
        
        guard let beerData = jsonResult["beer"] as? [String : AnyObject] else {
            completionHandler(nil, "no daily beer data")
            return
        }
        
        //clear the list
        self.dailyBeerArray.removeAll()
        
        if let beer = Beer(withDailyBeerJson: beerData) {
            
            //add the daily beer to the array
            self.dailyBeerArray.append(beer)
            
            print("Daily beer \(beer.beerName) added")
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "no daily beer added")
            })
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            // return the beers
            if !self.dailyBeerArray.isEmpty {
                completionHandler(self.dailyBeerArray, nil)
                return
            }
            else {
                completionHandler(self.dailyBeerArray, "there are no daily beers")
            }
        }
    }
    
    //MARK: recommended beers list api calls
    
    func recommendedBeersListRequest(headerString: String, completionHandler: ([Beer]?, String?) -> Void) {
        
        let recommendedBeersListUrlString = "https://api-mybrew.rhcloud.com/api/cellar/recommend"
        
        //create the url from the string passed in
        if let url = NSURL(string: recommendedBeersListUrlString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "GET"
            urlRequest.addValue(headerString, forHTTPHeaderField: "Authorization")
            
            //start the session and call the parse  global beer list response
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, error!.localizedDescription)
                    })
                } else {
                    self.parseRecommendedBeersListRequest(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "invalid URL")
            })
        }
        
    }
    
    //func to parse the recommendedBeersList request
    func parseRecommendedBeersListRequest(jsonData: NSData, completionHandler: ([Beer]?, String?) -> Void) {
        
        var jsonResultWrapped: NSDictionary?
        
        do {
            jsonResultWrapped = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "exception on JSON parsing")
            })
        }
        
        //unwrap the json data and make sure results were returned
        guard let jsonResult = jsonResultWrapped where jsonResult.count > 0 else {
            completionHandler(nil, "exception on JSON parsing or no result found")
            return
        }
        
        guard let status = jsonResult["status"] where status as? String == "ok" else {
            completionHandler(nil, "status was not ok")
            return
        }
        
        //make sure the status was ok and grab the cellar returned
        if let beers = jsonResult["beers"] as? NSArray {
            print(beers)
            
            //clear the array
            self.recommendedBeersArray.removeAll()
            
            //grab all of the beers in the cellars information
            for beerData in beers {
                
                if let beer = Beer(withGlobalJson: beerData as! [String : AnyObject]) {
                    //add specific beer to beers array to keep track of returned beers in cellar
                    self.recommendedBeersArray.append(beer)
                    //log
                    print("Recommended Beer \(beer.beerName) added")
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, "no beers added to the recommend array")
                    })
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                // return the beers
                if !self.recommendedBeersArray.isEmpty {
                    completionHandler(self.recommendedBeersArray, nil)
                    return
                }
                else {
                    completionHandler(self.recommendedBeersArray, "there are no recommended beers")
                }
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "status was not ok or no recommended beers returned")
            })
        }
    }
    
    //MARK: Beer Quiz request API call
    
    func beerQuizRequest(withHeaderString headerString: String, withParamString paramString: String, completionHandler: ([Beer]?, String?) -> Void) {
        
        let beerQuizUrlString = "https://api-mybrew.rhcloud.com/api/beers/quiz"
        
        //create the url from the string passed in
        if let url = NSURL(string: beerQuizUrlString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
            urlRequest.addValue(headerString, forHTTPHeaderField: "Authorization")
            
            //start the session and call the parse add beer to cellar response method
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, error!.localizedDescription)
                    })
                } else {
                    self.parseRecommendedBeersListRequest(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "invalid URL")
            })
        }
    }
    
}
























