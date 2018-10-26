//
//  ViewController.swift
//  FaceBook Photos Exporting App
//
//  Created by Safoine Moncef Amine on 26/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showSpinner()
        if FBSDKAccessToken.currentAccessTokenIsActive() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.performSegue(withIdentifier: "showAlbums", sender: self)
                self.hideSpinner()
            })
        }else {
            UIView.animate(withDuration: 1) {
                self.hideSpinner()
            }
        }
    }
}
