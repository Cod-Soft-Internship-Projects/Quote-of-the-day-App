import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FavoriteQuoteScreen extends StatefulWidget {
  final String savedQuote;
  final String savedQuoteAuthorName;
  const FavoriteQuoteScreen(
      {super.key,
      required this.savedQuote,
      required this.savedQuoteAuthorName});

  @override
  State<FavoriteQuoteScreen> createState() => _FavoriteQuoteScreenState();
}

class _FavoriteQuoteScreenState extends State<FavoriteQuoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Quote'),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Container(decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.indigoAccent, Colors.white])),
        child: Center(
          child: Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Center(
                    child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.savedQuote,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.savedQuoteAuthorName,
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )),
                  InkWell(
                    onTap: () {
                      Share.share('${widget.savedQuote}\nBy: ${widget.savedQuoteAuthorName}');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white, Colors.grey]),                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Share',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.share_outlined),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
