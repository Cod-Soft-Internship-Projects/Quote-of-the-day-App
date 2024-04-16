import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quote_of_the_day_app/favorite_quotes_list_screen.dart';
import 'package:quote_of_the_day_app/services/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Random randomQuote = Random();
  int randomQuoteId = 0;
  var data;
  bool isFavAvailable = false;

  Future<bool> checkFavAvailable() async {
    List<Map<String, dynamic>> favItems =
        await DatabaseHelper.instance.readRecord();
    for (var favItem in favItems) {
      if (favItem[DatabaseHelper.columnFavQuote] ==
              data[randomQuoteId]['text'] &&
          favItem[DatabaseHelper.columnFavQuoteAuthorName] ==
              data[randomQuoteId]['author']) {
        return true;
      }
    }
    return false;
  }

  Future<void> getQuotesApiData() async {
    final response = await http.get(Uri.parse('https://type.fit/api/quotes'));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
      print('Success');
    } else {
      print('Error with status code: ' + response.statusCode.toString());
    }
  }

  @override
  void initState() {
    randomQuoteId = randomQuote.nextInt(15);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote of the day'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          InkWell(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoriteQuotesListScreen()));
                setState(() {});
              },
              child: Icon(Icons.favorite)),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.indigoAccent, Colors.white])),
        child: Center(
          child: Container(
            height: 300,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10)),
            child: FutureBuilder(
                future: getQuotesApiData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text(
                        'Loading...',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.format_quote,size: 30,),
                            Text(
                              data != null
                                  ? data[randomQuoteId]['text']
                                  : 'Loading...',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  data != null ? data[randomQuoteId]['author'] : '',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FutureBuilder(
                                    future: checkFavAvailable(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data == false) {
                                        return InkWell(
                                          onTap: () {
                                            insert();
                                            setState(() {});
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(Icons.favorite_outline)
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return InkWell(
                                          onTap: () {},
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Saved',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(Icons.favorite)
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                                InkWell(
                                  onTap: () {
                                    Share.share(data[randomQuoteId]['text'] +
                                        '\nBy: ' +
                                        data[randomQuoteId]['author']);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Share',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.share_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          randomQuoteId = randomQuote.nextInt(15);

          setState(() {});
        },
        child: Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  insert() async {
    await DatabaseHelper.instance.insertRecord({
      DatabaseHelper.columnFavQuote: data[randomQuoteId]['text'],
      DatabaseHelper.columnFavQuoteAuthorName: data[randomQuoteId]['author']
    });
  }
}
