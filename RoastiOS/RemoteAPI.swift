//
//  RTAPI.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/14/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//

import Foundation

class RemoteAPI {
    
    let apiKey = "yedukp76ffytfuy24zsqk7f5"
    let baseUrl = "http://api.rottentomatoes.com/api/public/v1.0/"
    let dvdPartial = "lists/dvds/new_releases.json"
    let moviePartial = "lists/movies/in_theaters.json"
    let searchPartial = "movies.json?page_limit=25&page=1&q="
    var url = ""
    
    
    init(type: String, query: String?) {
        url = baseUrl
        switch type {
        case "dvd":
            url += dvdPartial + "?"
        case "movie":
            url += moviePartial + "?"
        case "search":
            url += searchPartial + query!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "&"
        default:
            break
        }
        url += "apikey=" + apiKey
    }
    
    
    func getData(completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void {
        let url: NSURL = NSURL(string: self.url)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil) {
                return completionHandler(nil, error)
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                return completionHandler(json["movies"] as! [NSDictionary], nil)
            } catch let error as NSError {
                return completionHandler(nil, error)
            }
        })
        task.resume()
    }
}