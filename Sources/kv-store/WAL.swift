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
        data.append(operation.rawValue)

        let keyData = key.data(using: .utf8)!
        var keyLength = UInt32(keyData.count).bigEndian
        data.append(Data(bytes: &keyLength, count: 4))
        data.append(keyData)

        if let value = value {
            var valueLength = UInt32(value.count).bigEndian
            data.append(Data(bytes: &valueLength, count: 4))
            data.append(value)
        } else {
            var valueLength = UInt32(0).bigEndian
            data.append(Data(bytes: &valueLength, count: 4))
        }

        var ts = timestamp.bigEndian
        data.append(Data(bytes: &ts, count: 8))

        return data
    }

    static func deserialize(from data: Data, offset: inout Int) throws -> WALEntry? {
        guard offset < data.count else { return nil }

        guard offset + 1 <= data.count else {
            throw KVError.storageFailure("Incomplete operation byte")
        }
        let opByte = data[offset]
        offset += 1

        guard let operation = WALOperation(rawValue: opByte) else {
            throw KVError.storageFailure("Invalid WAL operation: \(opByte)")
        }

        guard offset + 4 <= data.count else {
            throw KVError.storageFailure("Incomplete key length")
        }
        let keylength
    }
}
