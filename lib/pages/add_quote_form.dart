import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../quote_app.dart';

void addQuote(String text, String author) {
  final db = FirebaseFirestore.instance;
  final data = {"text": text, "author": author};
  db.collection("quotes").add(data).then((documentSnapshot) =>
      print("Added Data with ID: ${documentSnapshot.id}"));
}

class AddQuoteForm extends StatefulWidget {
  @override
  _AddQuoteFormState createState() => _AddQuoteFormState();
}

class _AddQuoteFormState extends State<AddQuoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter quote text',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                hintText: 'Enter author name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an author';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addQuote(_textController.text, _authorController.text);
                    _textController.clear();
                    _authorController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Quote Added')),
                    );
                  }
                },
                child: const Text('Add Quote'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
