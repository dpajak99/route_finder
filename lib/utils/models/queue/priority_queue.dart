import 'package:equatable/equatable.dart';
import 'package:path_finder/utils/models/queue/queue.dart';

class PriorityQueueElement<T> extends Equatable {
  final T value;
  final double priority;

  const PriorityQueueElement({
    required this.value,
    required this.priority,
  });

  @override
  List<Object?> get props => <Object?>[value, priority];
}

class PriorityQueue<T> extends Queue<PriorityQueueElement<T>> {
  final List<PriorityQueueElement<T>> _queue = List<PriorityQueueElement<T>>.empty(growable: true);
  
  @override
  PriorityQueueElement<T> pop() {
    PriorityQueueElement<T> removed = _queue.removeAt(0);
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

  /// Add a new item to the queue and ensure the highest priority element
  /// is at the front of the queue.
  void add(T value, double cost) {
    PriorityQueueElement<T> element = PriorityQueueElement<T>(value: value, priority: cost);
    _queue
      ..add(element)
      ..sort((PriorityQueueElement<T> a, PriorityQueueElement<T> b) {
        if( a.priority == double.infinity || b.priority == double.infinity) {
          return -1;
        }
        return a.priority.compareTo(b.priority);
      });
  }

}
