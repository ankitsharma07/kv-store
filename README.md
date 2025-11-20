This is a simple key-value store implementation in Swift.

To run the executable, navigate to the project directory and execute the following command:

```
swift build
```
then,
```
swift run kv-store-cli
```

Examples:
```
> set user:1 Alice
OK
> set user:2 Bob
OK
> set user:3 Alex
> get user:1
"Alice"
> keys
  user:1
  user:2
> stats
Keys: 2
Memory: 27 bytes
> exists user:3
false
> delete user:1
Deleted: "Alice"
> keys
  user:2
> clear
OK
> exit
Bye
```
