import Foundation
import JSONHelper

struct User: Deserializable {
    var id: Int? // TODO: (wbjacks) BE is long, will this be an issue?
    var handle: String?
    var createdAt: NSDate?
    var firstName: String?
    var lastName: String?
    
    init(data: [String: AnyObject]) {
        id <-- data["id"]
        handle <-- data["handle"]
        createdAt <-- data["created_at"]
        firstName <-- data["firstName"]
        lastName <-- data["lastName"]
    }
}