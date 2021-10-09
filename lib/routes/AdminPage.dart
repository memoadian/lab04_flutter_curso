import 'package:flutter/material.dart';
import 'package:lab_04_flutter_curso/routes/AddPetPage.dart';
import 'package:lab_04_flutter_curso/routes/EditPetPage.dart'; //importamos Añadir amigo
import 'package:lab_04_flutter_curso/models_api/Pet.dart'; //importamos el mdoelo Pet.dart+
import 'dart:convert'; //json
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  @override
  createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  //declaramos la variable que guardará la lista de elementos
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
    /*
     * llamamos una función que retornará el widget
     * que contiene las tabs de navegación entre un
     * contenido y otro
    */
    return tabs(context);
  }

  Widget tabs(BuildContext context) {
    return DefaultTabController(
      //este Widget es el que crea las tabs
      length: 2, //pasamos el numero de tabs a mostrar
      child: Scaffold(
        //retornamos un scaffold
        appBar: AppBar(
          //colocamos el appbar aquí adentro
          bottom: TabBar(
            //colocamos el tabbar
            tabs: [
              //array de tabs
              Tab(text: 'Favoritos'), //texto de la pestaña
              Tab(text: 'Todos'), //texto de la pestaña
            ],
          ),
          title: Text('Más Petamigos'), //titulo de la appbar
        ),
        body: TabBarView(
          //body del tabbar controller
          children: [
            //array (debe ser el mismo que se declara en length)
            favs(context), //función favoritos
            server(context), //función server
          ],
        ),
        //declaramos un floating button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //evento press
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPetPage(), //navegamos a añadir amigo
              ),
            );
          },
          child: Icon(Icons.add), //ícono del botón
          backgroundColor: Colors.blue, //color del botón
        ),
      ),
    );
  }

  Widget favs(BuildContext context) {
    //añadimos un param context para la ruta
    return ListView(//cambiamos el texto por un listView
        children: <Widget>[
      //array
      Divider(height: 15.0), //espacio por encima del primer listview
      Card(
        //card
        margin: EdgeInsets.all(5.0), //margen
        child: ListTile(
          //Listile para ordenar
          title: Text('Amigo'), //titulo
          subtitle: Text('Edad: 0 años'), //subtitulo
          leading: Image.asset('assets/logo_flutter.png'), //icono
          trailing: Row(
            //Row para acomodar iconos al final
            mainAxisSize: MainAxisSize.min, //ordenamiento horizontal
            children: <Widget>[
              //array
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //navegar a editar amigo
                      builder: (context) => EditPetPage(1),
                    ),
                  );
                },
              ),
              IconButton(
                //icono con botón
                icon: Icon(Icons.delete), //icono
                onPressed: () {}, //evento press eliminar
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget server(BuildContext context) {
    return ListView.builder(
      //listview builder
      itemCount: _pets.length, //contamos los elementos de la lista
      itemBuilder:
          _petsBuilder, //llamamos a la función que renderiza cada elemento
    );
  }

  Widget _petsBuilder(BuildContext context, int pos) {
    return Card(
      //card
      margin: EdgeInsets.all(5.0), //margen
      child: ListTile(
        //Listile para ordenar
        //obtenemos el nombre del array pets propiedad name
        title: Text(_pets[pos].name),
        subtitle: Text('Edad: ${_pets[pos].age}'), //edad
        leading: Column(
          //creamos una columna para contener la imagen
          children: <Widget>[
            //array
            Padding(padding: EdgeInsets.all(0)), //padding
            ClipRRect(
              //haremos que la imagen tenga borde redondeado
              //al 100% para que sea circular
              borderRadius: new BorderRadius.circular(100.0),
              child: Image.network(
                //imagen de internet
                _pets[pos].image, //propiedad imagen
                height: 50.0, //alto
                width: 50.0, //ancho
              ),
            )
          ],
        ),
        trailing: Row(
          //Row para  iconos al final
          mainAxisSize: MainAxisSize.min, //ordenamiento horizontal
          children: <Widget>[
            //array
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      //navegar a editar amigo
                      builder: (context) => EditPetPage(_pets[pos].id)),
                );
              },
            ),
            IconButton(
              //icono con botón
              icon: Icon(Icons.delete), //icono
              //evento press eliminar llevará los parámetros contexto
              //la posicion del elemento, y el id para consumir el ws
              onPressed: () => deleteAlert(context, pos, _pets[pos].id),
            ),
          ],
        ),
      ),
    );
  }

  //función asincrona estandar para un alert
  Future deleteAlert(BuildContext context, int position, int id) async {
    return showDialog<Null>(
      //funcion showDialog
      context: context, //declaramos el contexto de la alerta
      builder: (BuildContext context) {
        //iniciamos el builder
        return AlertDialog(
          //retornamos un AlertDialog
          title: Text('Confirmar'), //titulo del alert
          content: const Text('Esta acción no puede deshacerse'), //body
          actions: <Widget>[
            //array de botones
            TextButton(
              //botón cancelar
              child: Text('Cancelar'), //texto del botón cancelar
              onPressed: () {
                //al presionar
                Navigator.of(context).pop(); //cerramos el alert
              },
            ),
            TextButton(
              //botón confirmar
              child: Text('Eliminar'), //texto del botón de confirmar
              onPressed: () {
                //al presionar
                //llamamos la función que elimina el elemento
                deletePet(context, position, id);
              },
            ),
          ],
        );
      },
    );
  }

  //funcion asincrona para eliminar elementos del servidor por ID
  void deletePet(context, int position, int id) async {
    String url = 'http://pets.memoadian.com/api/pets/$id'; //url

    //metodo delete
    return http.delete(Uri.parse(url)).then((http.Response response) {
      final int statusCode = response.statusCode;

      // si el status es erroneo
      if (statusCode < 200 || statusCode > 400) {
        print(response.body); //imprimimos el error en consola
        //y creamos una excepcion
        throw new Exception('Error al consumir el servicio');
      }

      //si todo sale bien.
      setState(() {
        //eliminamos el elemento de la vista
        _pets.removeAt(position);
      });

      // y cerramos el alert dialog
      Navigator.of(context).pop();
    });
  }
}
