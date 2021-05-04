
import 'package:flutter/material.dart';

import 'package:flutter_mask/model/store_list.dart';
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
  final List<Store> stores = [];

  var isLoading = true;

  Future fetch() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse(
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json');
    var response = await http.get(uri);

    var jsonResult = jsonDecode(utf8.decode(response.bodyBytes));

    var jsonStores = jsonResult['stores'];


    setState(() {
      stores.clear();
      jsonStores.forEach((e) {
        stores.add(Store.fromJson(e));
      });
      isLoading = false;
    });
    print('fetch완료');
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('마스크 재고 있는곳: ${stores.length}곳'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: fetch,
            )
          ],
        ),
        body: isLoading == true
            ? loadingWidget()
            : ListView(
                children: stores.map((store) {
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
      case 'plenty' :
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some' :
        remainStat = '보통';
        description = '30 ~ 100개 이상';
        color = Colors.yellow;
        break;
      case 'few' :
        remainStat = '부족';
        description = '2 ~ 30개 이상';
        color = Colors.red;
        break;
      case 'empty' :
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
