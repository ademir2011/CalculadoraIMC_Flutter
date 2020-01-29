import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'saúde',
      'boa forma',
      'exercícios',
      'academia',
      'fitness'
    ],
    childDirected: false,
    testDevices: <String>[],
  );

  BannerAd bannerAd;

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAdMob.instance.initialize(
      appId: 'ca-app-pub-2802875285191503~4446707748',
    );

    startBanner();
    displayBanner();
  }

  void startBanner() {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-2802875285191503/4295305130',
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.opened) {
          // MobileAdEvent.opened
          // MobileAdEvent.clicked
          // MobileAdEvent.closed
          // MobileAdEvent.failedToLoad
          // MobileAdEvent.impression
          // MobileAdEvent.leftApplication
        }
        print("BannerAd event is $event");
      },
    );
  }

  void displayBanner() {
    bannerAd
      ..load()
      ..show(
        anchorOffset: 0.0,
        anchorType: AnchorType.bottom,
      );
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";

    setState(() {
      _infoText = "";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      if (imc < 18.5) {
        _infoText = "Abaixo do Peso IMC: ${imc.toStringAsPrecision(4)}";
      } else if (imc >= 18.5 && imc <= 24.9) {
        _infoText = "Peso normal  IMC: ${imc.toStringAsPrecision(4)}";
      } else if (imc >= 25.0 && imc <= 29.9) {
        _infoText =
            "Levemente Acima do Peso IMC: ${imc.toStringAsPrecision(4)}";
      } else if (imc >= 30.0 && imc <= 34.9) {
        _infoText = "Obesidade de Grau 1 IMC: ${imc.toStringAsPrecision(4)}";
      } else if (imc >= 35.0 && imc <= 39.9) {
        _infoText = "Obesidade de Grau 2 IMC: ${imc.toStringAsPrecision(4)}";
      } else if (imc >= 40) {
        _infoText = "Obesidade de Grau 3 IMC: ${imc.toStringAsPrecision(4)}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Color(0xFF8ACDEA),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Text(
                'IMCalculadora',
                style: TextStyle(fontSize: 40.0, color: Color(0xff746D75)),
              ),
              SizedBox(
                height: 50.0,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                decoration: InputDecoration(
                  hintText: 'Informe seu peso',
                  hintStyle: TextStyle(
                    color: Color(0xff746D75),
                  ),
                  prefix: Text(
                    'KG',
                    style: TextStyle(
                      color: Color(0xff746D75),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.red, width: 5.0),
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff746D75), fontSize: 25.0),
                controller: weightController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira seu Peso!";
                  } else if (value.length > 3) {
                    return "Peso inválido!";
                  }
                },
              ),
              SizedBox(
                height: 25.0,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Informe sua altura',
                  hintStyle: TextStyle(
                    color: Color(0xff746D75),
                  ),
                  prefix: Text(
                    'CM',
                    style: TextStyle(
                      color: Color(0xff746D75),
                    ),
                  ),
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff8C4843), fontSize: 25.0),
                controller: heightController,
                validator: (value) {
                  print(value.length);
                  if (value.isEmpty) {
                    return "Insira sua Altura!";
                  } else if (value.length > 3) {
                    return "Altura inválida";
                  }
                },
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _calculate();
                    }
                  },
                  child: Text(
                    "Calcular",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                  color: Color(0xff746D75),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff746D75),
                  fontSize: 25.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
