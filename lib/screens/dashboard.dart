import 'package:flutter/material.dart';
import 'package:possiball_site/components/permission.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Utenti:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Accesso consentito:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          PermissionComponent(),
          PermissionComponent(),
          PermissionComponent(),
          PermissionComponent(),
          PermissionComponent(),
          PermissionComponent(),
          PermissionComponent(),
          PermissionComponent(),
          PermissionComponent(),
          PermissionComponent(),
          PermissionComponent(),
        ],
      ),
    );
  }
}
