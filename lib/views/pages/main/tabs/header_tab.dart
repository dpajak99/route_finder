import 'package:flutter/material.dart';
import 'package:path_finder/bloc/map/map_cubit.dart';
import 'package:path_finder/bloc/stop_select_cubit/stop_select_cubit.dart';
import 'package:path_finder/config/locator.dart';

class HeaderTab extends StatefulWidget {
  const HeaderTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeaderTabState();
}

class _HeaderTabState extends State<HeaderTab> {
  final MapCubit mapCubit = getIt<MapCubit>();
  final StopSelectCubit stopSelectCubit = getIt<StopSelectCubit>();
  final ValueNotifier<bool> showStopsNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> showEdgesNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> editModeNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 200,
            child: ValueListenableBuilder<bool>(
              valueListenable: editModeNotifier,
              builder: (BuildContext context, bool value, _) {
                return CheckboxListTile(
                  enabled: false,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: value,
                  onChanged: (bool? value) {
                    editModeNotifier.value = value ?? true;
                    mapCubit.mapMarkersCubit.setEditMode(editMode: editModeNotifier.value);
                  },
                  title: const Text('Edit mode'),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 250,
            child: ValueListenableBuilder<bool>(
              valueListenable: showStopsNotifier,
              builder: (BuildContext context, bool value, _) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: value,
                  onChanged: (bool? value) {
                    showStopsNotifier.value = value ?? true;
                    mapCubit.mapMarkersCubit.setVisible(visible: showStopsNotifier.value);
                  },
                  title: const Text('Pokaż przystanki'),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 250,
            child: ValueListenableBuilder<bool>(
              valueListenable: showEdgesNotifier,
              builder: (BuildContext context, bool value, _) {
                return CheckboxListTile(
                  value: value,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    showEdgesNotifier.value = value ?? true;
                    mapCubit.mapPolylinesCubit.setVisible(visible: showEdgesNotifier.value);
                  },
                  title: const Text('Pokaż trasę'),
                );
              },
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: stopSelectCubit.setRandom,
            icon: const Icon(Icons.shuffle),
            label: const Text('Wybierz losowe przystanki'),
          ),
        ],
      ),
    );
  }
}
