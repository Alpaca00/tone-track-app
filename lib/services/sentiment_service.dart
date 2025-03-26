import 'package:dio/dio.dart';
import 'dart:convert';

import '../models/mood.dart';

class SentimentResponse {
  final String sentimentResult;

  SentimentResponse({required this.sentimentResult});

  factory SentimentResponse.fromJson(Map<String, dynamic> json) {
    return SentimentResponse(
      sentimentResult: json['sentiment_result'] ?? '',
    );
  }
}

class SentimentService {
  final Dio _dio;
  final String baseUrl = 'http://localhost:5000'; // Change this to your server URL

  SentimentService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Mood> analyzeMood(String note) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/proxy-sentiment-analysis',
        data: {'text': note, 'sentiment_type': 'vader'},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          final jsonResponse = jsonDecode(response.data);
          final sentimentResponse = SentimentResponse.fromJson(jsonResponse);

          final String moodString = sentimentResponse.sentimentResult;
          try {
            return moodString.toLowerCase() == 'not negative'
                ? Mood.positive
                : moodString.toLowerCase() == 'negative'
                    ? Mood.negative
                    : Mood.neutral;
          } catch (e) {
            return Mood.neutral;
          }
        } else {
          throw Exception('The incorrect data format from the server');
        }
      } else {
        throw Exception('Sentiment analysis error :: ${response.statusCode}');
      }
    } catch (e) {
      return Mood.neutral;
    }
  }
}
