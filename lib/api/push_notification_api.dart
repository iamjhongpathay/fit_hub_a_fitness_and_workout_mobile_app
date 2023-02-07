import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class Messaging{
  static final Client client = Client();

  static const String serverKey =
      'AAAAaw1JUDI:APA91bFOWVIypdjIysCLOUDOHvDuUfq28Ni83T-8myWiHyvEOqDJmKecmlanGsBh-xALBjF0dybvksVtY1h_5nuJP09T1EpoQVHdSoeV14Jd3abAN-ZKCQdtSzrAoiO7fmrHB5ZGQc4m';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
      {@required String title,
        @required String body,
        @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) => client.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title',
          'priority': 'high',
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}