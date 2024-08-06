
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await addQuotes();
  print('Quotes added successfully');
}

Future<void> addQuotes() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();
  int successCount = 0;
  int failureCount = 0;

  final quoteCollection = firestore.collection('quotes');
  int index = 0;
  for (var quote in quotes) {
    try {
      await quoteCollection.add({
        'text': quote['quote'],
        'author': quote['author_hebrew'],
      });
      print('Quote uploaded: ${quote['quote']}');
      successCount++;
    } catch (e) {
      print('Error uploading quote: $e');
      failureCount++;
    }
  }

  print('Seeding complete.');
  print('Successfully uploaded: $successCount');
  print('Failed uploads: $failureCount');

  // Exit the program
  exit(0);
}

final List<Map<String, String>> quotes = [
  {
    'quote': 'אֵיזֶהוּ חָכָם? הַלּוֹמֵד מִכָּל אָדָם',
    'translation': 'Who is wise? He who learns from every person.',
    'author': 'Ben Zoma, Pirkei Avot 4:1',
    'author_hebrew': 'בן זומא, פרקי אבות ד:א'
  },
  {
    'quote': 'בְּמָקוֹם שֶׁאֵין אֲנָשִׁים, הִשְׁתַּדֵּל לִהְיוֹת אִישׁ',
    'translation': 'In a place where there are no men, strive to be a man.',
    'author': 'Hillel, Pirkei Avot 2:5',
    'author_hebrew': 'הלל, פרקי אבות ב:ה'
  },
  {
    'quote':
        'אִם אֵין אֲנִי לִי, מִי לִי? וּכְשֶׁאֲנִי לְעַצְמִי, מָה אֲנִי? וְאִם לֹא עַכְשָׁיו, אֵימָתַי',
    'translation':
        'If I am not for myself, who will be for me? But if I am only for myself, what am I? And if not now, when?',
    'author': 'Hillel, Pirkei Avot 1:14',
    'author_hebrew': 'הלל, פרקי אבות א:יד'
  },
  {
    'quote':
        'עַל שְׁלֹשָׁה דְבָרִים הָעוֹלָם עוֹמֵד: עַל הַתּוֹרָה וְעַל הָעֲבוֹדָה וְעַל גְּמִילוּת חֲסָדִים',
    'translation':
        'The world stands on three things: on Torah, on service, and on acts of loving kindness.',
    'author': 'Shimon the Righteous, Pirkei Avot 1:2',
    'author_hebrew': 'שמעון הצדיק, פרקי אבות א:ב'
  },
  {
    'quote':
        'לֹא עָלֶיךָ הַמְּלָאכָה לִגְמֹר, וְלֹא אַתָּה בֶן חוֹרִין לִבָּטֵל מִמֶּנָּה',
    'translation':
        'It is not your duty to finish the work, but neither are you at liberty to neglect it.',
    'author': 'Rabbi Tarfon, Pirkei Avot 2:16',
    'author_hebrew': 'רבי טרפון, פרקי אבות ב:טז'
  },
  {
    'quote':
        'דַּע מַה לְּמַעְלָה מִמְּךָ עַיִן רוֹאָה וְאֹזֶן שׁוֹמַעַת וְכָל מַעֲשֶׂיךָ בַּסֵּפֶר נִכְתָּבִין',
    'translation':
        'Know what is above you: a seeing eye, a listening ear, and all your deeds being inscribed in a book.',
    'author': 'Rabbi Judah HaNasi, Pirkei Avot 2:1',
    'author_hebrew': 'רבי יהודה הנשיא, פרקי אבות ב:א'
  },
  {
    'quote': 'אֵיזֶהוּ עָשִׁיר? הַשָּׂמֵחַ בְּחֶלְקוֹ',
    'translation': 'Who is rich? He who is happy with his lot.',
    'author': 'Ben Zoma, Pirkei Avot 4:1',
    'author_hebrew': 'בן זומא, פרקי אבות ד:א'
  },
  {
    'quote': 'הֱוֵי מְקַבֵּל אֶת כָּל הָאָדָם בְּסֵבֶר פָּנִים יָפוֹת',
    'translation': 'Receive every person with a pleasant countenance.',
    'author': 'Shammai, Pirkei Avot 1:15',
    'author_hebrew': 'שמאי, פרקי אבות א:טו'
  },
  {
    'quote':
        'עֲשֵׂה תּוֹרָתְךָ קֶבַע, אֱמוֹר מְעַט וַעֲשֵׂה הַרְבֵּה, וֶהֱוֵי מְקַבֵּל אֶת כָּל הָאָדָם בְּסֵבֶר פָּנִים יָפוֹת',
    'translation':
        'Make your Torah study a fixed practice; say little and do much; and receive everyone with a cheerful face.',
    'author': 'Shammai, Pirkei Avot 1:15',
    'author_hebrew': 'שמאי, פרקי אבות א:טו'
  },
  {
    'quote': 'אַל תִּסְתַּכֵּל בַּקַּנְקַן, אֶלָּא בְמַה שֶּׁיֶּשׁ בּוֹ',
    'translation': 'Do not look at the vessel, but at what it contains.',
    'author': 'Rabbi Meir, Pirkei Avot 4:20',
    'author_hebrew': 'רבי מאיר, פרקי אבות ד:כ'
  },
  {
    'quote':
        'הַקִּנְאָה וְהַתַּאֲוָה וְהַכָּבוֹד מוֹצִיאִין אֶת הָאָדָם מִן הָעוֹלָם',
    'translation': 'Envy, lust and honor drive a person from the world.',
    'author': 'Rabbi Eliezer HaKappar, Pirkei Avot 4:21',
    'author_hebrew': 'רבי אליעזר הקפר, פרקי אבות ד:כא'
  },
  {
    'quote': 'יְהִי כְבוֹד חֲבֵרְךָ חָבִיב עָלֶיךָ כְּשֶׁלָּךְ',
    'translation': 'Let your friend\'s honor be as dear to you as your own.',
    'author': 'Rabbi Eliezer, Pirkei Avot 2:10',
    'author_hebrew': 'רבי אליעזר, פרקי אבות ב:י'
  },
  {
    'quote': 'הֱוֵי זָנָב לָאֲרָיוֹת, וְאַל תְּהִי רֹאשׁ לַשּׁוּעָלִים',
    'translation': 'Better to be a tail to lions than a head to foxes.',
    'author': 'Rabbi Matya ben Heresh, Pirkei Avot 4:15',
    'author_hebrew': 'רבי מתיא בן חרש, פרקי אבות ד:טו'
  },
  {
    'quote': 'אִם אֵין קֶמַח, אֵין תּוֹרָה; אִם אֵין תּוֹרָה, אֵין קֶמַח',
    'translation':
        'If there is no flour, there is no Torah; if there is no Torah, there is no flour.',
    'author': 'Rabbi Elazar ben Azariah, Pirkei Avot 3:17',
    'author_hebrew': 'רבי אלעזר בן עזריה, פרקי אבות ג:יז'
  },
  {
    'quote': 'לֹא הַבַּיְשָׁן לָמֵד',
    'translation': 'A shy person cannot learn.',
    'author': 'Hillel, Pirkei Avot 2:5',
    'author_hebrew': 'הלל, פרקי אבות ב:ה'
  },
  {
    'quote':
        'כָּל הַמְקַיֵּם נֶפֶשׁ אַחַת מִיִּשְׂרָאֵל, כְּאִלּוּ קִיֵּם עוֹלָם מָלֵא',
    'translation':
        'Whoever saves a single life is considered as if he saved an entire world.',
    'author': 'Mishnah Sanhedrin 4:5',
    'author_hebrew': 'משנה סנהדרין ד:ה'
  },
  {
    'quote': 'שְׁתִיקָה סְיָג לַחָכְמָה',
    'translation': 'Silence is a fence for wisdom.',
    'author': 'Rabbi Akiva, Pirkei Avot 3:13',
    'author_hebrew': 'רבי עקיבא, פרקי אבות ג:יג'
  },
  {
    'quote': 'אֵין הַבִּישָׁן לָמֵד, וְלֹא הַקַּפְּדָן מְלַמֵּד',
    'translation':
        'A bashful person cannot learn, nor can an impatient person teach.',
    'author': 'Hillel, Pirkei Avot 2:5',
    'author_hebrew': 'הלל, פרקי אבות ב:ה'
  },
  {
    'quote': 'הִלֵּל אוֹמֵר, אַל תִּפְרֹשׁ מִן הַצִּבּוּר',
    'translation': 'Hillel says: Do not separate yourself from the community.',
    'author': 'Hillel, Pirkei Avot 2:4',
    'author_hebrew': 'הלל, פרקי אבות ב:ד'
  },
];

