class CounterEntity {
  final List<int> values;

  const CounterEntity({required this.values});

  int get current => values.last;

  CounterEntity increment() {
    return CounterEntity(values: [...values, current + 1]);
  }
}
