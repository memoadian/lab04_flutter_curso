import 'package:flutter/material.dart';
import 'package:lab_02/routes/AddPetPage.dart';
import 'package:lab_02/routes/EditPetPage.dart';//importamos Añadir amigo
import 'package:lab_02/models_api/Pet.dart';//importamos el mdoelo Pet.dart+
import 'dart:convert';//json
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget{
  @override
  createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage>{
  //declaramos la variable que guardará la lista de elementos
  List<Pet> _pets = List<Pet>();

  @override
  void initState() {
    super.initState();
    getPets();
  }

  // declaramos la funcion de tipo Future Null asincrona
  Future<Null> getPets() async {
    //consumimos el webservice con la librería http y get
    final response = await http.get('http://pets.memoadian.com/api/pets/');

    //si la respuesta es correcta responderá con 200
    if (response.statusCode == 200) {
      final result = json.decode(response.body);//guardamos la respuesta en json
      /* accedemos al array data que es el que nos interesa
       * y lo guardamos en una variable de tipo Iterable
       */
      Iterable list = result['data'];
      setState(() {//seteamos el estado para actualizar los cambios
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
    /*
     * llamamos una función que retornará el widget
     * que contiene las tabs de navegación entre un
     * contenido y otro
    */
    return tabs(context);
  }

  Widget tabs (BuildContext context) {
    return DefaultTabController(//este Widget es el que crea las tabs
        length: 2,//pasamos el numero de tabs a mostrar
        child: Scaffold(//retornamos un scaffold
          appBar: AppBar(//colocamos el appbar aquí adentro
            bottom: TabBar(//colocamos el tabbar
              tabs: [//array de tabs
                Tab(text: 'Favoritos'),//texto de la pestaña
                Tab(text: 'Todos'),//texto de la pestaña
              ],
            ),
            title: Text('Más Petamigos'),//titulo de la appbar
          ),
          body: TabBarView(//body del tabbar controller
            children: [//array (debe ser el mismo que se declara en length)
              favs(context),//función favoritos
              server(context),//función server
            ],
          ),
          //declaramos un floating button
          floatingActionButton: FloatingActionButton(
            onPressed: () {//evento press
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => AddPetPage(),//navegamos a añadir amigo
                ),
              );
            },
            child: Icon(Icons.add),//ícono del botón
            backgroundColor: Colors.blue,//color del botón
          ),
      ),
    );
  }

  Widget favs (BuildContext context) {//añadimos un param context para la ruta
    return ListView(//cambiamos el texto por un listView
      children: <Widget>[//array
        Divider(height: 15.0),//espacio por encima del primer listview
        Card(//card
          margin: EdgeInsets.all(5.0),//margen
          child: ListTile(//Listile para ordenar
            title: Text('Amigo'),//titulo
            subtitle: Text('Edad: 0 años'),//subtitulo
            leading: Image.asset('images/logo_flutter.png'),//icono
            trailing: Row(//Row para acomodar iconos al final
              mainAxisSize: MainAxisSize.min,//ordenamiento horizontal
              children: <Widget>[//array
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        //navegar a editar amigo
                        builder: (context) => EditPetPage()
                      ),
                    );
                  },
                ),
                IconButton(//icono con botón
                  icon: Icon(Icons.delete),//icono
                  onPressed: () {},//evento press eliminar
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget server (BuildContext context) {
    return ListView.builder(//listview builder
      itemCount: _pets.length,//contamos los elementos de la lista
      itemBuilder: _petsBuilder,//llamamos a la función que renderiza cada elemento
    );
  }

  Widget _petsBuilder (BuildContext context, int pos) {
    return Card(//card
      margin: EdgeInsets.all(5.0),//margen
      child: ListTile(//Listile para ordenar
        //obtenemos el nombre del array pets propiedad name
        title: Text(_pets[pos].name),
        subtitle: Text('Edad: ${_pets[pos].age}'),//edad
        leading: Column(//creamos una columna para contener la imagen
          children: <Widget>[//array
            Padding(padding: EdgeInsets.all(0)),//padding
            ClipRRect(//haremos que la imagen tenga borde redondeado
              //al 100% para que sea circular
              borderRadius: new BorderRadius.circular(100.0),
              child: Image.network(//imagen de internet
                  _pets[pos].image,//propiedad imagen
                  height: 50.0,//alto
                  width: 50.0,//ancho
              ),
            )
          ],
        ),
        trailing: Row(//Row para  iconos al final
          mainAxisSize: MainAxisSize.min,//ordenamiento horizontal
          children: <Widget>[//array
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(
                    //navegar a editar amigo
                    builder: (context) => EditPetPage()
                  ),
                );
              },
            ),
            IconButton(//icono con botón
              icon: Icon(Icons.delete),//icono
              onPressed: () {},//evento press eliminar
            ),
          ],
        ),
      ),
    );
  }
}