import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../quote_app.dart';

class ManageQuotes extends StatelessWidget {
  final Stream<QuerySnapshot> _quotesStream =
      FirebaseFirestore.instance.collection('quotes').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _quotesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['text']),
              subtitle: Text(data['author']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editQuote(context, document.id, data['text'], data['author']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('quotes')
                          .doc(document.id)
                          .delete();
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _editQuote(BuildContext context, String id, String text, String author) {
    TextEditingController textController = TextEditingController(text: text);
    TextEditingController authorController = TextEditingController(text: author);
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Quote'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: textController,
                  decoration: InputDecoration(labelText: 'Quote'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: authorController,
                  decoration: InputDecoration(labelText: 'Author'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an author';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FirebaseFirestore.instance
                      .collection('quotes')
                      .doc(id)
                      .update({
                    'text': textController.text,
                    'author': authorController.text,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
