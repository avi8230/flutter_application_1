import 'package:flutter/material.dart'; // מייבא את חבילת Flutter Material לעיצוב ממשק המשתמש.
import 'package:cloud_firestore/cloud_firestore.dart'; // מייבא את חבילת Cloud Firestore לשימוש במסד הנתונים של Firebase.

class DisplayQuotes extends StatefulWidget { // מגדיר ווידג'ט Stateful להצגת הציטוטים.
  @override
  _DisplayQuotesState createState() => _DisplayQuotesState(); // יוצר את ה-State של הווידג'ט.
}

class _DisplayQuotesState extends State<DisplayQuotes> {
  final PageController _pageController = PageController(); // בקר לדפדוף בין הדפים.
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

        return Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController, // משתמש בבקר לדפדוף בין הדפים.
                children:
                    snapshot.data!.docs.map((DocumentSnapshot document) { // ממפה כל מסמך בזרם הנתונים לרשימת ווידג'טים.
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>; // ממיר את הנתונים ממסמך למפה.
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // מרכז את התוכן אנכית.
                      children: [
                        Text(
                          data['text'], // מציג את טקסט הציטוט.
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(height: 10), // מוסיף רווח אנכי של 10 פיקסלים.
                        Text(
                          data['author'], // מציג את שם המחבר.
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // מיישר את הכפתורים לקצוות השורה.
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back), // כפתור לדפדוף אחורה.
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300), // משך האנימציה.
                      curve: Curves.ease, // סוג האנימציה.
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward), // כפתור לדפדוף קדימה.
                  onPressed: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300), // משך האנימציה.
                      curve: Curves.ease, // סוג האנימציה.
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
