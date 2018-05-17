import Foundation

public class Test{
    
    var t: String!
    
    public init(t: String){
        self.t = t
    }
    
    public func getT() -> String{
        return t
    }
    
    public func set(newT t: String){
        self.t = t
    }
}
