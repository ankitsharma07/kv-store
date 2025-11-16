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

    public func get(_ key: String) throws -> Data {
        guard let entry = storage[key] else {
            throw KVError.keyNotFound(key)
        }
        return entry.value
    }

    public func delete(_ key: String) throws {
        guard let entry = storage.removeValue(forKey: key) else {
            throw KVError.keyNotFound(key)
        }

        return entry.value
    }

    public func exists(_ key: String) -> Bool {
        return storage[key] != nil
    }

    public func keys() -> [String] {
        return Array(storage.keys)
    }

    public func clear() {
        storage.removeAll()
    }

    public func stats() -> KVStats {
        let keyCount = storage.count
        let memoryBytes = storage.values.reduce(0) { sum, entry in
            sum + entry.key.utf8.count + entry.value.count + MemoryLayout<UInt64>.size
        }

        return KVStats(keyCount: keyCount, memoryBytes: memoryBytes)
    }
}
