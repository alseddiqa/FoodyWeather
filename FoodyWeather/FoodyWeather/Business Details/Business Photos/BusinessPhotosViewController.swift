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
        YelpAPI.getBusinessDetails(id: businessId) { (details) in
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
        businessStorage.updatePhotosForBusiness(businessId: business.id, photos: self.businessPhotos)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "photoDetail":
            if let selectedIndexPath =
                collectionView.indexPathsForSelectedItems?.first {
                let photoURL = businessPhotos[selectedIndexPath.row]
                let destinationVC = segue.destination as! PhotoDetailViewController
                destinationVC.imageURL = photoURL
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    
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
