enum CartAction {
  increment,
  decrement;

  String toJson() {
    return switch (this) {
      CartAction.increment => 'increment',
      CartAction.decrement => 'decrement',
    };
  }

  static CartAction fromJson(String action) {
    return switch (action.toLowerCase()) {
      'increment' => CartAction.increment,
      'decrement' => CartAction.decrement,
      _ => throw ArgumentError('Invalid cart action: $action'),
    };
  }
}
