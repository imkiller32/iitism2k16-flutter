import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Module {
  List data;
  Future<List> getJsonData(String url) async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print('hell' + response.toString());
    // if (response != 200) {
    //   showDes('Can' + 't Connect to network');
    //   return data;
    // }
    var convertDataToJson = json.decode(response.body);
    data = convertDataToJson;
    return data;
  }
}

bool pdfTheme = false;
Future<Null> getThemeFromShared() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  pdfTheme = prefs.getBool('PdfTheme') ?? false;
}

class AdditionalSettings {
  bool darkTheme;
  bool pdfDarkTheme;

  AdditionalSettings(darkTheme, pdfDarkTheme) {
    getThemeFromShared();
    pdfDarkTheme = pdfTheme;
    this.darkTheme = darkTheme;
    this.pdfDarkTheme = pdfDarkTheme;
  }

  void setTheme(darkTheme) {
    this.darkTheme = darkTheme;
  }

  void setPdf(pdfDarkTheme) {
    this.pdfDarkTheme = pdfDarkTheme;
  }

  bool getTheme() {
    return this.darkTheme;
  }

  bool getPdfTheme() {
    return this.pdfDarkTheme;
  }
}

AdditionalSettings additionalSettings = AdditionalSettings(false, false);