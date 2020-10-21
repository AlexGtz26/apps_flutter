import 'dart:async';

import 'package:apk_tec/src/models/articulos_model.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import "package:http/http.dart" as http;

class ArticulosProvider{

  final BuildContext context;
  List<Articles> _articulos;
  int _category;
  int _cantidadAmotrar;
  int _NumDePagina;
  String _fetcherror="";
  bool _cargando=false;

  /*Begin Stream*/
  final _articulosStreamController = StreamController<List<Articles>>.broadcast();

      //Introduce informacion al stream
  Function(List<Articles>) get articulosSink=> _articulosStreamController.sink.add;

    //Obtinen información del stream
  Stream<List<Articles>> get articulosStream=> _articulosStreamController.stream;


  void disposeStreams(){
    _articulosStreamController?.close();

  }

  /*End Stream*/

  ArticulosProvider({@required category, @required cantidadAmotrar, @required this.context}){
    this._category=category;
    this._cantidadAmotrar=cantidadAmotrar;
    this._NumDePagina=0;
    this._articulos= new List();
     //delete();
    refresh();
  }

  Future<void> refresh()async{
    this._NumDePagina=0;
    this._articulos= new List();
    //await delete();
    print("Limpiando la lista");
    _fetcherror="";
    getArticlesFromServer();
    this._cargando=false;
  }

  
  Future<void> getArticlesFromServer()async{
    if(_cargando || isAnyfetchError()=='400') {
      return [];
    }
    _cargando=true;
    _NumDePagina++;
    final url=Uri.https("wordpresspruebas210919.000webhostapp.com","wp-json/wp/v2"+"/posts",{
      'categories':_category.toString(),
      'per_page':_cantidadAmotrar.toString(),
      'page':_NumDePagina.toString()
    });
    print("\n\n\n\n\n\n\n\n\n\n\n\n\nURL:"+url.toString());

    final respuesta = await _procesarPeticion(url);

      _articulos.addAll(respuesta);
      articulosSink(_articulos);
      _cargando=false;


  }


  String isAnyfetchError(){
    return _fetcherror;
  }

  Future<List<Articles>> _procesarPeticion(Uri url) async{
    /*bool connected = await Utils.NetworkConnectionCheck();
    if(!connected){
      _cargando=false;
      _fetcherror="Timeout";
      if(_articulos.isEmpty){
        _fetcherror="InitialFetchFailed";
      }
      return [];
    }
    */

    List<Articles> aux= [];

    return await http.get(url, headers:{
      'Authorization':'Bearer '+"cg51Y7K3uxqe1HmsTr9pzB4u9i8jizNW",
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    ).then((response)async{

      if(response.statusCode==200){
        final decodecData=jsonDecode(response.body);

        for(var object in decodecData){

          var image = null;
          try {
            image = object['better_featured_image']['source_url'];
          } catch (e) {
            image="https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRBZNpdaxzwE4Tehk16HHWNFRSxwXzKjhptSz-JrSwkIGD2QO68";
          }

          Articles a = Articles(
            ID:int.parse(_category.toString()+object["id"].toString()),
            num: object['id'],
            title:object['title']['rendered'],
            image: image,
            content: object['content']['rendered'],
            category: _category,
            url:object["link"],
          );

          try {
            aux.add(a);
          }on Exception catch(e){
            // StopLoadingProcess();
            print("Execption: "+e.toString());
            _articulosStreamController.addError(e.toString());
            //return _articulos;
          }catch(e){
            print("Database error: "+e.toString());
            _articulosStreamController.addError(e.toString());
            //StopLoadingProcess();
            //return _articulos;
          }
        }
        return aux;

      }else if(response.statusCode.toString()=='400') {
        _fetcherror=response.statusCode.toString();
        return aux;
      }else{
        _fetcherror=response.statusCode.toString();
        _articulosStreamController.addError(_fetcherror);
        throw Exception(_fetcherror);
      }

    }).timeout(Duration(seconds: 15), onTimeout: (){
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");

        _fetcherror="Timeout";
        _articulosStreamController.addError(_fetcherror);
        print("Timeout for petition");
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
        if(_articulos.isNotEmpty){
            return []; //si no regreso algo se capturara el error
          //En este caso solo deseo que se note el error cuando la peticion ha fallada y no tengo por tanto datos.
        }
        _cargando=false;

    });

  }
  
}