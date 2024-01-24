import 'package:arogya_tech/pages/appointments/appointments_view_model.dart';
import 'package:arogya_tech/pages/appointments/widgets/animated_tool_tip.dart';
import 'package:arogya_tech/pages/appointments/widgets/progress_indicator.dart';
import 'package:arogya_tech/utils/constants/colors_value.dart';
import 'package:arogya_tech/utils/constants/string_constants.dart';
import 'package:arogya_tech/widgets/app_bar.dart';
import 'package:arogya_tech/widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';








class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  late AppointmentsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<AppointmentsViewModel>(context, listen: false);
    viewModel.fetchBookedAppointments(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppointmentsViewModel>(context, listen: true);
    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: viewModel.selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
      );

      if (picked != null && picked != viewModel.selectedDate) {
        viewModel.assignDate(picked);
      }
    }

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              CustomAppBar.appBar(StringConstants.appointments, false, context),
              SpacerBoxes.smallHeightBox(),
              heading(selectDate),
              dateRow(viewModel),
              const AnimatedToolTip(text: "Scroll this to select date ",icon: Icons.arrow_drop_up,),
              doctorAmPm(viewModel),
              hours(viewModel),
              const AnimatedToolTip(text: "Click to select time slot ",icon: Icons.arrow_drop_up,),
              viewModel.selectedHour == 0
                  ? const SizedBox.shrink()
                  : timeSlotRow(viewModel),
              SpacerBoxes.midHeightBox(),
              //SpacerBoxes.largeHeightBox(),
              scheduleAppointmentButton(viewModel),
            ],
          ),
        ),
      ),
    );
  }


  Widget heading(Function selectDate) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            StringConstants.pickADate,
            style: TextStyle(
                color: ColorsValue.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 22),
          ),
          Expanded(child: const AnimatedToolTip(text: "Click to select date from Calender",icon: Icons.arrow_forward_ios,)),
          IconButton(
              onPressed: () => selectDate(context),
              icon: const Icon(
                Icons.calendar_today_outlined,
                color: ColorsValue.primaryColor,
              )),
        ],
      ),
    );
  }


  ///has the list of dates displayed
  Widget dateRow(AppointmentsViewModel viewModel) {
    return SizedBox(
        height: 0.2.sh,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 30,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              return GestureDetector(
                onTap: () {
                  viewModel.assignDate(date);
                },
                child: dateBox(date, viewModel),
              );
            }));
  }

  Widget doctorAmPm(AppointmentsViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
      child: Row(
        children: [
          doctorsDropDownList(viewModel),
         // const Expanded(child: SizedBox(width: 10)),
          const Column(
            children: [
              AnimatedToolTip(text: "See evening timings", icon: Icons.arrow_forward_ios),
              AnimatedToolTip(text: "select doctor", icon: Icons.arrow_back_ios_new),
            ],
          ),
          amPmBox(true, viewModel),
          amPmBox(false, viewModel),
        ],
      ),
    );
  }

  Widget hours(AppointmentsViewModel viewModel) {
    return SizedBox(
      height: 0.18.sh,
      child: PageView(
        controller: viewModel.amPmController,
        physics: const NeverScrollableScrollPhysics(),
        // onPageChanged: (index) => viewModel.onTapAmPm(),
        scrollDirection: Axis.horizontal,
        children: [hourRow(true, viewModel), hourRow(false, viewModel)],
      ),
    );
  }

  Widget timeSlotRow(AppointmentsViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        slotBox(
            viewModel.selectedHour, viewModel.minutes[0], viewModel.minutes[1],0),
        slotBox(
            viewModel.selectedHour, viewModel.minutes[1], viewModel.minutes[2],1),
        slotBox(
            viewModel.selectedHour, viewModel.minutes[2], viewModel.minutes[3],2),
        slotBox(
            viewModel.selectedHour, viewModel.minutes[3], viewModel.minutes[0],3),
      ],
    );
  }

  Widget slotBox(int hour, String minMinBar, String minMaxBar,int index) {
    return GestureDetector(
      onTap: ()=> viewModel.onTapTimeSlot("$hour : $minMinBar ${viewModel.isAm ? "AM" : "PM"}",index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.015.sw),
        padding: EdgeInsets.symmetric(horizontal: 0.015.sw, vertical: 0.01.sh),
        decoration: BoxDecoration(
          color: viewModel.timeSlotColor[index],
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: ColorsValue.blackColor),
        ),
        child: Center(
            child: Text(
          "$hour : $minMinBar - ${minMinBar == "45" ? hour + 1 : hour} : $minMaxBar",
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        )),
      ),
    );
  }

  Widget scheduleAppointmentButton(AppointmentsViewModel viewModel) {
    return GestureDetector(
      onTap: ()=>viewModel.onClickScheduleAnAppointment( context),
      child: Container(
        width: 0.5.sw,
        height: 0.06.sh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: ColorsValue.lightPrimaryColor,
        ),
        child: const Center(
            child: Text(
          StringConstants.scheduleAnAppointment,
          style: TextStyle(
              fontSize: 14,
              color: ColorsValue.blackColor,
              fontWeight: FontWeight.w700),
        )),
      ),
    );
  }

  Widget amPmBox(bool isAmBox, AppointmentsViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.01.sw),
      child: GestureDetector(
        onTap: () => viewModel.onTapAmPm(),
        child: Container(
          height: 0.1.sw,
          width: 0.1.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: viewModel.returnAmColor(isAmBox),
          ),
          child: Center(
              child: Text(
            isAmBox ? "AM" : "PM",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget doctorsDropDownList(AppointmentsViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 0.005.sh),
      decoration: BoxDecoration(
        color: ColorsValue.lightestPrimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: viewModel.selectedDoctor,
        onChanged: (newDoctor) => viewModel.onSelectDoctor(newDoctor!),
        items: viewModel.doctors.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                  color: ColorsValue.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
          );
        }).toList(),
        underline: Container(
          height: 2,
          color: ColorsValue.lightestPrimaryColor,
        ),
        icon: const Icon(Icons.arrow_drop_down, color: ColorsValue.blackColor),
        iconSize: 24,
        elevation: 16,
      ),
    );
  }

  Widget dateBox(DateTime date, AppointmentsViewModel viewModel) {
    bool isSelectedDay = viewModel.selectedDate.day == date.day;
    return Container(
      height: 0.2.sh,
      width: 0.2.sw,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorsValue.lightestPrimaryColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: isSelectedDay ? ColorsValue.blackColor : Colors.transparent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('MMM').format(date),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isSelectedDay
                  ? ColorsValue.blackColor
                  : ColorsValue.greyColor,
            ),
          ),
          SizedBox(height: 0.01.sh),
          Text(
            DateFormat('d').format(date),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
              color: isSelectedDay
                  ? ColorsValue.blackColor
                  : ColorsValue.greyColor,
            ),
          ),
          SizedBox(height: 0.01.sh),
          Text(
            DateFormat('EEEE').format(date).substring(0, 3),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isSelectedDay
                  ? ColorsValue.blackColor
                  : ColorsValue.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget hourRow(bool isAm, AppointmentsViewModel viewModel) {
    return SizedBox(
        height: 0.2.sh,
        width: 1.sw,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              int hour = isAm
                  ? viewModel.amTimeSlot[index]
                  : viewModel.pmTimeSlot[index];
              return GestureDetector(
                onTap: () => viewModel.onTapHour(hour),
                child: hourBox(hour),
              );
            }));
  }

  Widget hourBox(int hour) {
    List<int> appointments = viewModel.getSlot();
    return Container(
      width: 0.12.sh,
      height: 0.12.sh,
      padding: EdgeInsets.symmetric(horizontal: 0.01.sw),
      margin: EdgeInsets.symmetric(horizontal: 0.02.sw),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsValue.whiteColor,
        border: Border.all(color: ColorsValue.lightGreenColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 1, // Spread radius
            blurRadius: 2, // Blur radius
            offset: const Offset(0, 2), // Offset in the x, y direction
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ProgressIndicatorWidget(
            quadrants: appointments,
          ),
          Text(
            hour.toString(),
            style: const TextStyle(
              color: ColorsValue.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }



}
