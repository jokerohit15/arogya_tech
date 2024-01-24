

import 'package:arogya_tech/pages/appointments/appointments_view.dart';
import 'package:arogya_tech/pages/appointments/appointments_view_model.dart';
import 'package:arogya_tech/pages/patients/patients_view.dart';
import 'package:arogya_tech/pages/patients/patients_view_model.dart';
import 'package:arogya_tech/services/routes/route_arguments.dart';
import 'package:arogya_tech/services/routes/route_transistions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




///guides the routes and allows named routing
class Routes{


  static const String patientViewRoute = "/patientViewRoute";
  static const String appointmentsViewsRoute = "/appointmentsViewRoute";



  static Route<dynamic>? generateRoutes(RouteSettings? settings) {
    switch (settings!.name) {
      case patientViewRoute:
        var args = settings.arguments as PatientsRouteArguments;
        return FadeRoute(
          page: ChangeNotifierProvider(
            create: (context) => PatientsViewModel(),
            child:  PatientsView(
              timeSlot: args.timeSlot,
              date: args.date,
              doctor: args.doctor,
            ),
          ),
        );

      case appointmentsViewsRoute:
        return FadeRoute(
          page: ChangeNotifierProvider(
            create: (context) => AppointmentsViewModel(),
            child: const AppointmentsView(),
          ),
        );

      default:
        return FadeRoute(
          page: const Scaffold(
            body: Center(
              child: Text(
                'No route defined',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
    }
  }
  }