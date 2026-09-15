/// Minimal in-project replacement for an `Either<F, S>` type, used instead
/// of a functional-programming package (e.g. dartz, fpdart) so repositories
/// can return typed success/failure results without throwing.
sealed class Result<F, S> {
  const Result();

  bool get isSuccess => this is ResultSuccess<F, S>;

  bool get isFailure => this is ResultFailure<F, S>;

  T fold<T>(T Function(F failure) onFailure, T Function(S success) onSuccess) {
    return switch (this) {
      ResultFailure<F, S>(:final value) => onFailure(value),
      ResultSuccess<F, S>(:final value) => onSuccess(value),
    };
  }
}

final class ResultSuccess<F, S> extends Result<F, S> {
  const ResultSuccess(this.value);

  final S value;
}

final class ResultFailure<F, S> extends Result<F, S> {
  const ResultFailure(this.value);

  final F value;
}
