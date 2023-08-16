class ServerException implements Exception {}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}

class LocalStorageException implements Exception {
  final String message;

  LocalStorageException(this.message);
}
