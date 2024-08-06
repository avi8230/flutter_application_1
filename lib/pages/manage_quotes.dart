import 'package:flutter/material.dart'; // מייבא את חבילת Flutter Material לעיצוב ממשק המשתמש.
import '../quote_app.dart'; // מייבא את קובץ quote_app.dart שנמצא בתיקיית ה-parent.
import '../repositorys/repository_quotes.dart'; // מייבא את קובץ quotes_repository.dart שנמצא בתיקיית ה-parent.

class ManageQuotes extends StatelessWidget { // מגדיר ווידג'ט Stateless לניהול הציטוטים.
  final QuotesRepository quotesRepository = QuotesRepository(); // יוצר מופע של המחלקה QuotesRepository.

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Quote>>(
      stream: quotesRepository.getQuotes(), // משתמש בזרם הנתונים של הציטוטים.
      builder: (BuildContext context, AsyncSnapshot<List<Quote>> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong'); // מציג הודעת שגיאה אם יש בעיה בזרם הנתונים.
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading"); // מציג הודעת טעינה בזמן שהנתונים נטענים.
        }

        return ListView(
          children: snapshot.data!.map((Quote quote) { // ממפה כל ציטוט בזרם הנתונים לרשימת ווידג'טים.
            return ListTile(
              title: Text(quote.text), // מציג את טקסט הציטוט ככותרת.
              subtitle: Text(quote.author), // מציג את שם המחבר כתת-כותרת.
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // מתאים את השורה למינימום רוחב שנדרש.
                children: [
                  IconButton(
                    icon: Icon(Icons.edit), // כפתור עריכה.
                    onPressed: () {
                      _editQuote(context, quote); // מפעיל את הפונקציה לעריכת הציטוט.
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete), // כפתור מחיקה.
                    onPressed: () {
                      quotesRepository.deleteQuote(quote.id); // מוחק את הציטוט מהאוסף ב-Firestore.
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

  void _editQuote(BuildContext context, Quote quote) { // פונקציה לעריכת הציטוט.
    TextEditingController textController = TextEditingController(text: quote.text); // שדה טקסט לעריכת טקסט הציטוט.
    TextEditingController authorController = TextEditingController(text: quote.author); // שדה טקסט לעריכת שם המחבר.
    final _formKey = GlobalKey<FormState>(); // מפתח גלובלי לניהול מצב הטופס.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Quote'), // כותרת הדיאלוג.
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // מתאים את העמודה למינימום גובה שנדרש.
              children: [
                TextFormField(
                  controller: textController,
                  decoration: InputDecoration(labelText: 'Quote'), // תווית שדה הטקסט.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text'; // בדיקת שדה חובה לטקסט הציטוט.
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: authorController,
                  decoration: InputDecoration(labelText: 'Author'), // תווית שדה המחבר.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an author'; // בדיקת שדה חובה למחבר.
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
                if (_formKey.currentState!.validate()) { // בודק אם הטופס תקין.
                  quotesRepository.updateQuote(quote.id, authorController.text, textController.text); // מעדכן את הציטוט ב-Firestore.
                  Navigator.of(context).pop(); // סוגר את הדיאלוג.
                }
              },
              child: Text('Save'), // טקסט כפתור השמירה.
            ),
          ],
        );
      },
    );
  }
}
