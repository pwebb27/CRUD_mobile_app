import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:crud_mobile_app/features/domain/repositories/post_repository.dart';
import 'package:crud_mobile_app/features/domain/usecases/get_posts.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPosts usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetPosts(mockPostRepository);
  });

  const tAmountOfPostsRequested = 1;
  final tPosts = [
    const Post(
        key: 'testKey',
        name: 'testName',
        message: 'testMessage',
        timestamp: 123456)
  ];

  test(
    'should get posts from the repository',
    () async {
      // arrange
      when(mockPostRepository.getPosts(any))
          .thenAnswer((_) async => Right(tPosts));
      // act
      final result = await usecase(
          Params(amountofPostsRequested: tAmountOfPostsRequested));

      expect(result, Right(tPosts));
      verify(mockPostRepository.getPosts(tAmountOfPostsRequested));
      verifyNoMoreInteractions(mockPostRepository);
      // assert
    },
  );
}
