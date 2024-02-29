import 'package:crud_mobile_app/core/failures.dart';
import 'package:crud_mobile_app/core/usecases/usecases.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:crud_mobile_app/features/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetPosts implements UseCase<List<Post>, Params> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(
    Params params,
  ) async {
    return await repository.getPosts(params.amountofPostsRequested);
  }
}

class Params extends Equatable {
  final int amountofPostsRequested;
  const Params({required this.amountofPostsRequested});

  @override
  List<Object> get props => [];
}
