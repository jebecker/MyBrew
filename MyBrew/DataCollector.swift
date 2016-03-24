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
    
    //post to API for a login or registration confirmation and send the data received back to the parse method
    func loginOrRegistrationRequest(fromURLString: String, paramString: String, completionHandler: (String?, String?) -> Void)
    {
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
    func parseLoginOrRegistrationResponse(jsonData: NSData, completionHandler: (String?, String?) -> Void)
    {
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
    
    //function to send the post request to the api for the beer cellar
    func beerCellarRequest(fromURLString: String, paramString: String, completionHandler: ([Beer]?, String?) -> Void)
    {
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
    func parseBeerCellarResponse(jsonData: NSData, completionHandler: ([Beer]?, String?) -> Void)
    {
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
        if let cellar = jsonResult["cellar"] as? NSArray
        {
            print(cellar)
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
        else
        {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(nil, "status was not ok or no cellar returned")
            })
        }
    }
    
    
}
























