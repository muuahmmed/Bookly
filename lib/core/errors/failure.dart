abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServiceException extends Failure {
  ServiceException(String message) : super(message);
}
class CacheException extends Failure {
  const CacheException(super.message);
}

class NetworkException extends Failure {
  const NetworkException(super.message);
}
