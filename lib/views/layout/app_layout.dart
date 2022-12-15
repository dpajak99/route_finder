import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget header;
  final Widget map;
  final Widget menu;
  final Widget terminal;

  const AppLayout({
    required this.header,
    required this.map,
    required this.menu,
    required this.terminal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black26, width: 1),
              ),
            ),
            height: 50,
            child: header,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: map,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 43, 43, 43),
                        height: 200,
                        width: double.infinity,
                        child: terminal,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black26, width: 1),
                    ),
                  ),
                  child: menu,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
