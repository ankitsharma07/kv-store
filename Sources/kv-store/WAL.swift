import CryptoKit
import Foundation

enum WALOperation: UInt8 {
    case set = 1
    case delete = 2
}

struct WALEntry {
    let operation: WALOperation
    let key: String
    let value: Data?
    let timestamp: UInt64

    func serialize() -> Data {
        var data = Data()
    }
}
