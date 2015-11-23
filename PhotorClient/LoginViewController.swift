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
import SwiftyJSON

class LoginViewController: UIViewController {
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    var activeUser: User?
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // Go to profile, already logged in
            sendLoginRequestAndProcessResult(FBSDKAccessToken.currentAccessToken().userID, FBSDKAccessToken.currentAccessToken().tokenString)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showNew") {
            if (activeUser != nil) {
                let view = segue.destinationViewController as! ProfileViewController
                view.activeUser = activeUser
            }
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
        Alamofire.request(.GET, "http://localhost:4567/user/" + userId + "/login/" + token, headers: ["user_id": userId, "token": token]).responseJSON { response in
            if (response.result.isSuccess) {
                if let data: AnyObject = response.result.value {
                    print("User " + userId + " logged in with token " + token);
                    // TODO: (wbjacks) SEC!! check encoding in BE
                    self.activeUser = User(data: JSON(data))
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

