import 'package:flutter/material.dart'; // מייבא את חבילת Flutter Material לעיצוב ממשק המשתמש.
import 'package:cloud_firestore/cloud_firestore.dart'; // מייבא את חבילת Cloud Firestore לשימוש במסד הנתונים של Firebase.

import '../quote_app.dart'; // מייבא את הקובץ quote_app.dart.

void addQuote(String text, String author) { // פונקציה להוספת ציטוט למסד הנתונים.
  final db = FirebaseFirestore.instance; // מקבל את מופע ה-Firebase Firestore.
  final data = {"text": text, "author": author}; // יוצר אובייקט נתונים המכיל את הטקסט והמחבר של הציטוט.
  db.collection("quotes").add(data).then((documentSnapshot) =>
      print("Added Data with ID: ${documentSnapshot.id}")); // מוסיף את הנתונים לאוסף "quotes" ומדפיס את ה-ID של המסמך שנוסף.
}

class AddQuoteForm extends StatefulWidget { // מגדיר ווידג'ט Stateful להוספת ציטוט.
  @override
  _AddQuoteFormState createState() => _AddQuoteFormState(); // יוצר את ה-State של הווידג'ט.
}

class _AddQuoteFormState extends State<AddQuoteForm> {
  final _formKey = GlobalKey<FormState>(); // מפתח לטופס לאימות הקלטים.
  final _textController = TextEditingController(); // בקר לטקסט של הציטוט.
  final _authorController = TextEditingController(); // בקר לשם המחבר.

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // ריווח של 16 פיקסלים מסביב לטופס.
      child: Form(
        key: _formKey, // מפתח הטופס לאימות.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _textController, // מגדיר את הבקר לשדה הקלט של טקסט הציטוט.
              decoration: const InputDecoration(
                hintText: 'Enter quote text', // טקסט עזר לשדה הקלט.
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text'; // הודעת שגיאה אם השדה ריק.
                }
                return null;
              },
            ),
            TextFormField(
              controller: _authorController, // מגדיר את הבקר לשדה הקלט של שם המחבר.
              decoration: const InputDecoration(
                hintText: 'Enter author name', // טקסט עזר לשדה הקלט.
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an author'; // הודעת שגיאה אם השדה ריק.
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0), // ריווח אנכי של 16 פיקסלים.
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) { // אם הטופס תקין.
                    addQuote(_textController.text, _authorController.text); // מוסיף את הציטוט למסד הנתונים.
                    _textController.clear(); // מנקה את שדה הקלט של טקסט הציטוט.
                    _authorController.clear(); // מנקה את שדה הקלט של שם המחבר.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Quote Added')), // מציג הודעה שהציטוט נוסף בהצלחה.
                    );
                  }
                },
                child: const Text('Add Quote'), // טקסט הכפתור.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
