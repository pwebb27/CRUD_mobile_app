import 'package:crud_mobile_app/core/failures.dart';
import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/features/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';

class GetPosts {
  final PostRepository repository;

  GetPosts(this.repository);
  Future<Either<Failure, List<Post>>> call({
    required int amountOfPostsRequested,
  }) async {
    return await repository.getPosts(amountOfPostsRequested);
  }
}
