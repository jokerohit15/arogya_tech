import 'package:arogya_tech/pages/appointments/appointments_view.dart';
import 'package:arogya_tech/pages/appointments/appointments_view_model.dart';
import 'package:arogya_tech/services/api_services.dart';
import 'package:arogya_tech/services/routes/routes.dart';
import 'package:arogya_tech/utils/constants/colors_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

void main() {
  // ApiServices.getPatientsData();
  // ApiServices.postApiData();
  // ApiServices.postPatientData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
          builder: FToastBuilder(),
            title: 'Arogya Tech',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: ColorsValue.primaryColor),
              useMaterial3: true,
            ),
            initialRoute: Routes.appointmentsViewsRoute,
            onGenerateRoute: Routes.generateRoutes,
          );
        }
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   bool isTooltipVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // Show the tooltip-like message after a delay
//     Timer(Duration(seconds: 2), () {
//       setState(() {
//         isTooltipVisible = true;
//       });
//       // Hide the tooltip-like message after 5 seconds
//       Timer(Duration(seconds: 5), () {
//         setState(() {
//           isTooltipVisible = false;
//         });
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Auto-display Tooltip Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Your button action here
//                 print('Button clicked!');
//               },
//               child: Text('Button'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
