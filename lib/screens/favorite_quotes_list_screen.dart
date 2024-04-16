import 'package:flutter/material.dart';
import 'package:quote_of_the_day_app/screens/favorite_quote_screen.dart';
import 'package:quote_of_the_day_app/services/database_helper.dart';

class FavoriteQuotesListScreen extends StatefulWidget {
  const FavoriteQuotesListScreen({super.key});

  @override
  State<FavoriteQuotesListScreen> createState() =>
      _FavoriteQuotesListScreenState();
}

class _FavoriteQuotesListScreenState extends State<FavoriteQuotesListScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Quotes'),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: FutureBuilder(
              future: DatabaseHelper.instance.readRecord(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Saved Quotes',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FavoriteQuoteScreen(
                                              savedQuote: data[index]['favQuote'],
                                              savedQuoteAuthorName: data[index]
                                                  ['favQuoteAuthorName'],
                                            )));
                              },
                              tileColor: Colors.grey,
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage('assets/logo.jpg'),
                              ),
                              title: Text(
                                data[index]['favQuote'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                data[index]['favQuoteAuthorName'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black),
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  DatabaseHelper.instance.deleteRecord(data[index]['favQuotesId']);
                                  setState(() {
                                    
                                  });
                                },
                                child: const Icon(
                                  Icons.delete)),
                            ),
                          );
                        });
                  }
                }
                return const Center(
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
