import 'package:flutter/material.dart'; //material
import 'package:lab_04_flutter_curso/models_api/pet.dart'; //clase Pet
import 'package:lab_04_flutter_curso/routes/detail_pet_page.dart'; //clase Detail Pet

import 'dart:convert'; //dependencia para json
import 'package:http/http.dart' as http; //http

class PetsList extends StatefulWidget {
  @override
  createState() => PetsListState();
}

class PetsListState extends State<PetsList> {
  //creamos una variable para guardar una lista de amigos
  List<Pet> _pets = [];

  @override
  void initState() {
    super.initState();
    getPets();
  }

  // declaramos la funcion de tipo Future Null asincrona
  Future<Null> getPets() async {
    //consumimos el webservice con la librería http y get
    final response =
        await http.get(Uri.parse("http://pets.memoadian.com/api/pets/"));

    //si la respuesta es correcta responderá con 200
    if (response.statusCode == 200) {
      final result =
          json.decode(response.body); //guardamos la respuesta en json
      /* accedemos al array data que es el que nos interesa
       * y lo guardamos en una variable de tipo Iterable
       */
      Iterable list = result['data'];
      setState(() {
        //seteamos el estado para actualizar los cambios
        //mapeamos la lista en modelos Pet
        print(list.map((model) => Pet.fromJson(model)).toString());
        _pets = list.map((model) => Pet.fromJson(model)).toList();
      });
    } else {
      throw Exception('Fallo al cargar información del servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //regresamos un Scaffold de contenedor
      body: ListView.builder(
        //creamos un Listview Builder
        itemCount: _pets.length, //pasamos la longitud del array list
        itemBuilder:
            _buildItemsForListView, //llamamos la función que hará la iteración
      ),
    );
  }

  /* 
   * la función _buildItemsForListView recibe 2 parámetros, el contexto
   * y la posición del item a mostrar para mostrar detalles
   * retornamos el Card que construimos en Home Page
  */
  Widget _buildItemsForListView(BuildContext context, int index) {
    return Card(
      //creamos una card
      margin: EdgeInsets.all(10.0), //margen de 10
      child: Column(
        //creamos una columna para colocar varios hijos
        children: <Widget>[
          //array
          Container(
            //contenedor de imagen
            padding: EdgeInsets.all(10.0), //padding
            child: Image.network(_pets[index].image), //imagen interna
          ),
          Container(
            //contenedor de texto
            padding: EdgeInsets.all(10.0), //padding
            child: Text(_pets[index].name, //título
                style: TextStyle(fontSize: 18) //estilo del texto
                ),
          ),
          Container(
            child: TextButton.icon(
              //instancia del icono de navegación
              icon: Icon(Icons.remove_red_eye, //definimos nombre del icono
                  size: 18.0, //tamaño
                  color: Colors.blue //color
                  ),
              label: Text('Ver amigo'), //nombre del botón
              onPressed: () {
                //evento press
                Navigator.pushNamed(
                  context,
                  'detail',
                  arguments: {'id': _pets[index].id},
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
