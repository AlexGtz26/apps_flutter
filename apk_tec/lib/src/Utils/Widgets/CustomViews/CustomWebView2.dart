import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tecmas/common/Utils/Widgets/CustomViews/CustomWebview.dart';
import 'package:tecmas/config/Temas/BaseTheme.dart';
import 'package:webview_flutter/webview_flutter.dart';


class CustomWebViewExample extends StatefulWidget {
  final URL; final PATH_FROMLOCALFILE; final LoadingFromAssets; final HTMLString; final LoadingFromHTMLString; final CombineFileAndHTMLBODY;

  CustomWebViewExample({this.URL="",this.PATH_FROMLOCALFILE="", this.LoadingFromAssets=false, this.HTMLString="", this.LoadingFromHTMLString=false, this.CombineFileAndHTMLBODY=false});
  @override
  _CustomWebViewExampleState createState() => _CustomWebViewExampleState();
}

class _CustomWebViewExampleState extends State<CustomWebViewExample> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final initialUrlListener = StreamController<String>.broadcast();

  WebViewController exController;
  static const String error='<!DOCTYPE><html><head><style>p{font-size:30px}</style></head><body><p>Estas haciendo algo mal, checa los parametros y los valores</p><p>You Are Doing Something Wrong, Check the parameters and Values</p></body></html>';
  bool isLoading=true;
  bool isfirstLoad=true;
  bool eraseDataWhenDispose=true;

  final CookieManager cookieManager = CookieManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _MainContentToLoad(URL:widget.URL, PATH_FROMLOCALFILE: widget.PATH_FROMLOCALFILE, LoadingFromAssets: widget.LoadingFromAssets, HTMLString: widget.HTMLString, LoadingFromHTMLString: widget.LoadingFromHTMLString, CombineFileAndHTMLBODY: widget.CombineFileAndHTMLBODY);
  }

  @override
  void dispose() async{
    // TODO: implement dispose
    if(eraseDataWhenDispose){
      cookieManager.clearCookies();
      (await _controller.future).clearCache();
    }
    initialUrlListener?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //isfirstLoad?(){_MainContentToLoad(LoadingFromHTMLString: true, HTMLString: '<br><br><br><a href="https://www.google.com.mx">google</a>'); isfirstLoad=false;}:null;
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter WebView example'),),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: StreamBuilder<String>(
          stream: initialUrlListener.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.hasData);
            if(snapshot.hasData){
              return WebView(
                initialUrl: snapshot.data,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController)async {
                  _controller.complete(webViewController);
                },
                // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                // ignore: prefer_collection_literals
                javascriptChannels: <JavascriptChannel>[
                  _toasterJavascriptChannel(context),
                ].toSet(),
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                  setState(() {
                    isLoading=true;
                  });

                },
                onPageFinished: (String url)async {
                  print('Page finished loading: $url');
                  isfirstLoad?isfirstLoad=false:null;
                  setState(() {
                    isLoading=false;
                  });

                  await (await _controller.future).evaluateJavascript("var links = document.getElementsByTagName('a');for (var i = 0, l = links.length; i < l; i++) {links[i].target = '_self';}");

                },
                gestureNavigationEnabled: true,
              );
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }),
      bottomNavigationBar: NavigationControls(_controller.future, isLoading),
      //floatingActionButton: favoriteButton(),
    );
  }


  Future<void> _MainContentToLoad({URL="",PATH_FROMLOCALFILE="", LoadingFromAssets=false, HTMLString="", LoadingFromHTMLString=false, CombineFileAndHTMLBODY=false}) async {

    Future.delayed(Duration(milliseconds: 5)).then((value)async{
      //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      String from='';
      print("FromASSETS: "+LoadingFromAssets.toString()+" fromString: "+LoadingFromHTMLString.toString()+" Combinado: "+CombineFileAndHTMLBODY.toString());
      if(LoadingFromAssets==true && LoadingFromHTMLString==false && CombineFileAndHTMLBODY==false){
        //Entonces se cargara desde un archivo
        print("Loading From A FILE");
        String dataText = await rootBundle.loadString(PATH_FROMLOCALFILE);
        from = Uri.dataFromString(dataText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString();
      }else if(LoadingFromAssets==false && LoadingFromHTMLString==true && CombineFileAndHTMLBODY==false){
        //Se renderizara una cadena con texto en codigo HTML
        from = Uri.dataFromString(HTMLString, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString();
        print("Loading From HTML");
      }else if(LoadingFromAssets==false && LoadingFromHTMLString==false && CombineFileAndHTMLBODY==true){
        //Cargaremos contenido desde un archivo pero el body del mismo sera cargado desde una cadena html
        String dataText = await rootBundle.loadString(PATH_FROMLOCALFILE)+HTMLString+'</div></body></html>';
        from = Uri.dataFromString(dataText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString();
      }else {
        if (URL.length != 0) {
          from = URL;
          print("Loading INTERNET:" + from);
        }
        else {
          print("Loading Error:" + from);
          from = Uri.dataFromString(error, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString();
        }
      }

      initialUrlListener.sink.add(from);



      //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    });

    /*_controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());*/
  }


  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

/*Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final String url = await controller.data.currentUrl();
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favorited $url')),
                );
              },
              child: const Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }*/
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture, this.isLoading)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            Expanded(child:  IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(content: Text("No puedo retroceder más")),
                  );
                  return;
                }
              },
            ),),
            Expanded(child: BotonRefresh(loading: isLoading, GestorDeAnimacion: !webViewReady
                ? null
                : () {
              controller.reload();
            }),) ,
            Expanded(child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                if (await controller.canGoForward()) {
                  await controller.goForward();
                } else {
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("No puedo avanzar más")),
                  );
                  return;
                }
              },
            ),) ,
          ],
        );
      },
    );
  }
}


class BotonRefresh extends StatelessWidget {

  bool loading;
  Function GestorDeAnimacion;

  BotonRefresh({@required this.loading, @required this.GestorDeAnimacion});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      child: Center(
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                child: loading ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(SecondaryThemeColor)):null,
              ),
            ),
            Center(child:
            Icon(loading ? Icons.clear : Icons.refresh)
            )
          ],
        ),
      ),
      //child:
      backgroundColor: Colors.blueAccent,
      splashColor: PrimaryThemeColor,
      onPressed: GestorDeAnimacion,
    );
  }
}
