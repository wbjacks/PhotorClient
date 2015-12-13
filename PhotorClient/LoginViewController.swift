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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            Alamofire.request(.GET, "http://localhost:4567/checkUserSignedUp", parameters: AppSessionVariables.sharedInstance.user?.getSecurityHeaders(), headers: AppSessionVariables.sharedInstance.user?.getSecurityHeaders()).responseString() { response in
                
                if (response.result.value == "true") {
                    self.sendLoginRequestAndProcessResult(FBSDKAccessToken.currentAccessToken().userID, FBSDKAccessToken.currentAccessToken().tokenString)
                }
            }
        }
        /*
        else {
            self.performSegueWithIdentifier("showSignUp", sender: self)
        }
        */
    }
    
    @IBAction func doSignUp(sender: UIButton) {
        doFacebookLogin() {(_: String, _: String) in
            self.performSegueWithIdentifier("showSignUp", sender: self)
        }
    }
    
    @IBAction func doLogin(sender: UIButton) {
        doFacebookLogin(sendLoginRequestAndProcessResult);
    }
    
    private func doFacebookLogin(callback: (String, String) -> Void) {
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
                callback(result.token.userID, result.token.tokenString);
            }
        })
    }
    
    private func sendLoginRequestAndProcessResult(userId: String, _ token: String) {
        // TODO: (wjacks) assuming all permissions granted- maybe check them?
        let data: [String:String] = ["user_id": userId, "token": token]
        Alamofire.request(.POST, "http://localhost:4567/loginUser", headers: data, parameters: data, encoding:.JSON).responseJSON { response in
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
                if (response.response?.statusCode == 401) {
                    self.performSegueWithIdentifier("showSignUp", sender: self)
                }
            }
        }
    }
}

