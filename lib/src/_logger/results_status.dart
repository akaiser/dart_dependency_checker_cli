enum ResultsStatus {
  clear._(0),
  warning._(1),
  error._(2);

  const ResultsStatus._(this.exitCode);

  final int exitCode;
}
