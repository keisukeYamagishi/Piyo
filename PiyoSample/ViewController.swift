//
//  ViewController.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/25.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import Piyo
import UIKit

class ViewController: UIViewController {
    @IBOutlet var checkImageView: UIImageView!
    @IBOutlet var beareTokenLabel: UILabel!
    @IBOutlet var accessTokenLabel: UILabel!
    @IBOutlet var accessTokenStatusIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkImageView.alpha = 0.0
        accessTokenStatusIcon.alpha = 0.0

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.accessTokenHandler = { token in
            DispatchQueue.main.async {
                self.accessTokenLabel.text = token
                self.accessTokenStatusIcon.alpha = 1.0
            }
        }
    }

    @IBAction func pushInOAuth(_: Any) {
        TwitterApi.oAuth()
    }

    @IBAction func beareToken(_: Any) {
        TwitterApi.beare { beareToken in
            self.beareTokenLabel.text = beareToken
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.checkImageView.alpha = 1.0
            }
        }
    }
}
