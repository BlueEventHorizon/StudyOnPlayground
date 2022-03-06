import UIKit

protocol A {}
class B {}

func test<T>(typeof theType: T.Type) {
    switch theType {
        case is A.Type:
            print("found A")
            
        case is B.Type:
            print("found B")

        default:
            print("not found")
    }
}

test(typeof: A.self)
test(typeof: B.self)
