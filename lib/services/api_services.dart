import 'dart:convert';
import 'package:arogya_tech/utils/constants/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class ApiServices{


  static Future<Map<String, dynamic>> postPatientData(Map<String, dynamic> patientData ) async {
    final url = Uri.parse(StringConstants.bookAppointmentUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(patientData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint('Post Patient Response: $data');
        return data;
      } else {
        debugPrint('Error: ${response.statusCode}');
        return {'error':'Error: ${response.statusCode}'};
      }
    } catch (e) {
      debugPrint('Error: $e');
      return {'error':e};
    }
  }




  static void postApiData(Map<String, dynamic> appointmentDetails) async {
    final url = Uri.parse(StringConstants.doctorIdUrl);



    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointmentDetails),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint('Post API Response: $data');
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }


///returns a list of data of patients
  static Future<List> getPatientsData(String date) async {
    final url = Uri.parse("${StringConstants.patientDataUrl}$date&doctor_id=147");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body);

        // Access the data from the response
        debugPrint('API Response: $data');

        return data;

      } else {
        // Handle error response
        debugPrint('Error: ${response.statusCode}');
        return ['Error: ${response.statusCode}'];
      }
    } catch (e) {
      // Handle network or unexpected errors
      debugPrint('Error: $e');
      return ['Error: $e'];
    }
  }
}