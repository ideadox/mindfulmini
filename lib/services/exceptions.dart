// ignore_for_file: use_super_parameters

class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);
  String get message => _message ?? '';
  @override
  String toString() {
    return "${_prefix ?? ""}${_message ?? ""}";
  }
}

class FetchDataException extends AppException {
  FetchDataException([super.message]);
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message);
}

class TimeoutException extends AppException {
  TimeoutException([message]) : super(message);
}

class InvalidInputException extends AppException {
  InvalidInputException([super.message]);
}

class LocalDatabaseError extends AppException {
  LocalDatabaseError([super.message]);
}

class ResolveError {
  static String resolve(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Oops, an account already exists with this email. Try signing in.';
      case 'invalid-email':
        return 'Oops, Invalid email and password';
      case 'weak-password':
        return 'Oops, the password is not strong enough';
      case 'too-many-requests':
        return 'Oops, too many requests. Try again later';
      case 'network-request-failed':
        return 'Oops, no internet connection/slow internet';
      case 'invalid-verification-code':
        return 'Incorrect code. Please recheck and enter the correct OTP.';
      case 'invalid-verification-id':
        return 'Something went wrong, Please retry the process';
      case 'wrong-password':
        return 'Oops, Invalid email and password';
      case 'user-not-found':
        return 'Oops, the email does not match any account. Try creating an account instead of signing in.';
      case 'user-disabled':
        return 'Oops, the email does not match any account. Try creating an account instead of signing in.';
      case 'invalid-credential':
        return 'Oops, Invalid email and password';
      default:
        return 'Something went worng, Please try again';
    }
  }
}
