//
//  ViewController-Spinner.swift
//  FaceBook Photos Exporting App
//
//  Created by Safoine Moncef Amine on 26/10/2018.
//  Copyright © 2018 Safoine Moncef Amine. All rights reserved.
//

import SVProgressHUD

internal extension UIViewController {
    func showSpinner(status: String? = nil){
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: status)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setBackgroundLayerColor(UIColor.blue)
        }
    }
    func hideSpinner(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    func toast(duration: TimeInterval, message: String) {
        SVProgressHUD.showInfo(withStatus: message)
        SVProgressHUD.dismiss(withDelay: duration)
    }
}
