import 'package:arogya_tech/pages/patients/patients_view_model.dart';
import 'package:arogya_tech/utils/app_styles.dart';
import 'package:arogya_tech/utils/constants/app_images.dart';
import 'package:arogya_tech/utils/constants/colors_value.dart';
import 'package:arogya_tech/utils/constants/string_constants.dart';
import 'package:arogya_tech/widgets/app_bar.dart';
import 'package:arogya_tech/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';



class PatientsView extends StatelessWidget {
  const PatientsView({super.key, required this.timeSlot, required this.date, required this.doctor});
 final String timeSlot;
  final DateTime date;
  final String doctor;
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PatientsViewModel>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: viewModel.show
          ? Center(child: const CircularProgressIndicator())
          :SingleChildScrollView(
            child: Column(
            children: [
                  CustomAppBar.appBar(StringConstants.chandralekhaClinic,true,context),
            SpacerBoxes.smallHeightBox(),
                   Padding(
             padding:   EdgeInsets.symmetric(horizontal: 0.05.sw),
             child: Column(
               children: [
                 const Row(
                   children: [
                     Text(StringConstants.patientProfile,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                   ],
                 ),
                 SpacerBoxes.smallHeightBox(),
                 Image.asset(AppImages.profilePicture),
                 SpacerBoxes.midHeightBox(),
                 nameField(viewModel),
                 SpacerBoxes.smallHeightBox(),
                  phoneField(viewModel),
                 const Row(
                   children: [
                     Text(StringConstants.gender,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                   ],
                 ),
                 genderSelection(viewModel),
                 SpacerBoxes.smallHeightBox(),
                 Row(
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(StringConstants.appointmentDetails,style: AppStyles.subtitleWhite.copyWith(color: ColorsValue.greyColor),),
                         Text("$doctor ${DateFormat('EEEE').format(date).substring(0, 3)}, ${ DateFormat('d').format(date)} ${ DateFormat('MMM').format(date)}, $timeSlot",style: AppStyles.subtitleWhite.copyWith(color: ColorsValue.primaryColor),),
                       ],
                     ),
                   ],
                 ),
                 createAndBookButton(viewModel,context),
               ],
             ),
                   ),
            ],
                  ),
          ),
      ),
    );
  }

  Widget nameField(PatientsViewModel viewModel){
    return TextField(
        controller: viewModel.nameController,
      decoration: InputDecoration(
        labelText: 'Name*',
        hintText: 'Enter your name*',
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 0.05.sw,vertical: 18.h),
      ),
    );
  }

  Widget phoneField (PatientsViewModel viewModel){
    return   SizedBox(
      width: 0.92.sw,
      height: 0.2.sh,
      child: IntlPhoneField(
        controller: viewModel.phoneController ,
        initialCountryCode: 'IN',
        decoration: const InputDecoration(
          labelText: 'Phone Number*',
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        onChanged: (phone) {
          debugPrint(phone.completeNumber);
        },
        onCountryChanged: (country) {
          debugPrint('Country changed to: ${country.name}');
        },
      ),
    );
  }


  Widget genderSelection(PatientsViewModel viewModel){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          value: "Male",
          activeColor: ColorsValue.primaryColor,
          groupValue: viewModel.selectedGenderValue,
          onChanged: (value) => viewModel.onTapRadio(value),
        ),
        const Text("M"),
        const Spacer(),
        Radio(
          value: "Female",
          activeColor: ColorsValue.primaryColor,
          groupValue: viewModel.selectedGenderValue,
          onChanged: (value) => viewModel.onTapRadio(value),
        ),
        const Text("F"),
        const Spacer(),
        Radio(
          value: "Others",
          activeColor: ColorsValue.primaryColor,
          groupValue: viewModel.selectedGenderValue,
          onChanged: (value) => viewModel.onTapRadio(value),
        ),
        const Text("Others"),
        const Spacer(),
      ],
    );
  }

  Widget createAndBookButton(PatientsViewModel viewModel,BuildContext context){
    return  GestureDetector(
      onTap: ()=>viewModel.onClickCreateAndBookAppointment(date,timeSlot,doctor,context),
      child: Container(
        width: 0.7.sw,
        height: 0.05.sh,
        margin: EdgeInsets.symmetric(vertical: 0.05.sh),
        decoration: BoxDecoration(
          color: ColorsValue.secondaryColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
            child: Text(StringConstants.createAndBookAppointment,style: AppStyles.subtitleWhite,)),
      ),
    );
  }


}
