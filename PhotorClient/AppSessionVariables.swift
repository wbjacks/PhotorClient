class AppSessionVariables {
    
    static let sharedInstance = AppSessionVariables()
    var user: User?
    
    func getSecurityHeaders() -> [String:String] {
        return ["user_id": (user?.facebookUserId)!, "token": (user?.facebookUserToken)!]
    }
    
    // Singleton method
    private init() {}
}