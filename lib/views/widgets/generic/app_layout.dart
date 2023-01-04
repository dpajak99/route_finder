import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget header;
  final Widget map;
  final Widget menu;
  final Widget console;

  const AppLayout({
    required this.header,
    required this.map,
    required this.menu,
    required this.console,
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
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: console,
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
