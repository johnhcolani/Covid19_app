import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid19_app/screens/showCountries.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowCountriesInfo extends StatefulWidget {
  final country;
  ShowCountriesInfo({required this.country});
  @override
  _ShowCountriesInfoState createState() => _ShowCountriesInfoState();
}

class _ShowCountriesInfoState extends State<ShowCountriesInfo> {

  List items = [];
  bool loading = true;
  var toDate;
  var fromDate;
  var date = DateTime.now();



  @override
  void initState() {
    super.initState();
    toDate = date.toString().split(" ")[0];
    fromDate = DateTime(date.year, date.month-2, date.day).toString().split(" ")[0];
   print(fromDate);
    _setData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
               SliverAppBar(
                 pinned: true,
                title: Text('${widget.country['Slug']}'),
                backgroundColor: Colors.teal,
                
              )
            ];
          },
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const SpinKitSpinningLines(
        color: Colors.teal,
        size: 120.0,
      );
    }
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = items[index];
                  if(index==0){
                    return Container();
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      elevation: 3,
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Confirmed:${items[index]['Confirmed']-items[index-1]['Confirmed']}',style: TextStyle(color: Colors.black),),
                            Text('Active:${items[index]['Active']-items[index-1]['Active']}'),
                            Text('Deaths:${items[index]['Deaths']-items[index-1]['Deaths']}')
                          ],
                        ),
                        subtitle: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(

                              '${item['Date']}',
                              style: TextStyle(fontSize: 24,color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  void _setData() async {
    final response = await http.get(
      Uri.parse(
        'https://api.covid19api.com/country/${widget.country['Slug']}?from=${fromDate}T-00:00:00Z&to=${toDate}T00:00:00Z%27'),
          //'https://api.covid19api.com/country/${widget.country['Slug']}?from=${fromDate}T-00:00:00Z&to=${toDate}T00:00:00Z'),
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      items.addAll(jsonResponse);
      setState(() {
        loading = false;
      });
    } else {}
  }
}
