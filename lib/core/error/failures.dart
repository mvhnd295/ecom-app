import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
    final String message;
    final int? code;
    const Failure({required this.message, this.code});
    
    @override
    List<Object?> get props => [message, code];
}

// Network Failures
class NetworkFailure extends Failure {
    const NetworkFailure({super.message = "Network Error", super.code});
}

// Server Failures
class ServerFailure extends Failure {
    const ServerFailure({super.message = "Server Error", super.code});
}

// Cache Failures
class CacheFailure extends Failure {
    const CacheFailure({super.message = "Cache Error", super.code});
}

// Authentication Failures
class AuthenticationFailure extends Failure {
    const AuthenticationFailure({super.message = "Authentication Failed", super.code});
}

// Validation Failures
class ValidationFailure extends Failure {
    const ValidationFailure({super.message = "Validation Failed", super.code});
}

// Permission Failures
class PermissionFailure extends Failure {
    const PermissionFailure({super.message = "Permission Denied", super.code});
}

// Input Failure
class InputFailure extends Failure {
    const InputFailure({super.message = "Invalid Input", super.code});
}

// Unauthorized Failures
class UnauthorizedFailure extends Failure {
    const UnauthorizedFailure({super.message = "Unauthorized", super.code});
}

// Unknown Failures
class UnknownFailure extends Failure {
    const UnknownFailure({super.message = "Unknown Error", super.code});
}