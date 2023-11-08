import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeSelect extends StatefulWidget {
  final DateTime initialDateTime;
  final void Function(DateTime) onDateTimeChanged;

  const DateTimeSelect({
    required this.initialDateTime,
    required this.onDateTimeChanged,
    Key? key,
  }) : super(key: key);

  @override
  _DateTimeSelectState createState() => _DateTimeSelectState();
}

class _DateTimeSelectState extends State<DateTimeSelect> {
  late DateTime dateTime = widget.initialDateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Opacity(
              opacity: 0.5,
              child: InkWell(
                // onTap: () async {
                //   final DateTime? selectedDate = await showDatePicker(
                //     context: context,
                //     initialDate: dateTime,
                //     firstDate: widget.initialDateTime,
                //     lastDate: DateTime(2024),
                //   );
                //
                //   if (selectedDate != null) {
                //     setState(() {
                //       dateTime = selectedDate;
                //     });
                //     widget.onDateTimeChanged(dateTime);
                //   }
                // },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    minLeadingWidth: 0,
                    leading: const Icon(Icons.calendar_today, color: Colors.black26),
                    title: Text(
                      DateFormat('dd-MM-yyy').format(dateTime),
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () async {
                final TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(dateTime),
                );

                if (selectedTime != null) {
                  setState(() {
                    dateTime = DateTime(
                      dateTime.year,
                      dateTime.month,
                      dateTime.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                  });
                  widget.onDateTimeChanged(dateTime);
                }
              },
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  minLeadingWidth: 0,
                  leading: const Icon(Icons.access_time, color: Colors.black26),
                  title: Text(
                    DateFormat('HH:mm').format(dateTime),
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
