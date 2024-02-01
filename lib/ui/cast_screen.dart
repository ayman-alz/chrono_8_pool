import 'package:cast/device.dart';
import 'package:cast/discovery_service.dart';
import 'package:cast/session.dart';
import 'package:cast/session_manager.dart';
import 'package:flutter/material.dart';

import '../components/applocal.dart';

class CastScreen extends StatefulWidget {
  CastScreen({Key? key}) : super(key: key);

  @override
  _CastScreenState createState() => _CastScreenState();
}

class _CastScreenState extends State<CastScreen> {
  Future<List<CastDevice>>? _future;

  @override
  void initState() {
    super.initState();
    _startSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chromecast Devices'),
      ),
      body: _buildChromecastList(),
    );
  }

  Widget _buildChromecastList() {
    return FutureBuilder<List<CastDevice>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error.toString()}'),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return Center(
            child: Text("${getLang(context, "Cast_not_found")}"),
          );
        }

        return ListView(
          children: snapshot.data!.map((device) {
            return ListTile(
              title: Text(device.name),
              onTap: () {
                _connectAndPlayMedia(context, device);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _startSearch() {
    _future = CastDiscoveryService().search();
  }

  Future<void> _connectAndPlayMedia(BuildContext context, CastDevice device) async {
    final session = await CastSessionManager().startSession(device);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        final snackBar = SnackBar(content: Text('Connected'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    var index = 0;

    session.messageStream.listen((message) {
      index += 1;

      print('receive message: $message');

      if (index == 2) {
        Future.delayed(Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session);
        });
      }
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // set the appId of your app here
    });
  }

  void _sendMessagePlayVideo(CastSession session) {
    print('_sendMessagePlayVideo');

    var message = {
      'contentId': 'http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4',
      'contentType': 'video/mp4',
      'streamType': 'BUFFERED',
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': 'Big Buck Bunny',
        'images': [
          {'url': 'https://www.youtube.com/watch?v=yxif9Tj8fDE&t=43s'}
        ]
      }
    };

    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }
}