class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'Resource not found']);

  @override
  String toString() => 'NotFoundException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = 'Unauthorized access']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class BadRequestException implements Exception {
  final String message;

  BadRequestException([this.message = 'Bad request']);

  @override
  String toString() => 'BadRequestException: $message';
}

class InternalServerErrorException implements Exception {
  final String message;

  InternalServerErrorException([this.message = 'Internal server error']);

  @override
  String toString() => 'InternalServerErrorException: $message';
}

class ConflictException implements Exception {
  final String message;

  ConflictException([this.message = 'Conflict error']);

  @override
  String toString() => 'ConflictException: $message';
}

class ForrbidenException implements Exception {
  final String message;

  ForrbidenException([this.message = 'Forbidden access']);

  @override
  String toString() => 'ForrbidenException: $message';
}


class AuthException implements Exception {
  final String message;

  AuthException([this.message = 'Auth error']);

  @override
  String toString() => 'NotFoundException: $message';
}
