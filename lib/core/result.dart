sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;
  @override
  int get hashCode => value.hashCode;
}

final class Failure<T> extends Result<T> {
  final Object error;
  final StackTrace? stackTrace;
  const Failure(this.error, [this.stackTrace]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;
  @override
  int get hashCode => error.hashCode;
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  T? get valueOrNull => switch (this) {
    Success(value: final v) => v,
    Failure() => null,
  };
  Object? get errorOrNull => switch (this) {
    Success() => null,
    Failure(error: final e) => e,
  };
  R when<R>({
    required R Function(T value) success,
    required R Function(Object error, StackTrace? stackTrace) failure,
  }) {
    return switch (this) {
      Success(value: final v) => success(v),
      Failure(error: final e, stackTrace: final s) => failure(e, s),
    };
  }

  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success(value: final v) => Success(transform(v)),
      Failure(error: final e, stackTrace: final s) => Failure(e, s),
    };
  }

  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    return switch (this) {
      Success(value: final v) => transform(v),
      Failure(error: final e, stackTrace: final s) => Failure(e, s),
    };
  }
}
