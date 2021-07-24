import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:plugin_001/plugin_001.dart';
import 'package:plugin_001_example/services/notificationService.dart';
import 'package:shared_preferences/shared_preferences.dart';

const EVENTS_KEY = "bmclab_events";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _bmclabVersion = 'Unknown';

  bool _enabled = true;
  String _status = '';
  List<String> _events = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initBmclabState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await Plugin001.platformVersion ?? 'Unknown platform version';
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

  // BMCLAB 상태 확인
  Future<void> initBmclabState() async {
    String bmclabVersion;

    // BMCLAB 상태확인
    try {
      bmclabVersion = await Plugin001.bmclabVersion ?? 'Unknown bmclab version';
    } on PlatformException {
      bmclabVersion = 'Failed to get bmclab version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _bmclabVersion = bmclabVersion;
    });
  }

  // 플러그인 패치 실행 여부 설정
  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {
      Plugin001.start().then((int status) {
        print('[BackgroundFetch] start success 시작 성공 : $status, ${DateTime.now()}');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e, ${DateTime.now()}');
      });
    } else {
      Plugin001.stop().then((int status) {
        print('[BackgroundFetch] stop success 정지 성공 : $status, ${DateTime.now()}');
      });
    }
  }

  // 플러그인 상태 확인
  void _onClickStatus() async {
    String status = await Plugin001.status ?? 'Unknown status';
    print('[BackgroundFetch] status 상태 : $status, ${DateTime.now()}');
    setState(() {
      _status = status;
    });

    // Notification 알림
    NotificationService.initialize();
    NotificationService.instantNotification('알림', '플러그인 상태 확인', payload: 'payload');
  }

  // 이벤트 이력 삭제
  void _onClickClear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(EVENTS_KEY);
    setState(() {
      _events = [];
    });

    // Notification 알림
    NotificationService.initialize();
    NotificationService.instantNotification('알림', '이벤트 이력 삭제');
  }

  @override
  Widget build(BuildContext context) {

    const EMPTY_TEXT = Center(child: Text('Waiting for fetch events.  Simulate one.\n [Android] \$ ./scripts/simulate-fetch\n [iOS] XCode->Debug->Simulate Background Fetch'));

    return MaterialApp(
      home: Scaffold(

        appBar: AppBar(
          title: const Text('Plugin 001', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.amberAccent,
          brightness: Brightness.light,
          actions: <Widget>[
            Switch(value: _enabled, onChanged: _onClickEnable),
          ]
        ),

        body: Center(
          child: Text(
            'Running on: $_platformVersion\n'
            'BMCLAB: $_bmclabVersion\n'
            'status: $_status\n'
          ),
        ),

        bottomNavigationBar: BottomAppBar(
            child: Container(
                padding: EdgeInsets.only(left: 5.0, right:5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(onPressed: _onClickStatus, child: Text('Status: $_status')),
                      ElevatedButton(onPressed: _onClickClear, child: Text('Clear'))
                    ]
                )
            )
        ),
      ),
    );
  }
}
