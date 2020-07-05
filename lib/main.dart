import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riego IoT Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double sliderValue = 50;
  final TextEditingController humedadControler = TextEditingController();
  final TextEditingController duracionControler = TextEditingController();
  final TextEditingController horaInicio = TextEditingController();
  final TextEditingController minutoInicio = TextEditingController();
  final TextEditingController horaFin = TextEditingController();
  final TextEditingController minutoFin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riego IoT Firebase'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('config')
                    .document('raspberry')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Cargando');
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text('Cargando');
                      default:
                        return Form(
                          child: Column(
                            children: <Widget>[
                              Text('Valor de humedad configurado actual: ' +
                                  snapshot.data.data['humedad'].toString()),
                              TextFormField(
                                controller: humedadControler,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Modo Nocturno',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Valor de duración actual: ' +
                                    (snapshot.data.data['duracion'] / 60)
                                        .toString(),
                              ),
                              TextFormField(
                                controller: duracionControler,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(hintText: 'Minutos'),
                                validator: (val) {
                                  if (int.parse(val) < 0) {
                                    return 'Agrega un numero positivo';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Hora inicial actual: ' +
                                  snapshot.data.data['inicioNocturno']
                                      .toDate()
                                      .hour
                                      .toString() +
                                  ':' +
                                  snapshot.data.data['inicioNocturno']
                                      .toDate()
                                      .minute
                                      .toString()),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: horaInicio,
                                      decoration:
                                          InputDecoration(hintText: 'Hora'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: minutoInicio,
                                    decoration:
                                        InputDecoration(hintText: 'Minuto'),
                                  ))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Hora final actual: ' +
                                  snapshot.data.data['finNocturno']
                                      .toDate()
                                      .hour
                                      .toString() +
                                  ':' +
                                  snapshot.data.data['finNocturno']
                                      .toDate()
                                      .minute
                                      .toString()),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: horaFin,
                                      decoration:
                                          InputDecoration(hintText: 'Hora'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: minutoFin,
                                    decoration:
                                        InputDecoration(hintText: 'Minuto'),
                                  ))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: RaisedButton(
                                      child: Text('Configurar'),
                                      color: Colors.blue,
                                      elevation: 5.0,
                                      onPressed: () {
                                        print(duracionControler.text);
                                        print(horaInicio.text);
                                        print(minutoInicio.text);
                                        print(DateTime(
                                                2020,
                                                07,
                                                07,
                                                int.parse(horaInicio.text),
                                                int.parse(minutoInicio.text))
                                            .toString());
                                        Firestore.instance
                                            .collection('config')
                                            .document('raspberry')
                                            .setData({
                                          'humedad':
                                              int.parse(humedadControler.text),
                                          'duracion': int.parse(
                                                  duracionControler.text) *
                                              60,
                                          'inicioNocturno': DateTime(
                                              2020,
                                              07,
                                              07,
                                              int.parse(horaInicio.text),
                                              int.parse(minutoInicio.text)),
                                          'finNocturno': DateTime(
                                              2020,
                                              07,
                                              07,
                                              int.parse(horaFin.text),
                                              int.parse(minutoFin.text))
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                    }
                  }
                }),
          ),
        ),
      ),
    );
  }
}
