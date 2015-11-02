//
//  ProfileViewController.swift
//  PhotorClient
//
//  Created by Will Jackson on 10/27/27 H.
//  Copyright © 27 Heisei Will Jackson. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBAction func logOutButtonClicked(sender: UIButton) {
        FBSDKLoginManager().logOut();
        self.performSegueWithIdentifier("userLoggedOut", sender: self);
    }
}