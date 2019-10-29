import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', channel: IOWebSocketChannel.connect("ws://192.168.43.25:8001")),
    );
  }
}

class MyHomePage extends StatefulWidget {
 
  final String title;
  final WebSocketChannel channel;

   MyHomePage({Key key, @required this.title, @required this.channel});
    //  : super(key: key);

 bool toggleFL = false;
 bool toggleBL = false;
  bool toggleSL = false;
  bool toggleAL = false;
  bool toggleAR = false;
  bool toggleFA = false;
 
 

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    final Completer<WebViewController> _controller = Completer<WebViewController>();
   

  
 


 

  static String response = "####";
  MqttClient client; //MqttClient('test.mosquitto.org', '');

  final String frontlite = 'frontlight';
  final String backlite = 'backlight';
  final String door = 'openclosedoor';
  final String rlcamera = 'rightleftcamera';
  final String temperaturet = 'temperature';
  final String humidityt = 'humidity';
  final String alarm = 'alarm';
  final String pir = 'pir';
  final String responset = 'response';
  final String armedt = 'armed';
  final String slite = 'securitylight';
  final String fan = "fan";
  String net = 'OFF';

  String html = '<body>xxx<img src="http://192.168.43.25:8000/">';

 String temperature = "####"; 
  String humidity = "####";
  String tempp = "####";
  String humidd = "####";

 bool armed = false;
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      Timer.periodic(Duration(seconds: 100), (timer) {
        print('sending periodic message: hh');
        
        widget.channel.sink.add('humidity');
        setState(() {
          humidity = humidd;          
         });
      });

      Timer.periodic(Duration(seconds: 115), (timer) {
        print('sending periodic message: temp');
        widget.channel.sink.add('temperature');
        setState(() {
          temperature = tempp;          
         });
        
      });
   
           
       //widget.channel.sink.add('frontlite1');
    //    widget.channel.stream.listen((data) => print(data));
  // parseMessages(); 
        
  
    }

    void parseMessages() async {
      await widget.channel.stream.listen((data) => print(data));
   //    widget.channel.stream.listen((message) {
     //   print('mess: $message');
     //   //widget.channel.sink.close(status.goingAway);
  //});
      
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

  Widget favoriteButton() {
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
  }


  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text('Temp.: $temperature C'),
                
                new Text('Hum.: $humidity %'),
                
                new Text('ARMED: $armed '),
                 
                new Text('NET: $net '),
               

              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('Front Light'),
                    new Switch(
                  value: widget.toggleFL, 
                  onChanged: (value){
                    setState(() {
                     widget.toggleFL = value;                     
                     });
                    
                    
                    print(widget.toggleFL);
                    
                       if(widget.toggleFL == true){
                          print(':Publishing our topic: frontlite1');
                         widget.channel.sink.add("frontlite1");
                        }else{
                            print(':Publishing our topic: frontlite0');
                          widget.channel.sink.add("frontlite0");
                        }
                  
                                               
                         
                    }),
                  ],
                ),

                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('Back Light'),
                    new Switch(
                  value: widget.toggleBL, 
                  onChanged: (value){
                    widget.toggleBL = value;
                    setState(() {
                      widget.toggleBL = value;                    
                    });
                     
                      
                       if(widget.toggleBL == true){
                          print(':Publishing our topic: backlite1');
                          widget.channel.sink.add("backlite1");
                        }else{
                            print(':Publishing our topic: backlite0');
                          widget.channel.sink.add("backlite0");
                        }
                            
                    }),
                  ],
                ),

                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('Security Light'),
                    new Switch(
                  value: widget.toggleSL, 
                  onChanged: (value){
                    
                    setState(() {
                      widget.toggleSL = value;                    
                    });
                     
                      
                       if(widget.toggleSL == true){
                          print(':Publishing our topic: seclite1');
                          widget.channel.sink.add("seclite1");
                        }else{
                            print(':Publishing our topic: seclite0');
                          widget.channel.sink.add("seclite0");
                        }
                            
                    }),
                  ],
                ),

               
                
               
              ]
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('Alarm'),
                    new Switch(
                  value: widget.toggleAL, 
                  onChanged: (value){
                    setState(() {
                      widget.toggleAL = value;
                    });
                     
                      
                    if(widget.toggleAL == true){
                          print(':Publishing our topic: alarm1');
                          widget.channel.sink.add("alarm1");
                        }else{
                            print(':Publishing our topic: alarm0');
                          widget.channel.sink.add("alarm0");
                        }
                            
                    }),
                  ],
                ),

                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('ARM'),
                    new Switch(
                  value: widget.toggleAR, 
                  onChanged: (value){
                    setState(() {
                      widget.toggleAR = value;
                    });                     
                      
                    if(widget.toggleAR == true){
                          print(':Publishing our topic: arm1');
                          widget.channel.sink.add("arm1");
                          setState(() {
                              armed = value;                       
                                                    });
                        }else{
                            print(':Publishing our topic: arm0');
                          widget.channel.sink.add("arm0");
                            setState(() {
                               armed = value;                       
                                                    });
                        }
                            
                    }),
                  ],
                ),

                 new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text('FAN'),
                    new Switch(
                  value: widget.toggleFA, 
                  onChanged: (value){
                    setState(() {
                      widget.toggleFA = value;
                    });
                      
                       if(widget.toggleFA == true){
                          print(':Publishing our topic: fan1');
                          widget.channel.sink.add("fan1");
                        }else{
                          print(':Publishing our topic: fan0');
                          widget.channel.sink.add("fan0");
                        }
                            
                    }),
                  ],
                ),

                
               
              ]
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                             StreamBuilder(
               stream: widget.channel.stream,
               builder: (BuildContext context, AsyncSnapshot snapshot) {
                 print('xxxxxxx: ${snapshot.data}');
                 String seeData = snapshot.data.toString().substring(0, 2);
                 print('see data: $seeData');
                 print(snapshot.data.toString().substring(2));
                 print(seeData == 'TE');
                 if(seeData == 'TE'){
                   
                    tempp = snapshot.data.toString().substring(2);            
                   
                 }else if(seeData == 'HU'){
                   humidd = snapshot.data.toString().substring(2);            
                   
                 }
                 return Container(
                   child: Text(snapshot.hasData ? '${snapshot.data}' : '####'),
                 );
               },
             ),
                
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton(
                  child: new Text('OPEN'),
                  color: Colors.blue,
                  onPressed: (){
                    widget.channel.sink.add("open");
                  },
                ),

                new RaisedButton(
                  child: new Text('CLOSE'),
                  color: Colors.blue,
                  onPressed: (){
                    widget.channel.sink.add("close");
                  },
                )
              ],
            ),
          ),

        Padding(
            padding: EdgeInsets.all(4.0),
            child: Container(
              width: 300,
              height: 350,
              child:  WebView(
          initialUrl: 'http://192.168.43.25:8000',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
        ),
            )
           

          )
     
      
        ]
        )
 
    );
  }


