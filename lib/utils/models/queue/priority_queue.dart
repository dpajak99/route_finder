import 'package:equatable/equatable.dart';

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

class PriorityQueue<T> {
  List<PriorityQueueElement<T>> queue = List<PriorityQueueElement<T>>.empty(growable: true);

  PriorityQueue();

  /// Add a new item to the queue and ensure the highest priority element
  /// is at the front of the queue.
  void add(T value, double cost) {
    PriorityQueueElement<T> element = PriorityQueueElement<T>(value: value, priority: cost);
    queue
      ..add(element)
      ..sort((PriorityQueueElement<T> a, PriorityQueueElement<T> b) {
        if( a.priority == double.infinity || b.priority == double.infinity) {
          return -1;
        }
        return a.priority.compareTo(b.priority);
      });
  }

  /// Return the highest priority element in the queue.
  PriorityQueueElement<T> pop() {
    PriorityQueueElement<T> removed = queue.removeAt(0);
    return removed;
  }

  bool get isEmpty {
    return queue.isEmpty;
  }
  
  bool get isNotEmpty {
    return queue.isNotEmpty;
  }
}
