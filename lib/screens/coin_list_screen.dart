import 'dart:async';

import 'package:crypto_market/data/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/model/crypto.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({Key? key, this.cryptoList}) : super(key: key);
  List<Crypto>? cryptoList;
  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? cryptoList;

  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Text(
          'کریپتو',
          style: TextStyle(fontFamily: 'mr'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (value) async {
                    searchCrypto(value);
                    print(value);
                    if (value.isEmpty) {
                      List<Crypto> freshList = await _refreshList();
                      setState(() {
                        cryptoList = freshList;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'جستجو نام رمز ارز',
                      hintStyle:
                          TextStyle(fontFamily: 'mr', color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.green),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: greenColor,
                backgroundColor: Colors.black,
                onRefresh: () async {
                  List<Crypto> freshData = await _refreshList();
                  setState(() {
                    cryptoList = freshData;
                  });
                },
                child: ListView.builder(
                    itemCount: cryptoList!.length,
                    itemBuilder: (context, index) {
                      return _getListTileItem(cryptoList![index]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(color: greyColor),
      ),
      leading: SizedBox(
        width: 30,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(color: greyColor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150.0,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                crypto.priceUsd.toStringAsFixed(2),
                style: TextStyle(color: greyColor, fontSize: 18),
              ),
              Text(
                crypto.changePercent24hr.toStringAsFixed(2),
                style: TextStyle(
                    color: _getColorChangeText(crypto.changePercent24hr)),
              ),
            ],
          ),
          SizedBox(
            width: 30.0,
            child: Center(
              child: _getIconChangePercent(crypto.changePercent24hr),
            ),
          )
        ]),
      ),
    );
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(Icons.trending_down, size: 20, color: redColor)
        : Icon(Icons.trending_up, size: 20, color: greenColor);
  }

  Color _getColorChangeText(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Future<List<Crypto>> _refreshList() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  void searchCrypto(String query) {
    List<Crypto>? newList = cryptoList!
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      cryptoList = newList;
    });
  }
}
