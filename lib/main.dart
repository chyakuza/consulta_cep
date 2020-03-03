import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/cep.dart';
import 'services/cep_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ConsultaWsCep>.value(
          value: ConsultaWsCep(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(title: 'Consulta Cep - Flutter 2019'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  final _resultCep = StreamController<Cep>();
  Cep cep = Cep();

  @override
  void initState() {
    _loadCep();
    super.initState();
  }

  _loadCep() async {
    if (_controller.text.length == 8) {
      cep = await ConsultaWsCep.getCep(_controller.text);

      _resultCep.sink.add(cep);
    }

    if (_controller.text.length != 8) {
      print("Tamanho invalido");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _controller,
                decoration:
                    InputDecoration(labelText: "Digite CEP para consulta."),
              ),
            ),
            cepResultado(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _loadCep(),
        tooltip: 'Consultar CEP',
        child: Icon(Icons.find_replace),
      ),
    );
  }

  Widget cepResultado() {
    return StreamBuilder<Cep>(
        stream: _resultCep.stream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      // color: Colors.green[400],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.1, 1.0),
                            blurRadius: 5.0),
                      ]),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snapshot.data.logradouro,
                          style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold),),

                          Text(snapshot.data.bairro,
                          style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold),),
                                                  
                          Text("${snapshot.data.localidade}  ${snapshot.data.uf}" ,
                          style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold),),
                          Text("IBGE : ${snapshot.data.ibge}",
                          style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold),),
                          
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 200,
                  color: Colors.white,
                  child: Center(
                    child: Text("Cep não encontrado!"),
                  ),
                );
        });
  }
}
