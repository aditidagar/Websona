import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

const String API_URL =
    "http://websona-alb-356962330.us-east-1.elb.amazonaws.com";

class QRScanner extends StatefulWidget {
  QRScanner({Key key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool _camState = true;
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        _camState = false;
        qrText = scanData;
      });
    });
    fetchQRData(qrText);
  }

  void fetchQRData(code) async {
    http.Response response = await http.get(API_URL + "/code" + code);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("Fetch call failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this._camState == true) {
      return Container(
          height: MediaQuery.of(context).size.width * 2,
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 180.0,
                height: 180.0,
                margin: EdgeInsets.only(top: 20, bottom: 20),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    image: new ExactAssetImage('asset/img/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text("J",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 60.0,
                          fontFamily: 'sans-serif-light',
                          color: Colors.white)),
                ),
              ),
              Center(
                child: Text("Jane Smith",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0,
                        fontFamily: 'sans-serif-light',
                        color: Colors.black)),
              ),
              const SizedBox(height: 30),
              RaisedButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                onPressed: () {
                  //CODE HERE FOR 'ADD CONTACT'
                },
                child: const Text('Add Contact',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              const SizedBox(height: 10),
              RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                    side: BorderSide(color: Colors.blue, width: 2)),
                onPressed: () {
                  //CODE HERE FOR 'DISMISS'
                },
                child: const Text('Dismiss',
                    style: TextStyle(fontSize: 20, color: Colors.blue)),
              ),
              // Text(
              //   'Scan the QR code',
              //   style: this._camState == true
              //       ? TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
              //       : TextStyle(fontSize: 12),
              //   textAlign: TextAlign.center,
              // ),
              // SizedBox(
              //   height: 350,
              //   width: 300,
              //   child: QRView(
              //     key: qrKey,
              //     onQRViewCreated: _onQRViewCreated,
              //     overlay: QrScannerOverlayShape(
              //       borderColor: Colors.red,
              //       borderRadius: 10,
              //       borderLength: 30,
              //       borderWidth: 10,
              //       cutOutSize: 300,
              //     ),
              //   ),
              // ),
              // Text(qrText, style: TextStyle(color: Colors.black)),
            ],
          ));
    }
    return Container(
      height: MediaQuery.of(context).size.height * 5,
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(10.0),
      child: Wrap(
        children: <Widget>[
          Text(qrText, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
