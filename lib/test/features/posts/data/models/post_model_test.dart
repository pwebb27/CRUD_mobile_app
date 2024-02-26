import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tPostModel = PostModel('123', 'Test Name', 'Test message', 123);

  test(
    'should be a subclass of Post entity',
    () async {
      // arrange
      expect(tPostModel, isA<Post>());
      // act

      // assert
    },
  );
}
