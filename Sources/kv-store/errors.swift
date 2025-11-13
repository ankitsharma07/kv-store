public enum KVError: Error {
    case keyNotFound(String)
    case invalidKey
    case storageFailure(String)
}
