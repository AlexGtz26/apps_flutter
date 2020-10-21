import 'package:flutter/cupertino.dart';

class Articles{

  int ID; // +  ID: identificador unico del articulo dependiendo de la sección donde se solicite, se conforma del # de categoria mas el num del articulo en wordpress DB
  int num; // + num: numero unico e identificador del articulo en la base de datos del servidor.
  String image; // + image: imagen del articulo
  String title;// + title: titulo del mismo
  String content; // + content: contenido
  int category; // + category: categoria a la que pertenece (inicio=2, becas=3, emergencias=4, etc)
  String url; //+ La url del articulo 
  String localuser; //localuser: campo unicamente usado en la tabla de articulos Guardados, en lo demas no es usado, este sirve para saber que usuario ha guardado tal articulo.
  int date; //date: campo unicamente usado en la tabla de articulos Guardados, en lo demas no es usado, este sirve para saber cuando el usuario guardo el articulo
  
  Articles({@required this.ID,@required this.num,@required this.image,@required this.title, @required this.content, this.category, this.url});

  Articles.CreateAndSave({@required this.num,@required this.image,@required this.title, @required this.content, @required this.date, this.url});


  Map<String, dynamic> toMap(){
    var map= <String, dynamic> {'ID':ID,'num':num, "title":title,'content':content, 'image':image, 'category':category, "url":url};
    return map;
  }

  Articles.fromMap(Map<String, dynamic> map){
    ID=map["ID"];
    num=map["num"];
    title=map["title"];
    content=map["content"];
    image=map["image"];
    category=map["category"];
    url=map["url"];
  }

  Articles.savedFromMap(Map<String, dynamic> map){
  num=map["num"];
  localuser=map['localuser'];
  title=map["title"];
  content=map["content"];
  image=map["image"];
  date=map["date"];
  url=map["url"];
  }


}