import Foundation
import kv_store

@main
struct CLI {
    static func main() async {
        let store = KVStore()

        print("KVStore CLI - Manual Testing")
        print(
            "Commands: set <key> <value>, get <key>, delete <key>, exists <key>, keys, stats, clear, exit"
        )
        print()

        while true {
            print("> ", terminator: "")
            guard let line = readLine()?.trimmingCharacters(in: .whitespaces) else {
                continue
            }

            if line.isEmpty { continue }

            let parts = line.split(separator: " ", maxSplits: 2).map(String.init)
            let command = parts[0].lowercased()

            do {
                switch command {
                case "set":
                    guard parts.count == 3 else {
                        print("Usage: set <key> <value>")
                        continue
                    }
                    let key = parts[1]
                    let value = parts[2].data(using: .utf8)!
                    try await store.set(key, value: value)
                    print("OK")

                case "get":
                    guard parts.count == 2 else {
                        print("Usage: get <key>")
                        continue
                    }
                    let key = parts[1]
                    let value = try await store.get(key)
                    if let str = String(data: value, encoding: .utf8) {
                        print("\"\(str)\"")
                    } else {
                        print("Binary data: \(value.count) bytes")
                    }

                case "delete":
                    guard parts.count == 2 else {
                        print("Usage: delete <key>")
                        continue
                    }
                    let key = parts[1]
                    let value = try await store.delete(key)
                    if let str = String(data: value, encoding: .utf8) {
                        print("Deleted: \"\(str)\"")
                    } else {
                        print("Deleted: \(value.count) bytes")
                    }

                case "exists":
                    guard parts.count == 2 else {
                        print("Usage: exists <key>")
                        continue
                    }
                    let key = parts[1]
                    let exists = await store.exists(key)
                    print(exists ? "true" : "false")

                case "keys":
                    let keys = await store.keys()
                    if keys.isEmpty {
                        print("(empty)")
                    } else {
                        for key in keys.sorted() {
                            print("  \(key)")
                        }
                    }

                case "stats":
                    let stats = await store.stats()
                    print("Keys: \(stats.keyCount)")
                    print("Memory: \(stats.memoryBytes) bytes")

                case "clear":
                    await store.clear()
                    print("OK")

                case "exit", "quit":
                    print("Bye")
                    return

                case "help":
                    print("Commands:")
                    print("  set <key> <value>  - Store a key-value pair")
                    print("  get <key>          - Retrieve value for key")
                    print("  delete <key>       - Delete key")
                    print("  exists <key>       - Check if key exists")
                    print("  keys               - List all keys")
                    print("  stats              - Show statistics")
                    print("  clear              - Remove all keys")
                    print("  exit               - Quit")

                default:
                    print("Unknown command: \(command)")
                    print("Type 'help' for commands")
                }
            } catch KVError.keyNotFound(let key) {
                print("Error: Key not found: \(key)")
            } catch KVError.invalidKey {
                print("Error: Invalid key")
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
