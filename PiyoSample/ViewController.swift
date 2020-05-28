//
//  ViewController.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/25.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import UIKit
import Piyo

class ViewController: UIViewController {

    @IBOutlet weak var oAuthButton: UIButton!    
    
    @IBAction func pushInOAuth(_ sender: Any) {                
        TwitterApi.oAuth()
    }
}

