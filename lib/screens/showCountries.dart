import 'package:covid19_app/screens/showCountriesInfo.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowCountries extends StatefulWidget {
  @override
  _ShowCountriesState createState() => _ShowCountriesState();
}

class _ShowCountriesState extends State<ShowCountries> {
  TextEditingController searchController = TextEditingController();
  List countries = [];
  List items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _setData();
    print('this is State object');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('this is deactivated');
  }

  @override
  Widget build(BuildContext context) {
    print('this is build methode');
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                pinned: true,
                title: Text('Show Countries'),
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
          Container(
            padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
            child: TextField(
              controller: searchController,
              onChanged: (String value) {
                items.clear();
                if (value.isEmpty) {
                  items.addAll(countries);
                } else {
                  countries.forEach((element) {
                    if (element['Country']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase())) {
                      items.add(element);
                    }
                  });
                }

                setState(() {});
              },
              decoration: InputDecoration(
                focusColor: Colors.teal,
                labelText: "search",
                hintText: "search",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      searchController.clear();
                      items.clear();
                      items.addAll(countries);
                    });

                  },
                  icon: Icon(Icons.close),
                ),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  var country = items[index];
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Material(
                      elevation: 3,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ShowCountriesInfo(country: country);
                          }));
                        },
                        title: Text(
                          '${country['Country']}',
                          style: TextStyle(fontSize: 24),
                        ),
                        subtitle: Text('${country['Slug']}',
                            style: TextStyle(fontSize: 24)),
                        trailing: Container(
                          child: Image.asset(
                            "assets/flags/${country['ISO2'].toLowerCase()}.png",
                            width: 60,
                            height: 60,
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
      Uri.parse('https://api.covid19api.com/countries'),
    );
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      countries = jsonResponse;
      items.addAll(jsonResponse);
      setState(() {
        loading = false;
      });
    } else {}
  }
}
