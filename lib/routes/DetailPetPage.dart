import 'package:flutter/material.dart';
import 'package:lab_02/models_api/Pet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;//http

class DetailPetPage extends StatelessWidget {
  final int id;

  DetailPetPage(this.id);

  Future<Pet> fetchPet() async {
    final response = await http.get('http://pets.memoadian.com/api/pets/$id');

    print('http://pets.memoadian.com/api/pets/$id');

    if (response.statusCode == 200) {
      print(response.body);
      return Pet.fromJson(json.decode(response.body));
    } else {
      print('error');
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de Amigo"),
      ),
      body: FutureBuilder<Pet>(
        future: fetchPet(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            return Container(
              child: Card(//creamos una card
                margin: EdgeInsets.all(10.0),//margen de 10
                child: Column(//creamos una columna para colocar varios hijos
                  mainAxisSize: MainAxisSize.min,//definimos ualtura ajustable a contenido
                  children: <Widget>[//array
                    Container (//contenedor de imagen
                      padding: EdgeInsets.all(10.0),//padding
                      child: Image.network(snapshot.data.image),//imagen interna
                    ),
                    Container (//contenedor de texto
                      padding: EdgeInsets.all(10.0),//padding
                      child: Text(snapshot.data.name,//título
                        style: TextStyle(fontSize: 18)//estilo del texto
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(//descripción
                        snapshot.data.desc, textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }
}

/*
class PetPage extends StatefulWidget {
  final int id;
  PetPage(this.id);

  @override
  createState() => PetPageState(id);
}

class PetPageState extends State<PetPage> {
  final int id;
  Pet _pet = Pet();

  PetPageState(this.id);

  Future<Pet> fetchPet() async {
    final response = await http.get('http://pets.memoadian.com/api/pets/$id');

    if (response.statusCode == 200) {
      _pet = Pet.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fallo al cargar información del servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(//creamos una card
        margin: EdgeInsets.all(10.0),//margen de 10
        child: Column(//creamos una columna para colocar varios hijos
          mainAxisSize: MainAxisSize.min,//definimos ualtura ajustable a contenido
          children: <Widget>[//array
            Container (//contenedor de imagen
              padding: EdgeInsets.all(10.0),//padding
              child: Image.asset('images/logo_flutter.png'),//imagen interna
            ),
            Container (//contenedor de texto
              padding: EdgeInsets.all(10.0),//padding
              child: Text('Flutter 2',//título
                style: TextStyle(fontSize: 18)//estilo del texto
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(//descripción
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'+
                'Ut blandit porta lectus, ut vulputate ligula maximus quis.'+
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'+
                'Ut blandit porta lectus, ut vulputate ligula maximus quis.'
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/