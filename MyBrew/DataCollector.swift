//
//  DataCollector.swift
//  MyBrew
//
//  Created by Jayme Becker on 3/12/16.
//  Copyright © 2016 Jayme Becker. All rights reserved.
//

import Foundation

class DataCollector {
    
     var token: String = "nothing"
    
    //post to API for a login or registration confirmation and send the data received back to the parse method
    func loginOrRegistrationRequest(fromURLString: String, paramString: String, completionHandler: (DataCollector, String?) -> Void)
    {
        if let url = NSURL(string: fromURLString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(self, error!.localizedDescription)
                    })
                } else {
                    self.parseLoginOrRegistrationResponse(data!, completionHandler: completionHandler)
                }
            })
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self, "invalid URL")
            })
        }
    }
    
    //parese passed in json data response
    func parseLoginOrRegistrationResponse(jsonData: NSData, completionHandler: (DataCollector, String?) -> Void)
    {
        var jsonResultWrapped: NSDictionary?
        
        do {
            jsonResultWrapped = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        } catch {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self, "exception on JSON parsing")
            })
        }
        
        if let jsonResult = jsonResultWrapped
        {
            if (jsonResult.count > 0)
            {
                if let status = jsonResult["status"] as? String
                {
                    if (status == "ok")
                    {
                        if let _ = jsonResult["message"] as? String
                        {
                            if let _ = jsonResult["token_type"] as? String
                            {
                                if let _ = jsonResult["token"] as? String
                                {
                                    self.token = jsonResult["token"] as! String
                                    print("recieved token: \(token)")
                                    
                                }
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(self, nil)
                        })
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(self, "status was not ok")
                        })
                    }
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(self, "Zero results returned")
                })

            }
        }
    }
    
}
























