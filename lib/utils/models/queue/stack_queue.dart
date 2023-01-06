import 'package:path_finder/utils/models/queue/queue.dart';

class StackQueue<T> extends Queue<T> {
// List to store stack elements
  final List<T> _stack = List<T>.empty(growable: true);

  // Adds an element to the stack
  void push(T element) {
    _stack.add(element);
  }

  // Removes and returns the element from the stack
  @override
  T pop() {
    if (_stack.isEmpty) {
      throw Exception('Stack is empty');
    }
    return _stack.removeLast();
  }

  @override
  void clear() {
    _stack.clear();
  }
  
  @override
  bool get isEmpty => _stack.isEmpty;
  
  @override
  bool get isNotEmpty => _stack.isNotEmpty;
  
  @override
  int get length => _stack.length;
}
