import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_scraper/web_scraper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _productId = 0;
  var _inStock = false;
  var _price = '0.0';
  var _name = '';

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Linki yapıştır:',
            ),
            //text input
            TextField(
              decoration: const InputDecoration(

              ),
              onChanged: (String value) {
                setState(() {
                  _productId = int.parse(value);
                  checkStocks(_productId);
                });
              },
            ),

            Text(
              '$_name stokta ${_inStock ? 'var' : 'yok'}',
            ),
            Text(
              '${_inStock ? _price : ''}',
            ),

          ],
        ),


      ),
    );
  }

  void checkStocks(int productId) async {

    //http get request https://public.trendyol.com/discovery-web-productgw-service/api/productDetail/65404865
    var url =
    Uri.https('public.trendyol.com', '/discovery-web-productgw-service/api/productDetail/$productId', {'q': '{https}'});
    var response = await http.get(url);
    //get x.result.variants[0].stock in json
    var json = jsonDecode(response.body);
    // x.result.hasStock
    var stock = json['result']['hasStock'] as bool;
    //get x.result.variants[0].price.discountedPrice.text
    var price = json['result']['variants'][0]['price']['discountedPrice']['text'];
    _price = price;
    _inStock = stock;
    _name = json['result']['name'];
    print(_inStock ? '$price' : 'Out of stock');

  }
}
