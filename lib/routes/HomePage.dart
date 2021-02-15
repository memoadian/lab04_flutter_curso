import 'package:flutter/material.dart';
//import 'package:lab_02/routes/DetailPetPage.dart';
import 'package:lab_04_flutter_curso/pages/PetsList.dart';//importamos PetsList

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PetsList(),//lista de amigos
    );
  }
}