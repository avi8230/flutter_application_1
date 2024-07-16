import 'package:cloud_firestore/cloud_firestore.dart'; // מייבא את חבילת Cloud Firestore לשימוש במסד הנתונים של Firebase.
import 'package:firebase_core/firebase_core.dart'; // מייבא את חבילת Firebase Core לשימוש ב-Firebase.
import 'package:flutter/material.dart'; // מייבא את חבילת Flutter Material לעיצוב ממשק המשתמש.
import 'package:flutter_application_1/basic_crud_app.dart'; // מייבא את הקובץ basic_crud_app.dart שמכיל את הקוד הראשי של האפליקציה.
import 'package:flutter_application_1/firebase_options.dart'; // מייבא את הקובץ firebase_options.dart שמכיל את ההגדרות של Firebase לאפליקציה.

void main() async { 
  WidgetsFlutterBinding.ensureInitialized(); // מבטיח ש-WidgetsFlutterBinding מאתחל לפני הרצת האפליקציה.
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // מאתחל את Firebase עם ההגדרות הספציפיות לפלטפורמה הנוכחית (אנדרואיד, iOS וכו').
  );
  
  runApp(const BasicCrudApp()); // מריץ את האפליקציה הראשית, המוגדרת בקובץ basic_crud_app.dart.
}
