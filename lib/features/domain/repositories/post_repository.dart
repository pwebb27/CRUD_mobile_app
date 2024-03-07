import 'package:crud_mobile_app/core/error/failures.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts(int? amountRequested);
}
