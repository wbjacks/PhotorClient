//
//  ViewController.swift
//  PhotorClient
//
//  Created by Will Jackson on 10/12/27 H.
//  Copyright © 27 Heisei Will Jackson. All rights reserved.
//

import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import UIKit

class LoginViewController: UIViewController {
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // Go to profile, already logged in
            sendLoginRequestAndProcessResult(FBSDKAccessToken.currentAccessToken().userID, FBSDKAccessToken.currentAccessToken().tokenString)
        }
    }
    
    @IBAction func doFacebookLogin(sender: UIButton) {
        FBSDKLoginManager().logInWithReadPermissions(self.facebookReadPermissions, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if (error != nil) {
                FBSDKLoginManager().logOut();
                // TODO: (wbjacks) handle error
            }
            else if (result.isCancelled) {
                FBSDKLoginManager().logOut();
                // TODO: (wbjacks) Handle cancellations
            }
            else {
                self.sendLoginRequestAndProcessResult(result.token.userID, result.token.tokenString);
            }
        })
    }
    
    private func sendLoginRequestAndProcessResult(userId: String, _ token: String) {
        // TODO: (wjacks) assuming all permissions granted- maybe check them?
        Alamofire.request(.POST, "http://localhost:4567/user/" + userId + "/login/" + token, headers: AppSessionVariables.sharedInstance.getSecurityHeaders()).responseJSON { response in
            if (response.result.isSuccess) {
                if let data: AnyObject = response.result.value {
                    print("User " + userId + " logged in with token " + token);
                    // TODO: (wbjacks) SEC!! check encoding in BE
                    AppSessionVariables.sharedInstance.user = User(data: JSON(data))
                    self.performSegueWithIdentifier("showNew", sender: self);
                }
            }
            else {
                print("User failed to log in with error:" + response.result.error!.description);
                // TODO: Error condition?
            }
        }
    }
    
}

