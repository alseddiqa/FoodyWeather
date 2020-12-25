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
    var businessStorage: BusinessStorage!


    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        if business != nil {
            getBusinessDetails(businessId: business.id)
        }
    }
    
    func getBusinessDetails(businessId: String) {
        let yelpApi = YelpAPI(lat: 0, lon: 0)
        yelpApi.getBusinessDetails(id: businessId) { (details) in
            guard let details = details else {
                return
            }
            self.businessDetails = details
            self.getPhotosURLs()
            self.storeBusinessPhotos()
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
    
    func storeBusinessPhotos() {
        let b = SavedBusiness(name: business.name, businessId: business.id, reviewCount: business.reviewCount, businessLocation: business.location, category: business.categories[0].title, rating: business.rating, phone: business.displayPhone, imageURL: business.imageURL)
        businessStorage.addBusiness(b)
        let updated = b
        updated.businessPhotos = self.businessPhotos
        businessStorage.updateBusinessInformaton(oldBusiness: b, newBusiness: updated)
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businessPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "BusinessPhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        
        let imageUrl = businessPhotos[indexPath.item]
        cell.imageView.kf.setImage(with: imageUrl)
        cell.shadowDecorate()
        return cell
    }
}