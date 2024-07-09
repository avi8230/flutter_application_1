import 'package:flutter/material.dart';

import 'quote_app.dart';

class BasicCrudApp extends StatelessWidget {
  const BasicCrudApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const QuoteApp(),
      ),
    );
  }
}
