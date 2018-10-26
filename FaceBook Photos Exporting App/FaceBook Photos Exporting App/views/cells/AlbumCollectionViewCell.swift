//
//  AlbumCollectionViewCell.swift
//  FaceBook Photos Exporting App
//
//  Created by Safoine Moncef Amine on 26/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import UIKit
import SDWebImage

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumCoverImage: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var albumImagesCountLabel: UILabel!
    
    func configure(album : Album) {
        self.albumNameLabel.text = album.name
        self.albumImagesCountLabel.text = "\(album.countImages)"
        self.albumCoverImage.sd_setImage(with: URL(string: album.coverUrl), completed: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
