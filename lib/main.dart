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

addQuote(String text, String author) {
  final db = FirebaseFirestore.instance;
  final data = {"text": text, "author": author};
  db.collection("quotes").add(data).then((documentSnapshot) =>
      print("Added Data with ID: ${documentSnapshot.id}"));
}

class BasicCrudApp extends StatelessWidget {
  const BasicCrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: const QuoteApp(),
    ));
  }
}

class QuoteApp extends StatefulWidget {
  const QuoteApp({super.key});

  @override
  _QuoteAppState createState() => _QuoteAppState();
}

class _QuoteAppState extends State<QuoteApp> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    DisplayQuotes(),
    AddQuoteForm(),
    ManageQuotes(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Quotes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Quote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Manage Quotes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class DisplayQuotes extends StatefulWidget {
  @override
  _DisplayQuotesState createState() => _DisplayQuotesState();
}

class _DisplayQuotesState extends State<DisplayQuotes> {
  PageController _pageController = PageController();
  Stream<QuerySnapshot> _quotesStream =
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

        return Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data['text'],
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(height: 10),
                        Text(
                          data['author'],
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Quote'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(labelText: 'Quote'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('quotes')
                    .doc(id)
                    .update({
                  'text': textController.text,
                  'author': authorController.text,
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
