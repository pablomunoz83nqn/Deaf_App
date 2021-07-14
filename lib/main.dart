import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:share/share.dart';
import 'package:flutter_tts/flutter_tts.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    

    return MaterialApp(
      title: 'Voz a Texto y viceversa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {



  
  

  share(BuildContext context) {

  String text = _text;
  
  

  final RenderBox box = context.findRenderObject();
  Share.share(text, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);


  }


  //Si escribo estas palabras puedo resaltarlas, por ejemplo para ir a URL precisas. 
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'dart': HighlightedWord(
      onTap: () => print('dart'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'pablo': HighlightedWord(
      onTap: () => print('pablo'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'sordo': HighlightedWord(
      onTap: () => print('sordo'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'auxilio': HighlightedWord(
      onTap: () => print('auxilio'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Toque el micro 1 vez para dictar o el lápiz para escribir.';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Presición: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
        actions: [
          Container(
            
            child: Row(
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.lightGreen,
                  mini: true,
                  child: 
         
                    Icon(Icons.menu),
                    onPressed: (){
                     _opciones();
                     },
                  
                  )
              ],
            ),
          ),
          
        ],
        
      ),
      
      body: Center(
        child: SingleChildScrollView(
           
          
          reverse: true,
          child: Container(
           
            
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                
              ),
             borderRadius: BorderRadius.circular(20)
            ),

            child: TextHighlight(

              text: _text,
              words: _highlights,
              textStyle: const TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                
              ),
            ),

          

          ),
        ),
      ),
      
      
      floatingActionButton: _fab(),
      
    );
  }

  Widget _fab(){


  
    return Container(

      child: (
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

      AvatarGlow(
        
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 65.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.stop : Icons.mic),
          
        ),
      ),
      
      FloatingActionButton(
        child: 
         
          Icon(Icons.create),
          onPressed: 

           _escribir,
            //_speak,

          
        ),

      SizedBox(width: 30.0),

      FloatingActionButton(
        child: 
         
          Icon(Icons.save),
          onPressed: (){
            share(context);
          },
          
          
        ),
    ],)
      ),
    );
  }
  

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
              
            }
          }),
        );
        
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      
      
      
      
      
    }

    
  }

Future<void> _escribir() async {

  


  final FlutterTts flutterTts = FlutterTts();

  String _nombre = '';

    Future _speak() async {

      await flutterTts.speak(_nombre);

    }
  return showDialog <void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        title: Text('Escriba aqui'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  
                  labelStyle: TextStyle(fontSize: 30,),
                 
                  border: const OutlineInputBorder(),
                  hintText: 'Escriba y presione Reproducir',
                  
                ),
                onChanged: (valor){
        setState(() {
           _nombre = valor;
        });
       
       
      },
              ),
              
            
            ],
          ),
        ),
        actions: <Widget>[
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            
          
          children: [
            
          FloatingActionButton(
            backgroundColor: Colors.redAccent,
            
            child: Icon(Icons.close),
            onPressed: () {
              
              Navigator.of(context).pop();

            },
          ),
          SizedBox(width: 30),
           FloatingActionButton(
            child:
            
            Icon(Icons.play_arrow),
            onPressed: () {
              _speak();
              //Navigator.of(context).pop();

            },
          ),
          
          ]
          )
        ],
      );
    },
  );
}
 

Future<void> _opciones() async {

  


  
  return showDialog <void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Gracias!'),
        content: Container(
          child: (
          Column(
            children: [
            Text('Desarrollada por Pablo Martin Muñoz. pablomunoz83@gmail.com'           
          ),
          SizedBox(height: 15.0),
          Text('Sin fines de lucro, gratis, sin publicidad, sin internet, sin permisos raros.'),
          SizedBox(height: 15.0),
          Text('Dejame un comentario en la play Store'),
          ],)
          
        )),
        actions: <Widget>[
          
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
          
          children: [
          TextButton(
            child: Text('Cerrar'),
            onPressed: () {
              
              Navigator.of(context).pop();

            },
          ),
          TextButton(
            child: Text('Puntuar'),
            onPressed: () {
              
             null;

            },
          ),
          TextButton(
            child: Text('Compartir APP'),
            onPressed: () {
              null;
            },
          ),
          
          ]
          )
        ],
      );
    },
  );
}
  


  
}


