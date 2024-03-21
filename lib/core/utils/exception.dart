class ServerException implements Exception {}

class MyAuthException implements Exception {
  final String message;

  MyAuthException(this.message);
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}

class LocalStorageException implements Exception {
  final String message;

  LocalStorageException(this.message);
}
