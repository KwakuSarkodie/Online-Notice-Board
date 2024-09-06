import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
// import 'package:notice_board/core/constant.dart';

class SmsGptModel{
// var OPENAI_API_KEY ='sk-proj-tQnTNK1sBVlN9I0KoKP1T3BlbkFJS3o31FFjzSunGrZCMzZj';
// var OPENAI_API_URL = 'https://api.openai.com//v1/chat/completions';
// var OPENAI_API_MODEL = 'gpt-4o';

  static Future<int> contentContainProfain(String content) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com//v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer sk-proj-tQnTNK1sBVlN9I0KoKP1T3BlbkFJS3o31FFjzSunGrZCMzZj',
        },
        body: json.encode({
          "model": 'gpt-4o',
          "messages": [
            {"role": "system", "content": "You are a helpful profainn/nude content detector."},
            {"role": "user", "content": [
              {
              'type': 'text',
              'text': 'Does the following content contain any profanity, nudity, or offensive content? Provide answer on a scale of 0-5, how offensive is this content? Answer should be only a single number'
              },
              {
              'type': 'text',
              'text': content
            }]}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var output= data['choices'][0]['message']['content'].toString();
        return int.tryParse(output) ?? 0;
      } else {
        print('Error: ${response.reasonPhrase}');
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
static Future<int> imageIsProfain(
      Uint8List imageToBase64) async {
    try {
      String base64Image = base64Encode(imageToBase64);
      final response = await http.post(
        Uri.parse('https://api.openai.com//v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer sk-proj-tQnTNK1sBVlN9I0KoKP1T3BlbkFJS3o31FFjzSunGrZCMzZj',
        },
        body: json.encode({
          "model": '',
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                      "Does the image contain any profanity, nudity, or offensive content? Provide answer on a scale of 0-5, how offensive is this image? Answer should be only a single number"
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        var answer= data['choices'][0]['message']['content'];
        return int.tryParse(answer.toString()) ?? 0;
      } else {
        print('Error: ${response.reasonPhrase}');
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

static const String baseUrl =
      'https://sms.arkesel.com/sms/api?action=send-sms&api_key=SmtPRE5HZk11Q3lKdHNGamJFRnE&to=PhoneNumber&from=SenderID&sms=YourMessage';

 static Future<bool> sendMessage(String phoneNumber, String message) async {
    try {
      final response = await http.get(Uri.parse(baseUrl
          .replaceFirst('PhoneNumber', phoneNumber)
          .replaceFirst('SenderID', 'NoticeBoard')
          .replaceFirst('YourMessage', message)));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

}