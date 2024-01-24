


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar{


  static Widget appBar(String title,bool willPop,BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.1.sh,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 5, // Spread radius
            blurRadius: 7, // Blur radius
            offset: const Offset(0, 3), // Offset in the x, y direction
          ),
        ],
      ),
      child: willPop
      ? Row(
        mainAxisAlignment: MainAxisAlignment.start,
       children: [
         IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new,size: 16,)),
         SizedBox(width: 0.2.sw),
         Center(
             child: Text(
               title,
               style: const TextStyle(color: Colors.black, fontSize: 16),
             )),
       ],
      )
      :Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          )),
    );
  }


}