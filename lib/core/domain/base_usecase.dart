
abstract class UseCase<R, Params> {
  R _repository;

  UseCase(this._repository);

  R get repository => _repository;

  void execute(Params params);

  void dispose();
}