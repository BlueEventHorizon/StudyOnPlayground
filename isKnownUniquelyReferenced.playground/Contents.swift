import Foundation

/*
 isKnownUniquelyReferenced(_:) checks only for strong references to the given object—if object has additional weak or unowned references, the result may still be true. Because weak and unowned references cannot be the only reference to an object, passing a weak or unowned reference as object always results in false.
 If the instance passed as object is being accessed by multiple threads simultaneously, this function may still return true. Therefore, you must only call this function from mutating methods with appropriate thread synchronization. That will ensure that isKnownUniquelyReferenced(_:) only returns true when there is really one accessor, or when there is a race condition, which is already undefined behavior.
 */

class AA {
    
}

func start() {
    var strngRef = AA()
    weak var weakRef = strngRef

    // Returns a Boolean value indicating whether the given object is known to have a single strong reference.
    if isKnownUniquelyReferenced(&weakRef) {
        print("weakRef -> Known")
    } else {
        print("weakRef -> No Known")
    }
    
    if isKnownUniquelyReferenced(&strngRef) {
        print("strngRef -> Known")
    } else {
        print("strngRef -> No Known")
    }
}

start()

