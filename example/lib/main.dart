import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ycbtsdk/flutter_ycbtsdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterYcbtsdkPlugin = FlutterYcbtsdk.instance;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPlugin();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterYcbtsdkPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initPlugin() async {
    try {
      await _flutterYcbtsdkPlugin.initPlugin();
    } catch (e) {
      // log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      print('Begin scan');
                      await _flutterYcbtsdkPlugin.startScan();
                      print('End scan');
                    } catch (e) {
                      // log(e.toString());
                    }
                  },
                  child: const Text('startScan BLE'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _flutterYcbtsdkPlugin.stopScan();
                    } catch (e) {
                      // log(e.toString());
                    }
                  },
                  child: const Text('stopScan BLE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
