import 'dart:convert';

import 'package:crud_mobile_app/features/data/datasources/post_local_data_source.dart';
import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/test/fixtures/fixture_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {
  void main() {
    late PostsLocalDataSourceImp dataSource;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      dataSource =
          PostsLocalDataSourceImp(sharedPreferences: mockSharedPreferences);
    });
    group('getLastPosts', () {
      final tPostModel = PostModel.fromRealTimeDatabase(
          jsonPost: json.decode(fixture('posts_cached.json')), key: '1234');
      test(
        'should return Posts from SharedPreferences when there is one in the cache',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture('posts_cached.json'));
          // act
          final result = await dataSource.getLastPosts();
          // assert
          verify(mockSharedPreferences.getString(CACHED_POSTS));
          expect(result, equals(tPostModel));
          verifyNoMoreInteractions(mockSharedPreferences);
        },
      );
    });
  }
}
