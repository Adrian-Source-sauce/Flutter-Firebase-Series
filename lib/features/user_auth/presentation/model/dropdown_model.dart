import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/presentation/services/database.dart';

class DropdownDialog extends StatefulWidget {
  final DatabaseMethods dbMethods;
  final String id;
  final String? dropdownValues;

  DropdownDialog({required this.dbMethods, required this.id,required this.dropdownValues});

  @override
  _DropdownDialogState createState() => _DropdownDialogState();
}
class _DropdownDialogState extends State<DropdownDialog> {
  String dropdownValue = 'Sehat';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
          Map<String, dynamic> hewanInfoMap = {
            "kondisiKesehatan": dropdownValue,
            // Add other fields here if needed
          };
          widget.dbMethods.editHewanDetails(widget.id, hewanInfoMap).then((value) {
            Navigator.pop(context);
          });
        },
        items: <String>['Sakit', 'Mati', 'Sehat']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}


