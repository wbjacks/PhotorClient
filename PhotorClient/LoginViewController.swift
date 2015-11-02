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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in");
        }
        else {
            // Go to profile, already logged in
            print("performing segue")
            self.performSegueWithIdentifier("showNew", sender: self);
        }
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error == nil) {
            print("login complete");

            Alamofire.request(.GET, "http://localhost:4567/user/" + result.token.userID + "/login/" + result.token.tokenString).responseData { response in
                    switch(response.result) {
                        case .Success(_):
                            print("User " + result.token.userID + " logged in with short token " + result.token.tokenString);
                            self.performSegueWithIdentifier("showNew", sender: self);
                        case .Failure(_):
                            print("User failed to log in");
                            // TODO: Error condition?
                    }
                }
        }
        else {
            print(error.localizedDescription);
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
}

