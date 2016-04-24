//
//  MovieDetailViewController.swift
//  RoastiOS
//
//  Created by Andy Fang on 4/24/16.
//  Copyright © 2016 Andy Fang. All rights reserved.
//

import UIKit
import Cosmos
import Firebase

class MovieDetailViewController: UIViewController, UITextViewDelegate {
    
    var movie: Movie?
    @IBOutlet weak var movieRating: CosmosView!
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var review: UITextView!
    
    let baseRef = Firebase(url: "https://roast-potato.firebaseio.com/")
    var userMajor: String?
    var uid: String?
    var userProfileRef: Firebase? = nil
    var reviewRef: Firebase? = nil
    var reviewModel: MovieRating? = nil
    
    func uploadReview() {
        self.updateReviewFromView()
        self.reviewRef!.childByAppendingPath("comment").setValue(reviewModel!.comment!)
        self.reviewRef!.childByAppendingPath("movie").setValue(movie!.title!)
        self.reviewRef!.childByAppendingPath("score").setValue(reviewModel!.score!)
        self.reviewRef!.childByAppendingPath("ranking").setValue(6.0 - reviewModel!.score!)
        self.reviewRef!.childByAppendingPath("userMajor").setValue(self.userMajor!)
    }
    func updateReviewFromView() {
        self.reviewModel?.comment = self.review.text
        self.reviewModel?.score = self.movieRating.rating
    }
    func updateViewFromReview() {
        self.review.text = self.reviewModel!.comment!
        self.movieRating.rating = self.reviewModel!.score!
    }
    
    override func viewDidLoad() {
        //self.movieTitle.text = self.movie?.title
        navbar.title = self.movie?.title
        self.review.delegate = self;
        self.uid = baseRef.authData.uid
        let path = "profile/" + self.uid!
        self.userProfileRef = baseRef.childByAppendingPath(path)
        self.userProfileRef?.observeEventType(.Value, withBlock: {snapshot in
            self.userMajor = snapshot.value.objectForKey("major") as? String ?? ""
        })
        self.reviewRef = baseRef.childByAppendingPath("comments/" + self.uid! + "_" + self.movie!.id)
        self.reviewRef?.observeSingleEventOfType(.Value, withBlock: {snapshot in
            self.reviewModel = MovieRating()
            if (snapshot.exists()) {
                self.reviewModel?.comment = snapshot.value.objectForKey("comment") as? String! ?? ""
                self.reviewModel?.score = snapshot.value.objectForKey("score") as? Double! ?? 5.0
            } else {
                
            }
            self.updateViewFromReview()
        })
        movieRating.didFinishTouchingCosmos = { rating in
            self.movieRating.rating = rating
            self.uploadReview()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        self.uploadReview()
    }
}
