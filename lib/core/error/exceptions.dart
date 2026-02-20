abstract class AppExceptions implements Exception {
    final String message;
    final String prefix;
    const AppExceptions({required this.message, required this.prefix});

    @override
    String toString() {
        return '$prefix$message';
    }
}

// Network Exceptions
class NetworkException extends AppExceptions {
    const NetworkException({super.message = "No Internet Connection"})
        : super(prefix: 'Network Exception: ');
}

class TimeoutException extends AppExceptions {
    const TimeoutException({super.message = "Request Timeout"})
        : super(prefix: 'Timeout Exception: ');
}

// Server Exceptions
class ServerException extends AppExceptions {
    const ServerException({super.message = "Internal Server Error"})
        : super(prefix: 'Server Exception: ');
}
class BadRequestException extends AppExceptions {
    const BadRequestException({super.message = "Bad Request"})
        : super(prefix: 'Bad Request Exception: ');
}
class UnauthorizedException extends AppExceptions {
    const UnauthorizedException({super.message = "Unauthorized"})
        : super(prefix: 'Unauthorized Exception: ');
}
class ForbiddenException extends AppExceptions {
    const ForbiddenException({super.message = "Forbidden"})
        : super(prefix: 'Forbidden Exception: ');
}
class NotFoundException extends AppExceptions {
    const NotFoundException({super.message = "Not Found"})
        : super(prefix: 'Not Found Exception: ');
}
class RequestCancelledException extends AppExceptions {
    const RequestCancelledException({super.message = "Request Cancelled"})
        : super(prefix: 'Request Cancelled Exception: ');
}

// Cache Exceptions
class CacheException extends AppExceptions {
    const CacheException({super.message = "Cache Exception"})
        : super(prefix: 'Cache Exception: ');
}

// Authentication Exceptions
class AuthenticationException extends AppExceptions {
    const AuthenticationException({super.message = "Authentication Failed"})
        : super(prefix: 'Authentication Exception: ');
}
