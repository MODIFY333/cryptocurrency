import 'dart:io';

import 'package:cryptocurrency/CCData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CCList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CCListState();
  }
}

class CCListState extends State<CCList> {
  List<CCData> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        elevation: 0,
        title: Text(
          'Криптовалютный трекер',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadCC(),
        child: Container(
          child: ListView(
            children: _buildList(),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.refresh),
      //   onPressed: () => _loadCC(),
      // ),
    );
  }

  Future<void> _loadCC() async {
    final response =
        await http.get('https://api.coincap.io/v2/assets?limit=15');
    if (response.statusCode == 200) {
      var allData = (json.decode(response.body) as Map)['data'];
      var ccDataList = List<CCData>();
      allData.forEach((val) {
        var record = CCData(
          name: val['name'],
          symbol: val['symbol'],
          price: double.parse(val['priceUsd']),
          rank: int.parse(val['rank']),
          percent: double.parse(val['changePercent24Hr']),
          supply: double.parse(val['supply']),
          marketCapUsd: double.parse(val['marketCapUsd']),
        );
        ccDataList.add(record);
      });
      setState(() {
        data = ccDataList;
      });
    }
  }

  List<Widget> _buildList() {
    return data
        .map((CCData f) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return MaterialApp(
                      themeMode: ThemeMode.system,
                      theme: ThemeData(
                        brightness: Brightness.light,
                        primaryColor: Colors.teal[400],
                      ),
                      darkTheme: ThemeData(
                        brightness: Brightness.dark,
                        accentColor: Colors.teal[700],
                      ),
                      debugShowCheckedModeBanner: false,
                      home: Scaffold(
                        appBar: AppBar(
                          elevation: 0,
                          backgroundColor: Colors.teal[400],
                          leading: IconButton(
                            iconSize: 25,
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () => Navigator.pop(context),
                          ),
                          title: Text(
                            f.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        body: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.deepOrange[200],
                                  radius: 90,
                                  child: Text(
                                    f.symbol.toString(),
                                    style: TextStyle(
                                        fontSize: 55, color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 13),
                                Text(
                                  'Ранг: ${f.rank.toString()}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                // Text('${f.supply.toStringAsFixed(3)}'),
                                SizedBox(height: 13),
                                Text(
                                  'Количество токенов: ${f.supply.toStringAsFixed(0)}',
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(height: 13),
                                Text(
                                  'Рыночная капитализация: \$${f.marketCapUsd.toStringAsFixed(0)}',
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(height: 13),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ));
              },
              child: ListTile(
                subtitle: f.percent > 0
                    ? Text(
                        '\+${f.percent.toStringAsFixed(2)}\%',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        '${f.percent.toStringAsFixed(2)}\%',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                title: Text(
                  f.name,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '\$${f.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadCC();
  }
}
