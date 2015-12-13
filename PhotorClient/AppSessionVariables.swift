class AppSessionVariables {
    
    static let sharedInstance = AppSessionVariables()
    var user: User?

    
    // Singleton method
    private init() {}
}