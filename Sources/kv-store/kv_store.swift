import Foundation

public actor KVStore {
    private var storage: [String: KVEntry] = [:]

    public init() {}

    public func set(_ key: String, value: Data) throws {
        guard !key.isEmpty else {
            throw KVError.invalidKey
        }

        let entry = KVEntry(key: key, value: value)
        storage[key] = entry
    }
}
