import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'search your contacts',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 1, 144, 113),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close)),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 1, 144, 113), width: 2)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            )
          ],
        ),
      ),
    );
  }
}
