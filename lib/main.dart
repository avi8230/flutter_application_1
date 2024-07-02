import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BasicCrudApp());
}

addQuote() {
  final db = FirebaseFirestore.instance;
  final data = {"text": "quote text", "author": "author name"};
  db.collection("quotes").add(data).then((documentSnapshot) =>
      print("Added Data with ID: ${documentSnapshot.id}"));
}

class BasicCrudApp extends StatelessWidget {
  const BasicCrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Provider Example'),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            body: Center(
                child: Column(
              children: [
                ElevatedButton(
                    onPressed: () => {addQuote()},
                    child: const Text('Add Quote')),
                ElevatedButton(
                    onPressed: () => {}, child: const Text('Get Quote')),
                ElevatedButton(
                    onPressed: () => {}, child: const Text('Delete Quote'))
              ],
            ))));
  }
}
