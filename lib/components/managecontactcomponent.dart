import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:possiball_site/screens/enablecontacts.dart';
import 'package:possiball_site/utils/custompagetransitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ManageContactComponent extends StatelessWidget {
  const ManageContactComponent(
      {super.key,
      required this.name,
      required this.email,
      required this.contacts});

  final String name;
  final String email;
  final String contacts;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          RightPageRoute(
            child: EnableContacts(email: email),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.1)),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    width: 20,
                    child: Text(
                      "|",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w100),
                    ),
                  ),
                  Text(email),
                ],
              )),
              Text(contacts)
            ],
          ),
        ),
      ),
    );
  }
}
