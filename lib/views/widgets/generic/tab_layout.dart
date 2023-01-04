import 'package:flutter/cupertino.dart';

class TabLayout extends StatelessWidget {
  final Widget child;

  const TabLayout({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
  }
}
