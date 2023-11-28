import 'dart:convert';

import 'package:http/http.dart' as http;

class FbHttpNotificationRequest {


  void sendNotification(String title , String body , List<dynamic> listName) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
      'key=AAAAQe4Xhhg:APA91bFaeHpkevDbM8EyIdq1fpjDRKNZB-Y8OPV3CHcTEtUbbuaiFIv1--ZzKV_YVhRf1iWPDLyhkxPCLeJasGH0CPEb7-NVYBSBMdjDqzPNU1lFh9iLkK34f75j-Nd0HX8BKoT7Ym8e'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "notification": {
        "title": title,
       "body": body,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "data": {"data": "any value "},
      "registration_ids": listName
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
