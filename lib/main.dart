import 'package:flutter/material.dart';

import 'package:flutter_mask/model/store_list.dart';
import 'package:flutter_mask/repository/store_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Store> stores = [];
  var isLoading = false;

  final storeRepository = StoreRepository();

  @override
  void initState() {
    super.initState();

    storeRepository.fetch().then((value) {
      setState(() {
        stores = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('마스크 재고 있는곳: ${stores.where((store) {
            return store.remainStat == 'plenty' ||
                store.remainStat == 'some' ||
                store.remainStat == 'few';
          }).length}곳'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                storeRepository.fetch().then((value) {
                  setState(() {
                    stores = value;
                  });
                });
              },
            )
          ],
        ),
        body: isLoading == true
            ? loadingWidget()
            : ListView(
                children: stores.where((store) {
                  return store.remainStat == 'plenty' ||
                      store.remainStat == 'some' ||
                      store.remainStat == 'few';
                }).map((store) {
                  return ListTile(
                    title: Text(store.name),
                    subtitle: Text(store.addr),
                    trailing: _buildRemainStatWidget(store),
                  );
                }).toList(),
              ));
  }

  Widget _buildRemainStatWidget(Store store) {
    var remainStat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;
    if (store.remainStat == 'plenty') {
      remainStat = '충분';
      description = '100개 이상';
      color = Colors.green;
    }
    switch (store.remainStat) {
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        remainStat = '보통';
        description = '30 ~ 100개 이상';
        color = Colors.yellow;
        break;
      case 'few':
        remainStat = '부족';
        description = '2 ~ 30개 이상';
        color = Colors.red;
        break;
      case 'empty':
        remainStat = '소진임박';
        description = '소진임박';
        color = Colors.grey;
        break;
      default:
    }

    return Column(
      children: [
        Text(
          remainStat,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('정보를 가져오는 중'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
