import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


const request = 'https://api.hgbrasil.com/finance';

void main() async {

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController();

  double dolar;
  double euro;
  double libra;

  void _realChanges(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    libraController.text = (real/libra).toStringAsFixed(2);
  }

  void _dolarChanges(String text){
    double dolar = double.parse(text);
    double aux = dolar * this.dolar;
    realController.text = (aux).toStringAsFixed(2);
    euroController.text = (aux/euro).toStringAsFixed(2);
    libraController.text = (aux/libra).toStringAsFixed(2);
  }

  void _euroChanges(String text){
    double euro = double.parse(text);
    double aux = euro * this.euro;
    realController.text = (aux).toStringAsFixed(2);
    dolarController.text = (aux/dolar).toStringAsFixed(2);
    libraController.text = (aux/libra).toStringAsFixed(2);
  }

  void _libraChanges(String text){
    double libra = double.parse(text);
    double aux = libra * this.libra;
    realController.text = (aux).toStringAsFixed(2);
    dolarController.text = (aux/dolar).toStringAsFixed(2);
    euroController.text = (aux/euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future:getData(),
        builder: (context,snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando os Dados....",
                  style: TextStyle(color: Colors.amber,fontSize: 25.0),
                   textAlign: TextAlign.center,
                ),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao carregar Dados",
                    style: TextStyle(color: Colors.amber,fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              }else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,size: 120.0,color: Colors.amber,),

                      buildTextField("Reais","R\$", realController, _realChanges ),
                      Divider(),
                      buildTextField("Dólares","US\$",dolarController,_dolarChanges),
                      Divider(),
                      buildTextField("Euros","€",euroController,_euroChanges),
                      Divider(),
                      buildTextField("Libras","£",libraController,_libraChanges),


                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}


Widget buildTextField(String label, String prefix,TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color:Colors.amber,fontSize: 20.0),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(color: Colors.amber,fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
