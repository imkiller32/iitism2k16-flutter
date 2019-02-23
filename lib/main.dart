import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'utils.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import 'contact_us.dart';
import 'help.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final String url = "http://liveism.xyz/fetch.php";
  List data;
  List<double> progress = [];

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  void jump(String value) {
    if (value == 'ContactUs')
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactUs()),
      );
    else if (value == 'Help')
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Help()),
      );
  }

  Future<void> check(String link, String id, int index) async {
    Dio dio = Dio();
    var dir = await getExternalStorageDirectory();
    showName("${dir.path}/" + id + ".pdf");
    print("${dir.path}/" + id + ".pdf");
    await dio.download(link, "${dir.path}/" + id + ".pdf",
        onProgress: (rec, total) {
      //showName("${dir.path}/" + id + ".pdf");
      setState(() {
        progress[index] = (rec / total);
      });
    });
  }

  Future<String> getJsonData() async {
    var response = await http.get(
        //encode the url
        Uri.encodeFull(url),
        //only accept json
        headers: {"Accept": "application/json"});
    print(response.body);
    var convertDataToJson = json.decode(response.body);
    print(convertDataToJson);
    data = convertDataToJson;
    int len = data.length;
    setState(() {
      for (int i = 0; i < len; i++) {
        progress.add(0);
      }
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/iitism.png',
              fit: BoxFit.contain,
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "iitism2k16",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    "#Be_Updated!",
                    style:
                        TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showName('Search');
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('ContactUs'),
                  value: 'ContactUs',
                ),
                PopupMenuItem(
                  child: Text('Help'),
                  value: 'Help',
                ),
              ];
            },
            onSelected: jump,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ObjectKey(data[index]['id']),
            onDismissed: (direction) {
              var toDelete = data.elementAt(index);
              setState(() {
                data.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(data[index]['name'].toUpperCase() + ' Deleted '),
                backgroundColor: Colors.black,
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    setState(() {
                      data.insert(index, toDelete);
                    });
                  },
                ),
              ));
            },
            background: stackBehindDismiss(),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        showName(data[index]['name']);
                      },
                      onLongPress: () {
                        showDes(data[index]['description']);
                      },
                      child: Card(
                        elevation: 7.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                              ),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10.0,
                                        left: 15.0,
                                        right: 10.0,
                                        bottom: 5.0),
                                    child: Image.network(
                                      data[index]['image'],
                                      width: 100.0,
                                      height: 100.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3.0, right: 10.0),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Text(
                                            data[index]['name']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              right: 10.0, top: 10.0),
                                          child: Text(
                                            data[index]['description'],
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              right: 10.0, top: 7.0),
                                          child: Text(
                                            "Uploaded on : " +
                                                data[index]['date'],
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //Padding(padding: const EdgeInsets.all(9.0)),
                              ButtonTheme.bar(
                                child: ButtonBar(
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text('View'),
                                      onPressed: () {
                                        openUrl(data[index]['link'],
                                            data[index]['name']);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Download'),
                                      onPressed: () {
                                        check(data[index]['link'],
                                            data[index]['id'], index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              LinearProgressIndicator(
                                  value: (progress[index] == null)
                                      ? 0
                                      : progress[index]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
