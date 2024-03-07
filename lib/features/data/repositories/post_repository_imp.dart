import 'package:crud_mobile_app/core/error/failures.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:crud_mobile_app/features/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Future<Either<Failure, List<Post>>> getPosts(int? amountRequested) {
    // TODO: implement getPosts
    throw UnimplementedError();
  }
}
