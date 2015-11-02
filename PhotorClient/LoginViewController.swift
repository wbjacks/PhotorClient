//
//  ViewController.swift
//  PhotorClient
//
//  Created by Will Jackson on 10/12/27 H.
//  Copyright © 27 Heisei Will Jackson. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire

class LoginViewController: UIViewController {
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // Go to profile, already logged in
            print("performing segue")
            self.performSegueWithIdentifier("showNew", sender: self);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doFacebookLogin(sender: UIButton) {
        FBSDKLoginManager().logInWithReadPermissions(self.facebookReadPermissions, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if (error != nil) {
                FBSDKLoginManager().logOut()
                // TODO: (wbjacks) handle error
            }
            else if (result.isCancelled) {
                FBSDKLoginManager().logOut()
                // TODO: (wbjacks) Handle cancellations
            }
            else {
                // TODO: (wjacks) assuming all permissions granted- maybe check them?
                Alamofire.request(.GET, "http://localhost:4567/user/" + result.token.userID + "/login/" + result.token.tokenString).responseData { response in
                    switch(response.result) {
                    case .Success(_):
                        print("User " + result.token.userID + " logged in with token " + result.token.tokenString);
                        self.performSegueWithIdentifier("showNew", sender: self);
                    case .Failure(_):
                        print("User failed to log in");
                        // TODO: Error condition?
                    }
                }
            }
        })
    }
    
}

