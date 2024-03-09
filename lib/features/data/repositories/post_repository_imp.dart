import 'package:crud_mobile_app/core/error/failures.dart';
import 'package:crud_mobile_app/core/platform/network_info.dart';
import 'package:crud_mobile_app/features/data/datasources/post_local_data_source.dart';
import 'package:crud_mobile_app/features/data/datasources/post_remote_data_source.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:crud_mobile_app/features/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, List<Post>>> getPosts(int? amountRequested) {
    networkInfo.isConnected;
    throw UnimplementedError();
  }
}
