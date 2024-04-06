import 'package:crud_mobile_app/features/data/datasources/post_local_data_source.dart';
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
  }
}
