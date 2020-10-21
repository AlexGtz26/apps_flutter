import 'package:apk_tec/src/services/articulos_service.dart';
import 'package:flutter/material.dart';

import 'cards.dart';


class ArticlesList extends StatefulWidget {
  int category;
  ArticlesList({@required this.category});

  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {

  ArticulosProvider _articulosProvider;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener((){

      if((_scrollController.position.pixels>=_scrollController.position.maxScrollExtent*0.40)){
          _articulosProvider.getArticlesFromServer();
      }

    });

  }

   @override
   void didChangeDependencies() {
     super.didChangeDependencies();
     if (_articulosProvider == null) { // or else you end up creating multiple instances in this case.
       _articulosProvider= ArticulosProvider(cantidadAmotrar: 10, category: widget.category, context: context);
     }
   }

   @override
  void dispose() {
    // TODO: implement dispose
    _scrollController?.dispose();
    _articulosProvider.disposeStreams();
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Lista();
  }

  Widget _Lista() {
    return Stack(
      children: <Widget>[
        Container(child: Cuerpo(),),
      ],
    );
  }

  final _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

   Widget Cuerpo() {

    return StreamBuilder(
      stream: _articulosProvider.articulosStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(_articulosProvider.isAnyfetchError()=="InitialFetchFailed")
          return Text("Error");
        if(snapshot.hasData){
            if(snapshot.data.length==0) {
              return Text("Error");
            }else{
              return  _ItemsList(snapshot);
            }
        }else{
          return CircularProgressIndicator();
        }
      },
    );
   }

   Widget _ItemsList(AsyncSnapshot snapshot) {
    return ListView.separated(
        controller: _scrollController,
        separatorBuilder: (context, index)=>SizedBox(),
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index){
          //print(widget.category.toString()+" : "+snapshot.data.length.toString() + " : "+index.toString());
          return Column(
            children: <Widget>[
              Cards(articulo: snapshot.data[index]),
              index+1>=snapshot.data.length?
                  _articulosProvider.isAnyfetchError()=='400' || snapshot.data.length==1?
                      Container( padding: EdgeInsets.only(top: 30),
                        child:  Text('Estos son todos los artículos' ,),)
                  : _articulosProvider.isAnyfetchError()=='Timeout'?
                      RecargarBtn()
                  :CircularProgressIndicator()
                  :SizedBox()
            ],);
        });
  }

  Widget RecargarBtn(){
     return FlatButton(
       color: Colors.red,
       child: Text("Sin conexión ¿Recargar?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
              onPressed: (){
                _scrollController.animateTo(0, duration: Duration(milliseconds: 1000), curve: Curves.fastOutSlowIn);
                _refreshIndicatorKey.currentState.show();
         },
     );
  }

}
