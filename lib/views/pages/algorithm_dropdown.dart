import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

enum AlgorithmType { dijkstra, aStar, bfs, dfs }

class AlgorithmDropdown extends StatefulWidget {
  const AlgorithmDropdown({super.key});

  @override
  _AlgorithmDropdownState createState() => _AlgorithmDropdownState();
}

class _AlgorithmDropdownState extends State<AlgorithmDropdown> {
  AlgorithmType selectedAlgorithm = AlgorithmType.dijkstra;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<AlgorithmType>(
          value: selectedAlgorithm,
          buttonWidth: double.infinity,
          buttonDecoration: BoxDecoration(
            border: Border.all(
              color: Colors.black26,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          buttonPadding: const EdgeInsets.symmetric(horizontal: 16),
          items: const <DropdownMenuItem<AlgorithmType>>[
            DropdownMenuItem<AlgorithmType>(value: AlgorithmType.dijkstra, child: Text('Dijkstra')),
            DropdownMenuItem<AlgorithmType>(value: AlgorithmType.aStar, child: Text('A*')),
            DropdownMenuItem<AlgorithmType>(value: AlgorithmType.bfs, child: Text('BFS')),
            DropdownMenuItem<AlgorithmType>(value: AlgorithmType.dfs, child: Text('DFS')),
          ],
          onChanged: (AlgorithmType? value) {
            setState(() {
              selectedAlgorithm = value ?? AlgorithmType.dijkstra;
            });
          },
        ),
      ),
    );
  }
}
