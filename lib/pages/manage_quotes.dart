import 'package:flutter/material.dart'; // מייבא את חבילת Flutter Material לעיצוב ממשק המשתמש.
import 'package:cloud_firestore/cloud_firestore.dart'; // מייבא את חבילת Cloud Firestore לשימוש במסד הנתונים של Firebase.

import '../quote_app.dart'; // מייבא את קובץ quote_app.dart שנמצא בתיקיית ה-parent.

class ManageQuotes extends StatelessWidget { // מגדיר ווידג'ט Stateless לניהול הציטוטים.
  final Stream<QuerySnapshot> _quotesStream =
      FirebaseFirestore.instance.collection('quotes').snapshots(); // זורם נתונים של אוסף הציטוטים מ-Firestore.

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _quotesStream, // משתמש בזרם הנתונים של הציטוטים.
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong'); // מציג הודעת שגיאה אם יש בעיה בזרם הנתונים.
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading"); // מציג הודעת טעינה בזמן שהנתונים נטענים.
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) { // ממפה כל מסמך בזרם הנתונים לרשימת ווידג'טים.
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>; // ממיר את הנתונים ממסמך למפה.
            return ListTile(
              title: Text(data['text']), // מציג את טקסט הציטוט ככותרת.
              subtitle: Text(data['author']), // מציג את שם המחבר כתת-כותרת.
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // מתאים את השורה למינימום רוחב שנדרש.
                children: [
                  IconButton(
                    icon: Icon(Icons.edit), // כפתור עריכה.
                    onPressed: () {
                      _editQuote(context, document.id, data['text'], data['author']); // מפעיל את הפונקציה לעריכת הציטוט.
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete), // כפתור מחיקה.
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('quotes')
                          .doc(document.id)
                          .delete(); // מוחק את הציטוט מהאוסף ב-Firestore.
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

  void _editQuote(BuildContext context, String id, String text, String author) { // פונקציה לעריכת הציטוט.
    TextEditingController textController = TextEditingController(text: text); // שדה טקסט לעריכת טקסט הציטוט.
    TextEditingController authorController = TextEditingController(text: author); // שדה טקסט לעריכת שם המחבר.
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
                  FirebaseFirestore.instance
                      .collection('quotes')
                      .doc(id)
                      .update({
                    'text': textController.text,
                    'author': authorController.text,
                  }); // מעדכן את הציטוט ב-Firestore.
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
