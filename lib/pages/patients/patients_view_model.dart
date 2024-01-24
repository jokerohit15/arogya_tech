import 'package:arogya_tech/services/api_services.dart';
import 'package:arogya_tech/services/routes/routes.dart';
import 'package:arogya_tech/utils/constants/colors_value.dart';
import 'package:arogya_tech/utils/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PatientsViewModel extends  ChangeNotifier{

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGenderValue = "";
  bool _show= false;
  bool _showBox = false; ///makes sure the alert isn't shown until right appointment is made




  get nameController => _nameController;
  get phoneController => _phoneController;
   get selectedGenderValue => _selectedGenderValue;
   get show=>_show;


  void onTapRadio(value)
  {
    _selectedGenderValue = value;
    notifyListeners();
  }



  Future<void> onClickCreateAndBookAppointment(DateTime date, String timeSlot,String doctor,BuildContext context) async {
    int slotNumber = _calculateSlotNumber(date, timeSlot);
    if (_nameController.text.length < 4) {
      Fluttertoast.showToast(
        msg: StringConstants.errorNameShort,
      );
    }
    else if (_phoneController.text.length != 10) {
      Fluttertoast.showToast(
        msg: StringConstants.errorPhoneTenDigits,
      );
    }
    else if (_selectedGenderValue.isEmpty) {
      Fluttertoast.showToast(
        msg: StringConstants.errorChooseGenderAppointment,
      );
    }
    else
    if (_nameController.text.length > 3 && _phoneController.text.length == 10 &&
        _selectedGenderValue.isNotEmpty) {
    _conditionsFullFilled(timeSlot, date);
     if (_showBox)
    {
      Navigator.pushNamed(context, Routes.appointmentsViewsRoute);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Icon(Icons.check_circle_outline, size: 50),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appointment added on ${DateFormat('d MMM').format(
                      date)}, $timeSlot'),
                  const SizedBox(height: 4.0), // Reduced height
                  Text('Doctor Name: $doctor'),
                  Text('Patient Name: ${_nameController.text}'),
                ],
              ),
              actions: <Widget>[
                ButtonBar(
                  alignment: MainAxisAlignment.center, // Center-align the action button
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 0.01.sh,horizontal: 0.1.sw),
                        decoration: BoxDecoration(
                          color: ColorsValue.whiteColor,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Center(child: Text('OK',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                      ),
                    ),
                  ],
                ),
              ]
          );
        },
      );
    }
    }
  }


  ///calculates slot number
  int _calculateSlotNumber(DateTime date, String slotTime) {
    // Convert the slot time to a DateTime object
    DateTime slotDateTime = DateTime(date.year, date.month, date.day);

    // Parse the slot time string (e.g., "8:15") and set the hours and minutes
    List<String> timeComponents = slotTime.split(':');
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1].substring(1,3));
    slotDateTime = slotDateTime.add(Duration(hours: hours, minutes: minutes));

    // Calculate the slot number based on the total minutes from midnight
    int totalMinutes = slotDateTime.difference(DateTime(slotDateTime.year, slotDateTime.month, slotDateTime.day)).inMinutes;
    int slotNumber = totalMinutes ~/ 15;

    return slotNumber;
  }



  ///contains the operations to follow when conditions fulfilled
  Future<void> _conditionsFullFilled(String slotNumber,DateTime date) async {
    _show = true;
    notifyListeners();
    Map<String, dynamic> patientDetails = {
      "full_name": _nameController.text,
      "phone": _phoneController.text,
      "gender": _selectedGenderValue
    };
    await ApiServices.postPatientData(patientDetails).then((value) {
      String patientId = value.values.first;
      if(slotNumber.isEmpty || patientId.isEmpty) ///errorHandling
      {
        Fluttertoast.showToast(
          msg: StringConstants.errorNotFoundTryAgain,
        );
      }
      else{
        final Map<String, dynamic> appointmentDetails = {
          "doctor_id": "147",
          "patient_id": patientId,
          "slot_value": slotNumber,
          "status": "scheduled",
          "created_on": "",
          "scheduled_date": DateFormat('yyyy-MM-dd').format(date),
          "created_by": "1106"
        };
        ApiServices.postApiData(appointmentDetails);
        _showBox = true;
      }
    });
    _show = false;
    notifyListeners();
  }

}