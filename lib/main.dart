import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  final handler = MyExcaption('Lekala App');
  runZonedGuarded(() {
    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    handler.sendError(error, stack);
  });
}

class MyExcaption {
  // ignore: non_constant_identifier_names
  static String TOKEN = '2132442649:AAFO453hta5XxOMPL_vNX5gKw6Fb1XFgqp8';

  static late MyExcaption _instance;
  String? appName;

  final Map<String, dynamic> _deviceParameters = <String, dynamic>{};

  MyExcaption(this.appName) {
    _config();
  }

  void sendError(dynamic e, dynamic s) async {
    _deviceParameters['os'] = Platform.isAndroid ? 'Android' : 'iOS';
    _deviceParameters['os_v'] = Platform.operatingSystemVersion;

    DateTime now = DateTime.now();
    final currentTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    String content = """
      ==========================
    AppName: $appName
    ==========================
    Time: $currentTime
    ==========================
    Device: ${_deviceParameters['os']} || ${_deviceParameters['os_v']}
    ==========================
    Error: $e
    """;

    var url = Uri.parse(
      'https://api.telegram.org/bot$TOKEN/sendMessage?chat_id=659910840&text=$content',
    );

    try {
      await http.post(url);
    } catch (e) {
      print(e);
    }
  }

  void _config() {
    _instance = this;
    // _loadDeviceInfo();
  }

  // ignore: unused_element
  void _loadDeviceInfo() {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((androidInfo) {
        _loadAndroidParameters(androidInfo);
      });
    } else if (Platform.isIOS) {
      deviceInfo.iosInfo.then((iosInfo) {
        _loadIosParameters(iosInfo);
      });
    } else {
      debugPrint("Couldn't load device info for unsupported device type.");
    }
  }

  void _loadAndroidParameters(AndroidDeviceInfo androidDeviceInfo) {
    try {
      _deviceParameters["id"] = androidDeviceInfo.id;
      _deviceParameters["androidId"] = androidDeviceInfo.androidId;
      _deviceParameters["board"] = androidDeviceInfo.board;
      _deviceParameters["bootloader"] = androidDeviceInfo.bootloader;
      _deviceParameters["brand"] = androidDeviceInfo.brand;
      _deviceParameters["device"] = androidDeviceInfo.device;
      _deviceParameters["display"] = androidDeviceInfo.display;
      _deviceParameters["fingerprint"] = androidDeviceInfo.fingerprint;
      _deviceParameters["hardware"] = androidDeviceInfo.hardware;
      _deviceParameters["host"] = androidDeviceInfo.host;
      _deviceParameters["isPhysicalDevice"] =
          androidDeviceInfo.isPhysicalDevice;
      _deviceParameters["manufacturer"] = androidDeviceInfo.manufacturer;
      _deviceParameters["model"] = androidDeviceInfo.model;
      _deviceParameters["product"] = androidDeviceInfo.product;
      _deviceParameters["tags"] = androidDeviceInfo.tags;
      _deviceParameters["type"] = androidDeviceInfo.type;
      _deviceParameters["versionBaseOs"] = androidDeviceInfo.version.baseOS;
      _deviceParameters["versionCodename"] = androidDeviceInfo.version.codename;
      _deviceParameters["versionIncremental"] =
          androidDeviceInfo.version.incremental;
      _deviceParameters["versionPreviewSdk"] =
          androidDeviceInfo.version.previewSdkInt;
      _deviceParameters["versionRelease"] = androidDeviceInfo.version.release;
      _deviceParameters["versionSdk"] = androidDeviceInfo.version.sdkInt;
      _deviceParameters["versionSecurityPatch"] =
          androidDeviceInfo.version.securityPatch;
    } catch (exception) {
      debugPrint("Load Android parameters failed: $exception");
    }
  }

  void _loadIosParameters(IosDeviceInfo iosInfo) {
    try {
      _deviceParameters["model"] = iosInfo.model;
      _deviceParameters["isPhysicalDevice"] = iosInfo.isPhysicalDevice;
      _deviceParameters["name"] = iosInfo.name;
      _deviceParameters["identifierForVendor"] = iosInfo.identifierForVendor;
      _deviceParameters["localizedModel"] = iosInfo.localizedModel;
      _deviceParameters["systemName"] = iosInfo.systemName;
      _deviceParameters["utsnameVersion"] = iosInfo.utsname.version;
      _deviceParameters["utsnameRelease"] = iosInfo.utsname.release;
      _deviceParameters["utsnameMachine"] = iosInfo.utsname.machine;
      _deviceParameters["utsnameNodename"] = iosInfo.utsname.nodename;
      _deviceParameters["utsnameSysname"] = iosInfo.utsname.sysname;
    } catch (exception) {
      debugPrint("Load iOS parameters failed: $exception");
    }
  }

  ///Get current Catcher instance.
  static MyExcaption getInstance() {
    return _instance;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () async {
              throw 'Custom Error';
            },
            child: Text('Error'),
          ),
        ),
      ),
    );
  }
}
