import 'package:path_finder/utils/models/queue/queue.dart';

// First in first out
class FifoQueue<T> extends Queue<T> {
  final List<T> _queue = List<T>.empty(growable: true);

  /// Add a new item to the queue and ensure the highest priority element
  /// is at the front of the queue.
  void add(T value) {
    _queue.add(value);
  }
  
  /// Return the highest priority element in the queue.
  @override
  T pop() {
   T removed = _queue.removeAt(0);
   return removed;
  }
  
  @override
  void clear() {
    _queue.clear();
  }

  @override
  bool get isEmpty {
    return _queue.isEmpty;
  }
  
  @override
  bool get isNotEmpty {
    return _queue.isNotEmpty;
  }
  
  @override
  int get length => _queue.length;
}
