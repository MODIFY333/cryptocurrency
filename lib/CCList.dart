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
        elevation: 0,
        title: Text('Crypto Tracker'),
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
        await http.get('https://api.coincap.io/v2/assets?limit=100');
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
        .map((CCData f) => ListTile(
              subtitle: f.percent > 0
                  ? Text(
                      '\+${f.percent.toStringAsFixed(3)}\%',
                      style: TextStyle(color: Colors.green),
                    )
                  : Text(
                      '${f.percent.toStringAsFixed(3)}\%',
                      style: TextStyle(color: Colors.red),
                    ),
              title: Text(f.name),
              leading: CircleAvatar(
                radius: 25,
                child: Text(f.symbol.toString()),
              ),
              trailing: Text('\$${f.price.toStringAsFixed(3)}'),
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadCC();
  }
}
