import Foundation

public struct KVEntry: Sendable {
    public let key: String
    public let value: Data
    public let timestamp: UInt64

    public init(
        key: String, value: Data, timestamp: UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.key = key
        self.value = value
        self.timestamp = timestamp
    }
}

public struct KVStats: Sendable {
    public let keyCount: Int
    public let memoryBytes: Int

    public init(keyCount: Int, memoryBytes: Int) {
        self.keyCount = keyCount
        self.memoryBytes = memoryBytes
    }
}
