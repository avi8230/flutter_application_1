import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const QuoteGptAppGet());
}

class QuoteGptAppGet extends StatelessWidget {
  const QuoteGptAppGet({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QuotesScreen(),
    );
  }
}

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  QuotesScreenState createState() => QuotesScreenState();
}

class QuotesScreenState extends State<QuotesScreen> {
  List<Quote> _quotes = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchQuotes();
  }

  Future<void> _fetchQuotes() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('quotes').get();

      setState(() {
        _quotes = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return Quote(
            id: doc.id,
            text: data['text'],
            author: data['author'],
          );
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching quotes: $e');

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quotes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                final quote = _quotes[index];

                return ListTile(
                  title: Text(quote.text),
                  subtitle: Text(quote.author),
                );
              },
            ),
    );
  }
}

class Quote {
  final String id;

  final String text;

  final String author;

  Quote({required this.id, required this.text, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json, String id) {
    return Quote(
      id: id,
      text: json['text'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
    };
  }
}
