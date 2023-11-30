import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PermissionComponent extends StatelessWidget {
  const PermissionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text("andreaemmmia@gmail.com")),
          ToggleSwitch(
            minWidth: 90.0,
            initialLabelIndex: 1,
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            icons: [Icons.check, Icons.close],
            activeBgColors: [
              [Colors.green],
              [Colors.red]
            ],
            onToggle: (index) {
              print('switched to: $index');
            },
          ),
        ],
      ),
    );
  }
}
