import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}
// General failure

class ServerFailure implements Failure {}

class CacheFailure implements Failure {}
