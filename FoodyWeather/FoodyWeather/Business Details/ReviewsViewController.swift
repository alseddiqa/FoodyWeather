//
//  ReviewsViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/28/20.
//

import UIKit

class ReviewsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    var business: Business!
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        getBusinessReviews()
        
    }
    
    func getBusinessReviews() {
        YelpAPI.getBusinessReviews(id: business.id) {
            (businessReviews) in
            guard let businessReviews = businessReviews else {
                return
            }
            self.reviews = businessReviews.reviews
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "BusinessReviewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BusinessReviewCell
        
        let review = reviews[indexPath.item]
        cell.reviewLabel.text = review.text
        cell.reviewRating.text = String(review.rating)
        cell.shadowDecorate()
        return cell
    }
    

}
