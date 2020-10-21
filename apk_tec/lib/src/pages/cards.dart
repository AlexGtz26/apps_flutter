import 'package:apk_tec/src/models/articulos_model.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Cards extends StatelessWidget {
  Articles articulo;
  Cards({@required this.articulo});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 20,
      child: InkWell(
        focusColor: Colors.red,
        splashColor: Colors.blue,
        onTap: () {},
        child: Container(

          width: double.infinity,
          child: Column(

            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
              child:Text(articulo.title.toString(),style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
              ),
              Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black,
                      ),
                      child: Image.network( articulo.image.toString()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width-60,0, 15, 0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      heroTag: UniqueKey(),
                      child: Icon(Icons.share, color:Colors.white),
                      elevation: 20,
                      onPressed: (){Share.share("Noticias TecNM Matamoros\n\n"+articulo.title.toString()+": "+articulo.url.toString());},
                    ),
                  ),

                ],
              ),

              SizedBox(width: double.infinity,height: 10,)

            ],
          ),
        ),
      ),
    );
  }
}

