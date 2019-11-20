import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:lab_02/models_api/Pet.dart';
import 'package:lab_02/main.dart';

class AddPetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir Amigo"),
      ),
      body: FormAddPet()
    );
  }
}

class FormAddPet extends StatefulWidget {
  @override
  createState() => FormAddPetState();
}

class FormAddPetState extends State<FormAddPet> {
  //declaramos una variable donde guardaremos el item seleccionado
  String _selectedType = 'Por favor escoge';
  String _selectedTypeId;
  //variable auxiliar SwitchListTile
  bool _rescue = false;
  //image file for picker image
  File _imageFile;
  ProgressDialog pr;

  //global key para validar
  GlobalKey<FormState> _formKey = GlobalKey();

  bool _validate = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  List<PetKeyValue> _data = [
    PetKeyValue(key: 'Perrito', value: '1'),
    PetKeyValue(key: 'Gatito', value: '2'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(//creamos una vista scrolleable
      child: Form(//añadimos un form
        key: _formKey, //añadimos la llave a nuestro form
        autovalidate: _validate,
        child: _form(),//llamamos desde aqui la funcion que construye el form
      ),
    );
  }

  Widget _form () {
    return Container(//añadimos un contenedor
      padding: EdgeInsets.all(10.0),//padding
      child: Column(//column para multiples hijos
        children: <Widget>[//array
          TextFormField(//text form field para validar
            controller: titleController,
            decoration: InputDecoration(
              icon: Icon(Icons.pets),//añadimos un icono
              hintText: 'Nombre', //placeholder
              labelText: 'Nombre:' //label
            ),
            maxLength: 32,
            //usamos una función flecha para llamar la función validar
            validator: (value) => _validReq(value, 'Coloca un nombre a tu amigo'),
          ),
          TextFormField(//text form field para validar
            controller: descriptionController,
            //keyboard type multiline para escribir texto largo
            keyboardType: TextInputType.multiline,
            maxLines: null,//definimos null para no poner limites
            decoration: InputDecoration(
              icon: Icon(Icons.book),//añadimos un icono
              hintText: 'Descripción', //placeholder
              labelText: 'Descripción:' //label
            ),
            maxLength: 512,
            validator: (value) => _validReq(value, 'Agrega una descripción'),
          ),
          TextFormField(//text form field para validar
            controller: ageController,
            //input de tipo numérico
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              icon: Icon(Icons.date_range),//añadimos un icono
              hintText: 'Edad en años', //placeholder
              labelText: 'Edad (Años):' //label
            ),
            maxLength: 2,
            validator: (value) => _validAge(value, 'Coloca la edad aproximada de tu amigo'),
          ),
          Container(//agregamos un container para manejar espacios
            padding: EdgeInsets.only(left: 5.0, top: 10.0),//padding left y top
            child: DropdownButton<PetKeyValue>(//Declaramos el widget dropdown
              hint: Text(_selectedType),//texto placeholder
              isExpanded: true,//expandimos el elemento al 100%
              items: _data.map((data) {//mapeamos el array de tipos
                return DropdownMenuItem<PetKeyValue>(//retornamos cada item
                  value: data,//valor
                  child: Text(data.key),//texto del valor
                );
              }).toList(),//convertimos en lista
              onChanged: (PetKeyValue value) {//evento change
                _selectedType = value.key;
                setState(() {//seteamos el estado
                  _selectedTypeId = value.value;//cambiamos el elemento seleccionado
                });
              },
            ),
          ),
          //usamos switch list tile en lugar de switch para colocar un
          //label a la izquierda y no centrar el switch
          SwitchListTile(
            title: Text('Rescatado'),//label
            value: _rescue,//activo o inactivo
            onChanged: (bool value) {//evento change param bool
              setState(() {//set state dentro de stateful widget
                _rescue = value;//seteamos el nuevo valor de _rescue
              });
            },
          ),
          _chooseImage(context),
          SizedBox(//sized box permite manejar dimensiones de sus hijos
            width: double.infinity,//colocamos un ancho que se ajuste al padre
            child: RaisedButton(//declaramos el botón sin icono
              onPressed: () => _validateForm(),//al presionar llamamos la funcion validar
              color: Colors.blue,//color
              textColor: Colors.white,//color de texto
              //usamos stack para colocar el icono
              //este elemento nos permite posicionar elementos
              //superpuestos en otros sin afectar espacios
              child: Stack(
                alignment: Alignment.centerLeft,//alineamos al centro a la izquierda
                children: <Widget>[//array de hijos
                  Icon(Icons.send),//icono
                  //colocamos un row para contener el label y ocupar
                  //todo el ancho disponible del botón
                  Row(
                    //centramos el texto
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[//array
                      Text('Enviar')//texto, aqui centrar no sirve
                    ]
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //función escoger imagen
  Widget _chooseImage(BuildContext context) {
    return Center(//centrareamos la imagen
      child: Column(//columna para usar array
        children: <Widget>[//array
          _imageDefault(),//llamamos la funcion imagen por defecto
          RaisedButton(//botón para seleccionar imagen
            child: Text('Escoger Imágen'),//Texto del botón
            //evento press que llama la función para seleccionar
            //imagen pasando la fuente gallery o camera
            onPressed: () => _pickImage(ImageSource.gallery)
          )
        ],
      ),
    );
  }

  _pickImage(ImageSource source) async {//funcion asincrona
    //asignamos la fuente a la variable _imageFile
    _imageFile = await ImagePicker.pickImage(source: source);
    setState(() {//función set state
      //asignamos la variable para que se refleje en la vista
      _imageFile = _imageFile;
    });
  }

  Widget _imageDefault () {//widget imagen por defecto
    return FutureBuilder<File>(//retornamos un future builder de la imagen
      builder: (context, snapshot) {//snapshot de la imagen seleccionada
        return Container(//contenedor
          child: _imageFile == null //si la imagen es nula
                ? Text ('Seleccionar imagen')//colocamos un texto
                //si no es nula retornamos la imagen seleccionada
                : Image.file(_imageFile, width: 300, height: 300),
        );
      }
    );
  }

  void _validateForm () {
    if (_formKey.currentState.validate()) {
      pr = new ProgressDialog(context, 
        type: ProgressDialogType.Normal,
        isDismissible: false,
      );
      pr.show();

      Pet newPet = Pet(
        name: titleController.text,
        desc: descriptionController.text,
        age: (ageController.text != '') ? int.parse(ageController.text) : 0,
        image: _getImage(),
        typeId: int.parse(_selectedTypeId),
        statusId: (_rescue) ? 2 : 1,
      );

      createPost('http://pets.memoadian.com/api/pets', body: newPet.toMap());
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  String _validReq (String value, String message) {
    //colocamos un condicional corto
    return (value.length == 0) ? message : null;
  }

  String _validAge (String value, String message) {//validar edad
    String patttern = r'(^[0-9]+$)';//usamos un regex para 2 digitos
    RegExp regExp = RegExp(patttern);//instanciamos la clase
    if (value.length == 0) {//validamos primero si no esun input vacío
      return message;//retornamos el mensaje personalizado
    } else if (!regExp.hasMatch(value)) {//validamos si el contenido hace match
      return 'La edad debe ser un número';//retornamos mensaje por defecto
    } else {//si todo está bien
      return null;//retornamos null
    }
  }

  String _getImage () {
    if (_imageFile == null) return '';
    String base64Image = base64Encode(_imageFile.readAsBytesSync());
    return base64Image;
  }

  void createPost(String url, {Map body}) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
  
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print(response.body);
        pr.dismiss();
        throw new Exception("Error while fetching data"+response.body);
      }
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
    });
  }
}

class PetKeyValue {
  String key;
  String value;

  PetKeyValue({this.key, this.value});
}