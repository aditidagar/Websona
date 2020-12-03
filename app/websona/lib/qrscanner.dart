import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

const String API_URL = "https://api.thewebsonaapp.com";

class QRScanner extends StatefulWidget {
  QRScanner({Key key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool _camState = true;
  String _name = '';
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
      print(scanData);
      setState(() {
        _camState = false;
        qrText = scanData;
        fetchQRData(scanData);
      });
    });
  }

  void fetchQRData(code) async {
    print(code);
    Response response = await get(code, headers: <String, String>{
      'authorization': await getAuthorizationToken(context),
    });

    final responseBody = jsonDecode(response.body);
    print(responseBody);
    setState(() {
      _name = responseBody['firstName'] + " " + responseBody['lastName'];
    });
  }

  void addContact(code) async {
    Response response = await post(API_URL + "/addContact",
        headers: <String, String>{
          'authorization': await getAuthorizationToken(context),
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'code_id': code,
        }));
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
              Text(
                'Scan the QR code',
                style: this._camState == true
                    ? TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
                    : TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 350,
                width: 300,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
              ),
            ],
          ));
    }
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
                child: Text(this._name.length > 0 ? this._name[0] : "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60.0,
                        fontFamily: 'sans-serif-light',
                        color: Colors.white)),
              ),
            ),
            Center(
              child: Text(this._name,
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
                this.addContact(this.qrText);
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
                Navigator.pop(context);
              },
              child: const Text('Dismiss',
                  style: TextStyle(fontSize: 20, color: Colors.blue)),
            ),
          ],
        ));
  }
}
