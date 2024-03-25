import 'package:crud_mobile_app/core/error/exceptions.dart';
import 'package:crud_mobile_app/core/error/failures.dart';
import 'package:crud_mobile_app/core/platform/network_info.dart';
import 'package:crud_mobile_app/features/data/datasources/post_local_data_source.dart';
import 'package:crud_mobile_app/features/data/datasources/post_remote_data_source.dart';
import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/features/data/repositories/post_repository_imp.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements PostRemoteDataSource {}

class MockLocalDataSource extends Mock implements PostLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late PostRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PostRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getPosts', () {
    final tAmountRequested = 1;
    final tPostModels = [
      PostModel(
          key: '1234',
          name: 'Test Name',
          message: 'Test message',
          timestamp: 1234)
    ];
    final List<Post> tPosts = tPostModels;
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getPosts(tAmountRequested);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
        'should return remote Data when the call to remote data source is success',
        () async {
          // arrange
          when(mockRemoteDataSource.getPosts(any))
              .thenAnswer((_) async => tPostModels);
          // act
          final result = await repository.getPosts(tAmountRequested);
          // assert
          verify(mockRemoteDataSource.getPosts(tAmountRequested));
          expect(result, Right(tPosts));
        },
      );
    });
    test(
      'should cache the data locally when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPosts(any))
            .thenAnswer((_) async => tPostModels);
        // act
        await repository.getPosts(tAmountRequested);
        // assert
        (mockRemoteDataSource.getPosts(tAmountRequested));
        verify(mockLocalDataSource.cachePosts(tPostModels));
      },
    );
    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPosts(any)).thenThrow(ServerException());
        // act
        final result = await repository.getPosts(tAmountRequested);
        // assert
        verify(mockRemoteDataSource.getPosts(tAmountRequested));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      },
    );
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastPosts())
              .thenAnswer((_) async => tPostModels);
          // act
          final result = await repository.getPosts(tAmountRequested);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastPosts());
          expect(result, equals(Right(tPosts)));
        },
      );
    });
  });
}
