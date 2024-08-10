//Login Exception

class InvalidCredentialAuthException implements Exception {}

//Register Exception

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

//Common Login and Register Exception

class InvalidEmailAuthException implements Exception {}

class ChannelErrorAuthException implements Exception {}

//Generic Exception

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

//others
class NotInitializedAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}
