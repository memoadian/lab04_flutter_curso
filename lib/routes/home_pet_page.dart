import 'package:flutter/material.dart';
//import 'package:lab_02/routes/DetailPetPage.dart';
import 'package:lab_04_flutter_curso/pages/pets_list.dart'; //importamos PetsList

class HomePetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PetsList(), //lista de amigos
    );
  }
}
