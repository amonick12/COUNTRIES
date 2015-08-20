//
//  APIController.swift
//  COUNTRIES
//
//  Created by Aaron Monick on 8/18/15.
//  Copyright (c) 2015 MONIX. All rights reserved.
//

import Foundation

class APIController {
    
    func getJSONFromURL(url: NSURL, completion: ((results: NSArray?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            
            var jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSArray
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(results: jsonResults)
            })
        }).resume()
    }
}