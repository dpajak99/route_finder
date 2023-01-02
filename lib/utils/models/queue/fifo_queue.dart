import 'package:equatable/equatable.dart';

// First in first out
class FifoQueue<T> {
  List<T> queue = List<T>.empty(growable: true);

  FifoQueue();

  /// Add a new item to the queue and ensure the highest priority element
  /// is at the front of the queue.
  void add(T value) {
    queue.insert(0, value);
  }
  
  /// Return the highest priority element in the queue.
  T pop() {
   T removed = queue.removeAt(0);
   return removed;
  }

  bool get isEmpty {
    return queue.isEmpty;
  }
  
  bool get isNotEmpty {
    return queue.isNotEmpty;
  }
}
