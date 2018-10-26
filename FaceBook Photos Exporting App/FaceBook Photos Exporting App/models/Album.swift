//
//  Album.swift
//  FaceBook Photos Exporting App
//
//  Created by Safoine Moncef Amine on 26/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import Foundation

struct Album : Codable {
    let id : String
    let name : String
    let coverUrl : String
    let countImages : Int
}
