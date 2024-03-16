import 'package:crud_mobile_app/features/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts(int? amountRequested);
}
