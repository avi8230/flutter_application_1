import 'package:flutter/material.dart'; // מייבא את חבילת Flutter Material לעיצוב ממשק המשתמש.

import 'pages/add_quote_form.dart'; // מייבא את הקובץ שמכיל את הווידג'ט AddQuoteForm.
import 'pages/display_quotes.dart'; // מייבא את הקובץ שמכיל את הווידג'ט DisplayQuotes.
import 'pages/manage_quotes.dart'; // מייבא את הקובץ שמכיל את הווידג'ט ManageQuotes.

class QuoteApp extends StatefulWidget { // מגדיר את הווידג'ט QuoteApp שהוא מסוג StatefulWidget.
  const QuoteApp({Key? key}) : super(key: key); // קונסטרקטור המגדיר את ה-key של הווידג'ט אם נדרש.

  @override
  _QuoteAppState createState() => _QuoteAppState(); // יוצר את ה-State של הווידג'ט.
}

class _QuoteAppState extends State<QuoteApp> {
  int _selectedIndex = 0; // משתנה המגדיר את האינדקס של ה-Tab הנבחר.

  static List<Widget> _widgetOptions = <Widget>[ // רשימה של ווידג'טים שמוצגת בהתאם לאינדקס שנבחר.
    DisplayQuotes(), // ווידג'ט שמציג ציטוטים.
    AddQuoteForm(), // ווידג'ט שמוסיף ציטוט חדש.
    ManageQuotes(), // ווידג'ט שמנהל את הציטוטים.
  ];

  void _onItemTapped(int index) { // פונקציה שמופעלת כאשר משתמש לוחץ על אחד מה-Tabs בתחתית המסך.
    setState(() {
      _selectedIndex = index; // מעדכן את האינדקס הנבחר.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // מחזיר את הווידג'ט Scaffold שמספק מבנה בסיסי לעיצוב ממשק המשתמש.
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // מציג את הווידג'ט לפי האינדקס הנבחר.
      ),
      bottomNavigationBar: BottomNavigationBar( // סרגל הניווט בתחתית המסך.
        items: const <BottomNavigationBarItem>[ // רשימה של פריטים בסרגל הניווט.
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote), // אייקון של ציטוט.
            label: 'Quotes', // תווית הפריט.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add), // אייקון של הוספה.
            label: 'Add Quote', // תווית הפריט.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list), // אייקון של רשימה.
            label: 'Manage Quotes', // תווית הפריט.
          ),
        ],
        currentIndex: _selectedIndex, // האינדקס של הפריט הנבחר בסרגל הניווט.
        selectedItemColor: Colors.amber[800], // צבע הפריט הנבחר.
        onTap: _onItemTapped, // פונקציה שמופעלת כאשר משתמש לוחץ על אחד מהפריטים בסרגל הניווט.
      ),
    );
  }
}
