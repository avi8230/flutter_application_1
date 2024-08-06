import 'package:flutter/material.dart'; // מייבא את חבילת Flutter Material לעיצוב ממשק המשתמש.
import '../quote_app.dart'; // מייבא את הקובץ quote_app.dart.
import '../repositorys/repository_quotes.dart'; // מייבא את מחלקת QuotesRepository.

class AddQuoteForm extends StatefulWidget { // מגדיר ווידג'ט Stateful להוספת ציטוט.
  @override
  _AddQuoteFormState createState() => _AddQuoteFormState(); // יוצר את ה-State של הווידג'ט.
}

class _AddQuoteFormState extends State<AddQuoteForm> {
  final _formKey = GlobalKey<FormState>(); // מפתח לטופס לאימות הקלטים.
  final _textController = TextEditingController(); // בקר לטקסט של הציטוט.
  final _authorController = TextEditingController(); // בקר לשם המחבר.
  final QuotesRepository quotesRepository = QuotesRepository(); // יוצר מופע של המחלקה QuotesRepository.

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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) { // אם הטופס תקין.
                    await quotesRepository.addQuote(_textController.text, _authorController.text); // מוסיף את הציטוט למסד הנתונים.
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
