//
//  ViewController.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/25.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var oAuthButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pushInOAuth(_ sender: Any) {
        
        let http = HttpClient()
        http.oAuth()
        print ("Push in OAuth")
    }
    
}

