class StackQueue<T> {
// List to store stack elements
  final List<T> _elements = List<T>.empty(growable: true);

// Adds an element to the stack
  void push(T element) {
    _elements.add(element);
  }

// Gets the element from the stack (without removing it)
  T peek() {
    if (_elements.isEmpty) {
      throw Exception('Stack is empty');
    }
    return _elements.last;
  }

// Removes and returns the element from the stack
  T pop() {
    if (_elements.isEmpty) {
      throw Exception('Stack is empty');
    }
    return _elements.removeLast();
  }

// Returns true if the stack is empty, false otherwise
  bool get isEmpty => _elements.isEmpty;
  
  bool get isNotEmpty => _elements.isNotEmpty;

// Returns the size of the stack
  int get length => _elements.length;
}
