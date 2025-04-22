import '../service/services.dart';

class LoginController {
  final LoginService loginService;
  String? token; // Changed to nullable to better represent uninitialized state

  LoginController({LoginService? service})
      : loginService = service ?? LoginService();

  Future<dynamic> getToken(String code) async {
    try {
      var response = await loginService.getToken(code);
      
      token = response; // Store the token
      return response; // Return the token directly
    } catch (e) {
      // Consider using a proper logging solution instead of print
      print("Error fetching token: $e");

      // Re-throw a more specific exception or return a Failure object
      throw TokenFetchException("Failed to obtain token", e);
    }
  }
}

// Custom exception class for better error handling
class TokenFetchException implements Exception {
  final String message;
  final dynamic innerException;

  TokenFetchException(this.message, [this.innerException]);

  @override
  String toString() =>
      'TokenFetchException: $message${innerException != null ? '\nCaused by: $innerException' : ''}';
}
