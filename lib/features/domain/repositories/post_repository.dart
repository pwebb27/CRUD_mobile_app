import 'package:crud_mobile_app/core/failures.dart';
import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:dartz/dartz.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts(int? amountRequested);
}
