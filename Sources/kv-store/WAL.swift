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
        let keyLength = Int(
            data[offset..<offset + 4].withUnsafeBytes { $0.load(as: UInt32.self).bigEndian })
        offset += 4

        guard offset + keyLength <= data.count else {
            throw KVError.storageFailure("Incomplete key data")
        }

        guard let key = String(data: data[offset..<offset + keyLength], encoding: .utf8) else {
            throw KVError.storageFailure("Invalid key encoding")
        }

        offset += keyLength

        guard offset + 4 <= data.count else {
            throw KVError.storageFailure("Incomplete value length")
        }
        let valueLength = Int(
            data[offset..<offset + 4].withUnsafeBytes { $0.load(as: UInt32.self).bigEndian })
        offset += 4

        guard offset + valueLength <= data.count else {
            throw KVError.storageFailure("Incomplete value data")
        }

        let value = data[offset..<offset + valueLength]

        offset += valueLength

        return WALEntry(operation: operation, key: key, value: value, timestamp: ts)
    }
}
