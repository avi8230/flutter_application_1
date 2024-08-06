import 'package:flutter/material.dart'; // מייבא את חבילת Flutter Material לעיצוב ממשק המשתמש.
import 'package:cloud_firestore/cloud_firestore.dart'; // מייבא את חבילת Cloud Firestore לשימוש במסד הנתונים של Firebase.

class QuotesRepository {
  final CollectionReference quotesCollection = FirebaseFirestore.instance.collection('quotes');

  Future<void> addQuote(String author, String text) async {
    await quotesCollection.add({
      'author': author,
      'text': text,
    });
  }

  Future<void> updateQuote(String id, String author, String text) async {
    await quotesCollection.doc(id).update({
      'author': author,
      'text': text,
    });
  }

  Future<void> deleteQuote(String id) async {
    await quotesCollection.doc(id).delete();
  }

  Stream<List<Quote>> getQuotes() {
    return quotesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Quote(
          id: doc.id,
          author: doc['author'],
          text: doc['text'],
        );
      }).toList();
    });
  }
}

class Quote {
  final String id;
  final String author;
  final String text;

  Quote({required this.id, required this.author, required this.text});
}
