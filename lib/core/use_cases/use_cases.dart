import 'package:news_app/core/utils/utils.dart';

abstract class FutureUseCaseWithParams<Type, Params> {
  const FutureUseCaseWithParams();

  ResultFuture<Type> call(Params params);
}

abstract class FutureUseCaseWithoutParams<Type> {
  const FutureUseCaseWithoutParams();

  ResultFuture<Type> call();
}

abstract class StreamUseCaseWithoutParams<Type> {
  const StreamUseCaseWithoutParams();

  ResultStream<Type> call();
}

abstract class StreamUseCaseWithParams<Type, Params> {
  const StreamUseCaseWithParams();

  ResultStream<Type> call(Params params);
}
