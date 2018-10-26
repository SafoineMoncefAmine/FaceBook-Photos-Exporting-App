//
//  AlbumsViewController.swift
//  FaceBook Photos Exporting App
//
//  Created by Safoine Moncef Amine on 26/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit

class AlbumsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albums : [Album] = []
    var selectedAlbumIndex = 0
    override func viewDidLoad() {
        configure()
        getMyAlbums()
    }
    
    func configure() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        let width = (view.frame.size.width - 10) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    func getMyAlbums(){
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me/albums?fields=cover_photo,picture,name,count")) { httpResponse, result in
            switch result {
            case .success(let response):
                self.parseAlbums(response: response)
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    func parseAlbums(response: GraphRequest.Response){
        guard let responseDictionary = response.dictionaryValue else {
            return
        }
        guard let data: NSArray = responseDictionary["data"] as? NSArray else {
            return
        }
        
        for  index in 0..<data.count {
            let valueDict : NSDictionary = data[index] as! NSDictionary
            let id = valueDict.object(forKey: "id") as! String
            let count = valueDict.object(forKey: "count") as! NSNumber
            let name = valueDict.object(forKey: "name") as! String
            let pictureUrl = ((valueDict.object(forKey: "picture") as! NSDictionary)
                .object(forKey: "data") as! NSDictionary)
                .object(forKey: "url") as! String
            let album = Album(id:id,name:name,coverUrl:pictureUrl,countImages:Int(count))
            albums.append(album)
        }
        albums = albums.sorted(by: {$0.name < $1.name})
        collectionView.reloadData()
        hideSpinner()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlbumPhotos" {
            let vc = segue.destination as! PhotosViewController
            vc.selectedAlbum = self.albums[selectedAlbumIndex]
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        self.showSpinner()
        UIView.animate(withDuration: 1) {
            self.dismiss(animated: true, completion: nil)
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
    }
}

extension AlbumsViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        let album = albums[indexPath.row]
        cell.configure(album: album)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedAlbumIndex = indexPath.row
        performSegue(withIdentifier: "showAlbumPhotos", sender: self)
    }
    
}
