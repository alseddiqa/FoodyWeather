//
//  BusinessPhotosViewController.swift
//  FoodyWeather
//
//  Created by Abdullah Alseddiq on 12/18/20.
//

import UIKit

class BusinessPhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var business: Business!
    var businessDetails: BusinessDetail!
    var businessPhotos = [URL]()

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        getBusinessDetails(businessId: business.id)
    }
    
    func getBusinessDetails(businessId: String) {
        let yelpApi = YelpAPI(lat: 0, lon: 0)
        yelpApi.getBusinessDetails(id: businessId) { (details) in
            guard let details = details else {
                return
            }
            self.businessDetails = details
            self.getPhotosURLs()
            //do more update to UI
        }
    }
    
    func getPhotosURLs(){
        for link in businessDetails.photos {
            let url = URL(string: link)
            businessPhotos.append(url!)
        }
        collectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businessPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "BusinessPhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        
        let imageUrl = businessPhotos[indexPath.item]
        cell.imageView.load(url: imageUrl)
        cell.shadowDecorate()
        return cell
    }
}
