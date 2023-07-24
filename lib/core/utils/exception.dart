class ServerException implements Exception {}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}

class LocalStorageException implements Exception {
  final String message;

  LocalStorageException(this.message);
}
