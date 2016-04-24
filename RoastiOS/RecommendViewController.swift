//
//  RecommendViewController.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/24/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//

import UIKit
import Firebase

class RecommendViewController: UITableViewController {
    
    var items = [Movie]()
    let baseRef = Firebase(url: "https://roast-potato.firebaseio.com/")
    var commentRef: Firebase? = nil
    var userMajor: String?
    var uid: String?
    var userProfileRef: Firebase? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.commentRef = self.baseRef.childByAppendingPath("comments/")
        self.uid = baseRef.authData.uid
        let path = "profile/" + self.uid!
        self.userProfileRef = baseRef.childByAppendingPath(path)
        self.userProfileRef?.observeEventType(.Value, withBlock: {snapshot in
            self.userMajor = snapshot.value.objectForKey("major") as? String ?? ""
            self.commentRef!.queryOrderedByChild("ranking").observeEventType(.ChildAdded, withBlock: { snapshot in
                let movieID = snapshot.key.characters.split{$0 == "_"}.map(String.init)[1]
                let movieTitle = snapshot.value["movie"] as! String
                self.items.append(Movie(title: movieTitle, id: movieID))
                self.tableView!.reloadData()
            })
        })
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("defaultMovieCell", forIndexPath: indexPath)
        if let movieTitle = self.items[indexPath.row].title as String? {
            cell.textLabel!.text = movieTitle
        } else {
            cell.textLabel!.text = "No Name"
        }
        return cell
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowDetail") {
            let targetView = segue.destinationViewController as! MovieDetailViewController
            if let selectedCell = sender as? UITableViewCell {
                let index = self.tableView.indexPathForCell(selectedCell)
                targetView.movie = self.items[(index?.row)!]
            }
        }
    }
    
    // firebase - userID - profile - user major 
    
}
