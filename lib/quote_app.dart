import 'package:flutter/material.dart';

import 'pages/add_quote_form.dart';
import 'pages/display_quotes.dart';
import 'pages/manage_quotes.dart';

class QuoteApp extends StatefulWidget {
  const QuoteApp({Key? key}) : super(key: key);

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