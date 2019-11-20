class Pet { // creamos una clase Pet
  //creamos las variables para cada propiedad
  final int id;
  final String name;
  final String desc;
  final int age;
  final String image;
  final String type;
  final int typeId;
  final String status;
  final int statusId;

  //asignamos las variables en el constructor
  Pet({
    this.id,
    this.name,
    this.desc,
    this.age,
    this.image,
    this.type,
    this.typeId,
    this.status,
    this.statusId
  });

  /* mapeamos la respuesta para usarla más facilmente
   * en los items y clases de la aplicación
   * */
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      age: json['age'],
      image: json['image'] ?? 'logo_flutter.png',
      typeId: json['type']['id'],
      type: json['type']['name'],
      status: json['status']['name']
    );
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map['name'] = name;
    map['desc'] = desc;
    map['age'] = age.toString();
    map['image'] = image;
    map['typeId'] = typeId.toString();
    map['statusId'] = statusId.toString();
 
    return map;
  }
}










