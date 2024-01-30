import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:possiball_site/screens/tornei/viewgironi.dart';
import 'package:possiball_site/utils/custompagetransitions.dart';

class ViewTornei extends StatefulWidget {
  const ViewTornei({super.key, required this.torneoId});

  final String torneoId;

  @override
  State<ViewTornei> createState() => _ViewTorneiState();
}

class _ViewTorneiState extends State<ViewTornei> {
  late final Map partite;
  late final Map partiteCopy;
  String? idPartite;

  void sendPartite() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Partite');
    if (idPartite == null) {
      await collection
          .add({"torneoId": widget.torneoId, "date": partite["date"]});
    } else {
      await collection
          .doc(idPartite)
          .update({"torneoId": widget.torneoId, "date": partite["date"]});
    }
  }

  Future<Map<String, dynamic>?> getPartite() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Partite")
          .where("torneoId", isEqualTo: widget.torneoId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Prendi il primo documento corrispondente
        Map<String, dynamic> datiDocumento =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        partite = datiDocumento;
        partiteCopy = partite;
        idPartite = querySnapshot.docs.first.id;
        return datiDocumento;
      } else {
        partite = {"date": {}};
        partiteCopy = partite;
        print('Nessun documento trovato');
        return null;
      }
    } catch (e) {
      print('Errore durante il recupero del documento: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partite del torneo"),
        actions: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardColor.withOpacity(0.1)),
            child: TextButton(
              onPressed: () => Navigator.push(context,
                  RightPageRoute(child: ViewGironi(torneoId: widget.torneoId))),
              child: Text(
                "Visualizza gironi",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder(
              future: getPartite(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return PopScope(
                    onPopInvoked: (didPop) => sendPartite(),
                    child: Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                DateTime? newDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                );

                                if (newDate != null) {
                                  partite["date"].putIfAbsent(
                                      "${newDate.day}/${newDate.month}/${newDate.year}",
                                      () => []);
                                  setState(() {});
                                }
                              },
                              child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.1),
                                  ),
                                  child: Text("Aggiungi data")),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: partite["date"].length,
                              itemBuilder: (context, index) {
                                String data =
                                    partite["date"].keys.elementAt(index);
                                List<dynamic> partiteData =
                                    partite["date"][data];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data,
                                            style: TextStyle(fontSize: 24),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  Map match =
                                                      await showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return AddPartita(
                                                                torneoId: widget
                                                                    .torneoId);
                                                          });

                                                  partite["date"][data]
                                                      .add(match);
                                                  setState(() {});
                                                },
                                                child: Icon(Icons
                                                    .add_circle_outline_rounded),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              GestureDetector(
                                                onTap: () => deletePartita(
                                                    index: index,
                                                    data: data,
                                                    isMatch: false),
                                                child: Icon(Icons.delete),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: partiteData.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .cardColor
                                                  .withOpacity(0.1),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(partiteData[index]["ora"]),
                                                Text(partiteData[index]["casa"]
                                                    ["name"]),
                                                Text(partiteData[index]
                                                    ["ospite"]["name"]),
                                                Text(partiteData[index]
                                                    ["campo"]),
                                                GestureDetector(
                                                  onTap: () {
                                                    deletePartita(
                                                        index: index,
                                                        data: data);
                                                  },
                                                  child: Icon(Icons.delete),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
          GestureDetector(
            onTap: () {
              sendPartite();
              Navigator.pop(context);
            },
            child: Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor),
                child: Text(
                  "Salva",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26),
                )),
          ),
        ],
      ),
    );
  }

  Future deletePartita({int? index, String? data, bool isMatch = true}) async {
    showDialog(
        context: context,
        builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Container(
                  width: 300,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Vuoi cancellare ${isMatch ? "la partita" : "la data"}?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Indietro",
                              style: TextStyle(
                                  color: Colors.greenAccent, fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (isMatch) {
                                if (partite["date"].containsKey(data)) {
                                  partite["date"][data]
                                      .remove(partite["date"][data][index]);
                                }
                              } else {
                                if (partite["date"].containsKey(data)) {
                                  partite["date"].remove(data);
                                }
                              }
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Text(
                              "Cancella",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 18),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
              ],
            ));

    setState(() {});
  }
}

class AddPartita extends StatefulWidget {
  const AddPartita({
    super.key,
    required this.torneoId,
  });

  final String torneoId;

  @override
  State<AddPartita> createState() => _AddPartitaState();
}

class _AddPartitaState extends State<AddPartita> {
  TimeOfDay? matchTime;
  Map? _squadraCasa;
  Map? _squadraOspite;

  TextEditingController _campoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextButton(
                  onPressed: () async {
                    matchTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Text(
                        "Scegli orario",
                        style: TextStyle(fontSize: 21),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        matchTime != null
                            ? "${matchTime!.hour}:${matchTime!.minute} "
                            : "",
                        style: TextStyle(fontSize: 21),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextButton(
                  onPressed: () async {
                    _squadraCasa = await showModalBottomSheet(
                        context: context,
                        builder: (context) => ChooseTeamForMatch(
                              torneoId: widget.torneoId,
                            ));

                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Text(
                        "Squadra casa",
                        style: TextStyle(fontSize: 21),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${_squadraCasa?["name"] ?? ""}",
                        style: TextStyle(fontSize: 21),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextButton(
                  onPressed: () async {
                    _squadraOspite = await showModalBottomSheet(
                        context: context,
                        builder: (context) => ChooseTeamForMatch(
                              torneoId: widget.torneoId,
                            ));

                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Text(
                        "Squadra casa",
                        style: TextStyle(fontSize: 21),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${_squadraOspite?["name"] ?? ""}",
                        style: TextStyle(fontSize: 21),
                      ),
                    ],
                  )),
            ),
            TextField(
              controller: _campoController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                fillColor: Colors.white.withOpacity(0.3),
                filled: true,
                hintText: "Inserisci campo di gioco",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (matchTime != null &&
                    _campoController.value.text.isNotEmpty &&
                    _squadraCasa != null &&
                    _squadraOspite != null) {
                  Navigator.pop(context, {
                    "ora": "${matchTime!.hour}:${matchTime!.minute}",
                    "casa": _squadraCasa,
                    "ospite": _squadraOspite,
                    "campo": _campoController.value.text,
                  });
                }
              },
              child: Text("Aggiungi"),
            )
          ],
        ),
      ),
    );
  }
}

class ChooseTeamForMatch extends StatelessWidget {
  const ChooseTeamForMatch({
    super.key,
    required this.torneoId,
  });

  final String torneoId;

  Future<List?>? getTeams() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Tornei');

    // Ottieni il documento utilizzando l'id
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(torneoId).get();

    // Controlla se il documento esiste
    if (documentSnapshot.exists) {
      // Ottieni i dati del documento
      List teams = [];
      Map torneo = documentSnapshot.data() as Map;
      Map listaGironi = torneo.values.first;

      listaGironi.forEach((key, value) {
        print(value);
        teams.addAll(value);
      });

      return teams;

      // Puoi fare qualcosa con i dati qui
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTeams(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              List teams = snapshot.data!;
              return GestureDetector(
                onTap: () => Navigator.pop(context,
                    {"id": teams[index]["id"], "name": teams[index]["name"]}),
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.network(teams[index]["logo"])),
                        Expanded(
                          child: Text(
                            teams[index]["name"],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
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
    );
  }
}
