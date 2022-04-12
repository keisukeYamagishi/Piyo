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

    @IBAction func pushInOAuth(_ sender: Any) {
        TwitterApi.oAuth()
    }
    
    @IBAction func beareToken(_ sender: Any) {
        TwitterApi.beare()
    }
    
}
