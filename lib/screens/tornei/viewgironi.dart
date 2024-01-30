import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewGironi extends StatefulWidget {
  const ViewGironi({super.key, required this.torneoId});

  final String torneoId;

  @override
  State<ViewGironi> createState() => _ViewGironiState();
}

class _ViewGironiState extends State<ViewGironi> {
  Future<Map<String, dynamic>?> takeTorneoData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Tornei');

    // Ottieni il documento utilizzando l'id
    DocumentSnapshot documentSnapshot =
        await collectionReference.doc(widget.torneoId).get();

    // Controlla se il documento esiste
    if (documentSnapshot.exists) {
      // Ottieni i dati del documento
      return documentSnapshot.data() as Map<String, dynamic>;

      // Puoi fare qualcosa con i dati qui
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Torneo"),
      ),
      body: FutureBuilder(
          future: takeTorneoData(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              Map dati = snapshot.data!;
              String nome = dati.keys.first;
              Map gironi = dati[dati.keys.first];
              return Column(
                children: [
                  Text(nome),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(30),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Numero di colonne nella griglia
                          crossAxisSpacing:
                              8.0, // Spazio orizzontale tra le colonne
                          mainAxisSpacing: 8.0, // Spazio verticale tra le righe
                          childAspectRatio: 1.3),
                      itemCount: gironi.length,
                      itemBuilder: (BuildContext context, int index) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final aspectRatio =
                                constraints.maxWidth / constraints.maxHeight;
                            String nomeGirone = "Girone ${index + 1}";
                            List girone = gironi[nomeGirone];
                            return GridTile(
                              child: GestureDetector(
                                onTap: () async {},
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    children: [
                                      Text(
                                        nomeGirone,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: girone.length,
                                          itemBuilder: (context, index) =>
                                              Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Theme.of(context)
                                                    .cardColor),
                                            child: Builder(
                                              builder: (context) {
                                                return Text(
                                                  girone[index]["name"],
                                                  textAlign: TextAlign.center,
                                                );
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
                ],
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }
}
