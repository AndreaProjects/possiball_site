import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:possiball_site/screens/tornei/choosesociety.dart';
import 'package:possiball_site/utils/custompagetransitions.dart';

class AddTorneo extends StatefulWidget {
  const AddTorneo({super.key});

  @override
  State<AddTorneo> createState() => _AddTorneoState();
}

class _AddTorneoState extends State<AddTorneo> {
  TextEditingController _gironiController = TextEditingController();
  TextEditingController _gironeController = TextEditingController();
  String? nomeGirone;
  Map gironi = {};
  int numeroGironi = 0;
  int squadreGirone = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aggiungi nuovo torneo"),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() {
              nomeGirone = value;
            }),
            decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.3),
              filled: true,
              hintText: "Inserisci nome torneo",
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Numero di gironi"),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _gironiController,
                  onChanged: (value) => setState(() {
                    numeroGironi = int.parse(value);
                  }),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white.withOpacity(0.3),
                    filled: true,
                    hintText: "inserisci...",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Numero di squadre per girone"),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: _gironeController,
                  onChanged: (value) => setState(() {
                    squadreGirone = int.parse(value);
                  }),
                  decoration: InputDecoration(
                    fillColor: Colors.white.withOpacity(0.3),
                    filled: true,
                    hintText: "inserisci...",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(30),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Numero di colonne nella griglia
                  crossAxisSpacing: 8.0, // Spazio orizzontale tra le colonne
                  mainAxisSpacing: 8.0, // Spazio verticale tra le righe
                  childAspectRatio: 1.3),
              itemCount: numeroGironi,
              itemBuilder: (BuildContext context, int index) {
                // Qui puoi generare il tuo elemento in base all'indice
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final aspectRatio =
                        constraints.maxWidth / constraints.maxHeight;
                    String nomeGirone = "Girone ${index + 1}";

                    return GridTile(
                      child: GestureDetector(
                        onTap: () async {
                          Map nuovoGirone = await Navigator.push(
                            context,
                            RightPageRoute(
                              child: ChooseSocietyScreen(
                                nomeGirone: nomeGirone,
                                numeroSquadreTotali: squadreGirone,
                              ),
                            ),
                          );
                          gironi.addAll(nuovoGirone);
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Column(
                            children: [
                              Text(
                                nomeGirone,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: squadreGirone,
                                  itemBuilder: (context, index) => Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).cardColor),
                                    child: Builder(
                                      builder: (context) {
                                        if (gironi.containsKey(nomeGirone)) {
                                          return Row(
                                            children: [
                                              SizedBox(
                                                height: 30,
                                                width: 30,
                                                child: Image.network(
                                                    (gironi[nomeGirone][index]
                                                        ["logo"])),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                gironi[nomeGirone][index]
                                                    ["name"],
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          );
                                        } else {
                                          return Text("Squadra ${index + 1}");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          numeroGironi == gironi.length &&
                  numeroGironi != 0 &&
                  squadreGirone != 0 &&
                  nomeGirone != null
              ? GestureDetector(
                  onTap: () => sendNuovoTorneo(),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Text(
                      "Salva",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 31),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Text(
                    "Completa tutti i campi e i gironi",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
        ],
      ),
    );
  }

  void sendNuovoTorneo() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Tornei');
    Map<String, dynamic> newGirone = {nomeGirone ?? "noName": gironi};
    var newTorneo = await collection.add(newGirone);

    Navigator.pop(context);
  }
}
