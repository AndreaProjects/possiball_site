import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChooseSocietyScreen extends StatefulWidget {
  const ChooseSocietyScreen({
    super.key,
    required this.numeroSquadreTotali,
    required this.nomeGirone,
  });

  final int numeroSquadreTotali;
  final String nomeGirone;

  @override
  State<ChooseSocietyScreen> createState() => _ChooseSocietyScreenState();
}

class _ChooseSocietyScreenState extends State<ChooseSocietyScreen> {
  List squadreScelte = [];
  Future<QuerySnapshot<Map<String, dynamic>>>? allSociety() async {
    return FirebaseFirestore.instance
        .collection('Users')
        .where("accountType", isEqualTo: "societa")
        .get();
  }

  void checkIfIsOnList(Map society) {
    bool isAlreadyInList = squadreScelte.any((existingSociety) {
      return mapEquals(existingSociety, society);
    });

    if (isAlreadyInList) {
      squadreScelte.removeWhere((existingSociety) {
        return mapEquals(existingSociety, society);
      });
    } else {
      squadreScelte.add(society);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sceglie squadra"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Squadre selezionate per il ${widget.nomeGirone}: ${squadreScelte.length}/${widget.numeroSquadreTotali}",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: allSociety(),
                  builder: (context, snapshot) {
                    List societyMap = [];
                    if (snapshot.hasData) {
                      var socities = snapshot.data!.docs;
                      Map soc = {};
                      for (var society in socities) {
                        soc = {
                          "name": society["name"],
                          "id": society.id,
                          "logo": society["logo"],
                        };
                        societyMap.add(soc);
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 5),
                        itemCount: societyMap.length,
                        itemBuilder: (context, index) {
                          bool isChoosed = squadreScelte.any((existingSociety) {
                            return mapEquals(
                                existingSociety, societyMap[index]);
                          });
                          return GestureDetector(
                            onTap: () => checkIfIsOnList(societyMap[index]),
                            child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: isChoosed
                                        ? Theme.of(context).cardColor
                                        : Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: Image.network(
                                            societyMap[index]["logo"])),
                                    Expanded(
                                      child: Text(
                                        societyMap[index]["name"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    )
                                  ],
                                )),
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
          squadreScelte.length == widget.numeroSquadreTotali
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(
                        context, {widget.nomeGirone: squadreScelte}),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Text(
                        "Conferma",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 31),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
