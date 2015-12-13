import Foundation
import SwiftyJSON
import FBSDKLoginKit

struct User {
    let id: Int64
    let handle: String
    //let createdAt: NSDate
    var firstName: String?
    var lastName: String?
    var facebookUserId: String? {
        return FBSDKAccessToken.currentAccessToken().userID
    }
    var facebookUserToken: String? {
        return FBSDKAccessToken.currentAccessToken().tokenString
    }
    
    init(data: JSON) {
        self.id = data["id"].int64Value // TODO: (wbjacks) right...?
        self.handle = data["handle"].stringValue
//        self.createdAt = NSDate(timeIntervalSince1970: data["created_at"].doubleValue)
        self.firstName = data["firstName"].stringValue
        self.lastName = data["lastName"].stringValue
    }
    
    // TODO: (wbjacks) what will happen if these aren't present
    func getSecurityHeaders() -> [String:String] {
        return ["user_id": facebookUserId!, "token": facebookUserToken!]
    }
}