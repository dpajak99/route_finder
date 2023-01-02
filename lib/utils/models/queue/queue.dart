abstract class Queue<T> {
  /// Return the highest priority element in the queue.
  T pop();
  
  /// Return true if the queue is empty.
  void clear();

  /// Returns true if the queue is empty, false otherwise
  bool get isEmpty;

  /// Returns true if the queue is not empty, false otherwise
  bool get isNotEmpty;

  /// Returns the size of the queue
  int get length;
}