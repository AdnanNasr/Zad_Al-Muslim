abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = "Server Failure"]);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = "Cache Failure"]);
}

class LocationFailure extends Failure {
  LocationFailure([super.message = "Location Failure"]);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = "Network Failure"]);
}