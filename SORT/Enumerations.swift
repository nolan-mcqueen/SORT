

import Foundation

enum Result<T> {
    case failure(Error)
    case success([T])
}

//enum Error: Error {
//    case unitTest
//}

