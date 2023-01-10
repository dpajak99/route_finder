import 'package:flutter/material.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class StopSelect extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final VoidCallback onRandom;
  final ValueChanged<String> onText;
  final StopVertex? selectedVertex;
  final bool active;

  const StopSelect({
    required this.onTap,
    required this.onCancel,
    required this.onRandom,
    required this.onText,
    this.selectedVertex,
    this.active = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final TextEditingController textEditingController = TextEditingController(
      text: selectedVertex?.id,
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: active ? Colors.blue : Colors.black26,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: active ? Colors.blue : Colors.black26,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (selectedVertex != null) ...<Widget>[
                        Text(
                          selectedVertex!.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Text('ID: '),
                            Expanded(
                              child: Text(
                                textEditingController.text,
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                                // controller: textEditingController,
                                // focusNode: FocusNode(),
                                // cursorColor: Colors.transparent,
                                // backgroundCursorColor: Colors.transparent,
                                // onChanged: (_) {
                                //   onText(textEditingController.text);
                                // },
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (selectedVertex == null)
                        const Text(
                          'Wybierz przystanek',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close),
                  onPressed: onCancel,
                ),
              ],
            ),
          ),
        ),
        TextButton(onPressed: onRandom, child: const Text('Losowo'))
      ],
    );
  }
}
