import 'package:flutter/material.dart'; // מייבא את חבילת Flutter Material לעיצוב ממשק המשתמש.

import 'quote_app.dart'; // מייבא את הקובץ quote_app.dart שמכיל את הקוד הראשי של האפליקציה QuoteApp.

class BasicCrudApp extends StatelessWidget { // מגדיר את הווידג'ט BasicCrudApp שהוא מסוג StatelessWidget.
  const BasicCrudApp({Key? key}) : super(key: key); // קונסטרקטור המגדיר את ה-key של הווידג'ט אם נדרש.

  @override
  Widget build(BuildContext context) { // מתודה הבונה את הווידג'ט.
    return MaterialApp( // מחזירה את הווידג'ט MaterialApp.
      home: Scaffold( // קובע את Scaffold כווידג'ט הראשי.
        body: const QuoteApp(), // מגדיר את QuoteApp כווידג'ט הבסיסי בתוך ה-body של ה-Scaffold.
      ),
    );
  }
}
