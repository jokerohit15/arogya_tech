import 'package:arogya_tech/services/api_services.dart';
import 'package:arogya_tech/services/routes/route_arguments.dart';
import 'package:arogya_tech/services/routes/routes.dart';
import 'package:arogya_tech/utils/constants/colors_value.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AppointmentsViewModel extends ChangeNotifier{

   DateTime _selectedDate = DateTime.now();
   bool _isAm = true;
   String _selectedDoctor = "Doctors";
   final List<String> _doctors = ['Doctors','Dr.Alpha', 'Dr. Beta', 'Dr. Gamma'];
   final List <int> _amTimeSlot = [8,9,10,11];
   final List <int> _pmTimeSlot= [5,6,7,8];
   final List<String> minutes = ["00","15","30","45"];
   final PageController _amPmController = PageController();
    int _selectedHour = 0;
    List<Map<String,dynamic>> _appointments = [];
   int i=0;
   String _timeSlot = "";
   List <Color> _timeSlotColor = [ColorsValue.whiteColor,ColorsValue.whiteColor,ColorsValue.whiteColor,ColorsValue.whiteColor];

   get  selectedDate => _selectedDate;
   get isAm => _isAm;
   get selectedDoctor => _selectedDoctor;
   get doctors => _doctors;
   get amTimeSlot => _amTimeSlot;
   get pmTimeSlot => _pmTimeSlot;
   get amPmController => _amPmController;
   get selectedHour => _selectedHour;
   get appointments => _appointments;
   get timeSlotColor => _timeSlotColor;

  void assignDate(DateTime picked){
    _selectedDate = picked;
    fetchBookedAppointments(DateFormat('yyyy-MM-dd').format(_selectedDate));
    notifyListeners();
   }


   void onTapHour(int hour){
    if(_selectedDoctor == "Doctors") {
      Fluttertoast.showToast(
        msg: "Select Doctor before you select time slot",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor : ColorsValue.lightestPrimaryColor,
      );
    }
    else{
      _selectedHour = hour;
      notifyListeners();
    }
   }

   void onTapAmPm(){
       _isAm = !isAm;
       _amPmController.page == 1
           ? _amPmController.animateToPage(0,
           duration: const Duration(milliseconds: 10), curve: Curves.easeInOut)
           : _amPmController.animateToPage(1,
           duration: const Duration(milliseconds: 10), curve: Curves.easeInOut);
       notifyListeners();
   }

   void onSelectDoctor (String newDoctor) {
   _selectedDoctor = newDoctor;
   notifyListeners();
   }


   Future<void> fetchBookedAppointments(String date) async {
     List patientData = await ApiServices.getPatientsData(date);
   _appointments = patientData
       .map((patient) => {
     "scheduled_date": patient["scheduled_date"],
     "slot_value": int.parse(patient["slot_value"]),
   })
       .toList();
     _appointments.sort((a, b) => a["scheduled_date"].compareTo(b["scheduled_date"]));
   }

  Color returnAmColor(bool isAmBox){
    return _isAm ?  isAmBox ? ColorsValue.lightPrimaryColor : ColorsValue.whiteColor : isAmBox ? ColorsValue.whiteColor : ColorsValue.lightPrimaryColor;
  }

  List<int> getSlot(){
    List<int> slots = [];
    for( ; i< _appointments.length;i++)
      {
        if(_selectedDate.day.toString() == _appointments[i]["scheduled_date"].substring(8) && _selectedDate.month.toString() == _appointments[i]["scheduled_date"].substring(5,7))
          {
          slots.add(_appointments[i]["slot_value"]%16 ) ;
          }
        else{
          if(slots.isNotEmpty) {
            return slots;
          }
        }
        if(slots.length == 3) {
         return slots;
        }
      }
    return slots;
  }

  void onTapTimeSlot(String timeSlot,int index){
    if(_timeSlot == timeSlot) {
      _timeSlot = "";
      _timeSlotColor[index] = ColorsValue.whiteColor;
    }
    else{
      _timeSlot = timeSlot;
     _timeSlotColor[index]  = ColorsValue.greyColor;
    }
    notifyListeners();
  }

  void onClickScheduleAnAppointment(BuildContext context){
    print("TimeSlot : $_timeSlot");
    print("Date : $_selectedDate");
    print("Doctor : $_selectedDoctor");
    if(_timeSlot.isNotEmpty) {
      Navigator.pushNamed(context, Routes.patientViewRoute,arguments: PatientsRouteArguments(_timeSlot,_selectedDate,_selectedDoctor));
    }
    else{
      Fluttertoast.showToast(
        msg: "Select Time Slot to schedule",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        backgroundColor : ColorsValue.lightestPrimaryColor,
      );

    }
  }

}