// Subscribe to an (Adafruit) mqtt topic.
  Future<bool> subscribe(String topic) async {
  
    if (await _connectToClient() == true) {
      /// Add the unsolicited disconnection callback
      client.onDisconnected = _onDisconnected;

      /// Add the successful connection callback
      client.onConnected = _onConnected;

      client.onSubscribed = _onSubscribed;
      _subscribe(topic);
    }
    return true;
  }


  Future<bool> _connectToClient() async {
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
      print('already logged in');
    } else {
      client = await _login();
      if (client == null) {
        return false;
      }
    }
    return true;
  }



void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    
  }




    void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    setState(() {
      net = 'OFF';
    });
    
    client.disconnect();
  }

  void _onConnected() {
     setState(() {
      net = 'ON';
    });
    print('OnConnected client callback - Client connection was sucessful');
    
    this._subscribe(temperaturet);
    this._subscribe(humidityt);
    this._subscribe(responset);
  }

   Future<MqttClient> _login() async {


    client = MqttClient('test.mosquitto.org', ''); 
    // Turn on mqtt package's logging while in test.
    client.logging(on: true);
    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('my00ID')
        .keepAliveFor(60) // Must agree with the keep alive set above or not set
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    print('Adafruit client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however eill
    /// never send malformed messages.
    try {
      await client.connect();
    } on Exception catch (e) {
      print('EXCEPTION::client exception - $e');
      client.disconnect();
      client = null;
      return client;
    }

    /// Check we are connected
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('A client connected');
        
    this._subscribe(temperaturet);
    this._subscribe(humidityt);
    this._subscribe(responset);

    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'Adafruit client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      client = null;
    }
    return client;
  }

  Future _subscribe(String topic) async {
    
    print('Subscribing to the topic $topic');
    client.subscribe(topic, MqttQos.atMostOnce);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      /// The payload is a byte buffer, this will be specific to the topic
     // AdafruitFeed.add(pt);
     //temperature = pt;
      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');

          if(c[0].topic.compareTo(temperaturet) == 0){
            print(pt);
          //  temperature = pt;
            setState(() {
            //  temperature = pt;
            });
          }
          if(c[0].topic.compareTo(humidityt) == 0){
            setState(() {
              //humidity = pt;
            });
          }
          if(c[0].topic.compareTo(responset) == 0){
            setState(() {
              response = pt;
            });
          }

          
      return pt;
    });
  }

  Future<void> publish(String topic, String value) async {
    // Connect to the client if we haven't already
    if (await _connectToClient() == true) {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(value);
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload);
    }
  }

}
