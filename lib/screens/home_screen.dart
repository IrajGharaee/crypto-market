import 'package:crypto_market/screens/coin_list_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data/model/crypto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[800],
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/logo.png'),
              ),
              SpinKitWave(
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinListScreen(
          cryptoList: cryptoList,
        ),
      ),
    );
  }
}
