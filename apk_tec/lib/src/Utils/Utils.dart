/*Este archivo fue creado apartir de la versión: TecMAS-19.12.11-(SQLiteDatabase) por Ambrocio Isaias Laureano Castro
*
* Este archivo ha sido pensado para almacenar funciones comunmente usadas en los diferentes archivos, clases y secciones
* de código donde resulten utiles. Es de vital importancia recalcar que se debe tener especial cuidado en la modificación
* de estas lineas de código, cualquier cambio no planeado a detalle puede generar comportamientos inesperados y bugs
* no previstos por el programador.
*
* En resumen: Si no posees conocimientos necesarios y/o no sabes que realizan tales funciones !NO TOCAR¡
*
* */

import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

import "package:http/http.dart" as http;
import 'package:connectivity/connectivity.dart';


import 'package:flutter/material.dart';

class Utils{

  static String cutString(int cutoff, String myString) {
    print("cutting");
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}';
  }

  static String toBase64(String text){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(text);      //
    return encoded;
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static dynamic ShowSnackWithDelay(dynamic context, int delay, Widget snack){
    return Future.delayed(Duration(milliseconds: delay),(){
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(snack);
    });
  }

  static Widget BasicSnack(String MSG){
    return SnackBar(content: Text(MSG,textAlign: TextAlign.justify));
  }


  /*
No borro este código por ahora aunque ya esta en desuso ) solamente por que en versiones anteriores era utilizado y funcionaba correctamente. Sin embargo empecé a reestructurar el código
y utilizar otras formas "más optimas de verificar la conectividad", sin embargo por ciertos bug regresé a usarla, pero sigué dando problemas por actualizaciones de telcel.

La idea es que lanza una petición al dominio marcado, sin embargo mientras con wifi funciona bien, con la red móvil y sin datos, telcel en este caso, aparentemente si procesa
la solicitud pero redirige al sitio de telcel para recargar saldo, por tanto en este caso especifico siempre marca que existe conexión a internet, y esto mismo sucede con otros
plugins y librerias. Por tanto tuve que reemplazar esto por una petición http normal, pues de esa manera aparentemente no se devuelve un código 200 por parte del servidor.



Future NetworkConnectionCkeck() async{
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return 1;
    }
  } on SocketException catch (_) {
    return 0;
  }
}*/


  static Future<bool> NetworkConnectionCheck()async{
    /*Es utilizado por el widget CustomWebView y el articlelist por ahora*/
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      return false;
    }
    else{
      return await http.get("https://www.google.com/",
      ).then((response){
        if(response.statusCode==200)
          return true;
        else return false;
      }).timeout(Duration(seconds: 5),onTimeout: (){return false;});
    }


  }

}