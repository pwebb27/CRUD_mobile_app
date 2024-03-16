import 'dart:convert';

import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:crud_mobile_app/test/fixtures/fixture_reader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tPostModel = PostModel(
      key: '1234', name: 'Test Name', message: 'Test message', timestamp: 1234);

  test(
    'should be a subclass of Post entity',
    () async {
      // arrange
      expect(tPostModel, isA<Post>());
      // act

      // assert
    },
  );
  group('fromJson', () {
    test(
      'should return a valid Post model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('post.json'));
        const testKey = '1234';

        // act
        final result =
            PostModel.fromRealTimeDatabase(jsonPost: jsonMap, key: testKey);

        expect(result, tPostModel);
        // assert
      },
    );
    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // arrange
          final result = tPostModel.toJson();
          // act
          final expectedMap = {
            {
              'key': '1234',
              'name': 'Test Name',
              'message': 'Test message',
              'timestamp': '1234'
            }
          };
          // assert
          expect(result, expectedMap);
        },
      );
    });
  });
}
