//
//  PhotosViewController.swift
//  FaceBook Photos Exporting App
//
//  Created by Safoine Moncef Amine on 26/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import UIKit
import FacebookCore

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentAlbum : Album?
    var photos : [Photo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getPhotos()
    }
    
    func configure() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        let width = (view.frame.size.width - 10) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    func getPhotos(){
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: currentAlbum!.id+"/photos?fields=images")) { httpResponse, result in
            switch result {
            case .success(let response):
                self.parsePhotos(response: response)
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    func parsePhotos(response: GraphRequest.Response){
        guard let responseDictionary = response.dictionaryValue else {
            return
        }
        guard let data: NSArray = responseDictionary["data"] as? NSArray else {
            return
        }
        
        for  index in 0..<data.count {
            let valueDict : NSDictionary = data[index] as! NSDictionary
            let id = valueDict.object(forKey: "id") as! String
            let images = valueDict.value(forKey: "images") as! NSArray
            let pictureUrl = (images[0] as! NSDictionary).value(forKey: "source") as! String
            let photo = Photo(id:id,url:pictureUrl)
            photos.append(photo)
        }
        collectionView.reloadData()
        hideSpinner()
    }
    
}

extension PhotosViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let photoUrl = photos[indexPath.row]
        cell.configure(photo: photoUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
