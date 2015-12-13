//
//  SignUpViewController.swift
//  PhotorClient
//
//  Created by Will Jackson on 11/26/27 H.
//  Copyright © 27 Heisei Will Jackson. All rights reserved.
//

import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit
import Foundation
import SwiftyJSON
import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var handleField: UITextField!
    
    @IBAction func sendSignUpRequest(sender: UIButton) {
        /* Repeated request... */
        let facebookData:[String:String] = ["user_id": FBSDKAccessToken.currentAccessToken().userID, "token": FBSDKAccessToken.currentAccessToken().tokenString]
        let payloadData: [String:String] = ["user_id": FBSDKAccessToken.currentAccessToken().userID, "token": FBSDKAccessToken.currentAccessToken().tokenString, "handle": handleField.text!]
        Alamofire.request(.POST, "http://localhost:4567/signUp", headers: facebookData, parameters: payloadData, encoding:.JSON).responseJSON { response in
            if (response.result.isSuccess) {
                if let data: AnyObject = response.result.value {
                    // TODO: (wbjacks) SEC!! check encoding in BE
                    AppSessionVariables.sharedInstance.user = User(data: JSON(data))
                    print("User " + (AppSessionVariables.sharedInstance.user?.handle)! + " signed up.");
                    self.performSegueWithIdentifier("showProfile", sender: self);
                }
            }
            else {
                print("User failed to log in with error:" + response.result.error!.description);
                // TODO: Error condition?
            }
        }
    }
}