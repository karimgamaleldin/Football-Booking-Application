import 'dart:convert';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yalla_hagz/layout/bottom_nav_screen.dart';
import 'package:yalla_hagz/shared/components.dart';
import 'package:yalla_hagz/shared/constants.dart';
import 'package:yalla_hagz/shared/cubit/cubit.dart';
import 'package:yalla_hagz/shared/cubit/states.dart';

import 'payment_screen.dart';

class SchoolScreen extends StatelessWidget {
  var school;
  int currentField = 1;
  var dateController = TextEditingController();
  bool dateIsEmpty = true;
  bool fieldIsEmpty = true;
  bool notify = false;
  bool buildListView = false;
  String day = "";
  SchoolScreen(this.school);
  List<int> choose = [];
  List<int> fromTime = [];
  int count = 0;
  //DateFormat("yyyy-MM-dd").format(DateTime.now())
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    cubit.addOneToDate(
      context: context,
      date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      currentField: currentField,
      school: school
    );
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                cubit.daySelectedFalse();
                navigateAndReplace(context, BottomNavScreen());
              },
            ),
          ),
          body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        school["name"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          school["location"],
                          style: TextStyle(
                            color:Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 20
                          ),
                        ),
                        const Spacer(),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: defaultColor,
                          child: TextButton(
                            onPressed:() {
                              launch(school["mapLocation"]);
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                SizedBox(width:5),
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    defaultRatingBar(
                        rating: school["rating"],
                        gestures: true,
                        context: context
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              "${school["name"]} offers:",
                            style: TextStyle(
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontSize: 22,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 20,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context,index) => Text(
                                    "#${school["extras"][index]}",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText1!.color,
                                    fontSize: 16
                                  ),
                                ),
                                separatorBuilder: (context,index) => const SizedBox(width: 10,),
                                itemCount: school["extras"].length
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "Policy: ${school["policyStr"]}",
                          style:TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        // ConditionalBuilder(
                        //   condition: currentField != 1000000 ,
                        //   builder: (context) {
                        Column(
                              children: [
                                ConditionalBuilder(
                                  condition: ServicesBinding.instance!.defaultBinaryMessenger.send('flutter/assets', Utf8Codec().encoder.convert(Uri(path: Uri.encodeFull(school["fieldsImages"][currentField - 1])).path).buffer.asByteData())!=null,
                                  builder: (context) {
                                    return Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadiusDirectional.all(
                                              // topStart: Radius.circular(30),
                                              // topEnd: Radius.circular(30)
                                            Radius.circular(30)
                                          )
                                      ),
                                      height: 200,
                                      width: double.infinity,
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(school["fieldsImages"][currentField - 1]) ,
                                      ),
                                    );
                                  },
                                  fallback: (context)=>Center(child: CircularProgressIndicator(
                                    color: defaultColor,
                                  )),
                                ),
                                Container(
                                  height: 50,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        color: (currentField == index+1) ? defaultColor : Colors.grey[300],
                                        child: TextButton(
                                          onPressed: () {
                                            choose = [];
                                            fromTime = [];
                                            count = 0;
                                            currentField = index+1;
                                            // print(cubit.fields);
                                            cubit.changeField();
                                            cubit.addOneToDate(
                                                context: context,
                                                date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                                                currentField: currentField,
                                                school: school
                                            );
                                            if(school["calendar$currentField"][day]!=null&&school["calendar$currentField"][day].length != 1&&dateController.text.isNotEmpty) {
                                              AppCubit.get(context).checkDateInDataBase(
                                                  date: dateController.text,
                                                  cityId: AppCubit.get(context).currentCity,
                                                  schoolId: school["schoolId"],
                                                  field: currentField.toString(),
                                                  fees: school["fees"],
                                                  intervals:school["calendar$currentField"][day]
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Field ${index+1}',
                                            style: TextStyle(
                                              color: (currentField == index+1) ? Colors.white : defaultColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context,
                                        index) => const SizedBox(width: 5,),
                                    itemCount: school["fields"],
                                  ),
                                ),
                              ],
                            )
                          //},
                          // fallback: (context) {
                          //   return Container(
                          //     height: 50,
                          //     child: ListView.separated(
                          //       scrollDirection: Axis.horizontal,
                          //       itemBuilder: (context, index) {
                          //         return Card(
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(30),
                          //           ),
                          //           color: Colors.grey[300],
                          //           child: TextButton(
                          //             onPressed: () {
                          //               currentField = index+1;
                          //               cubit.changeField();
                          //             },
                          //             child: Text(
                          //               'Field ${index+1}',
                          //               style: TextStyle(
                          //                 color: defaultColor,
                          //                 fontSize: 14,
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //       separatorBuilder: (context, index) => const SizedBox(width: 5,),
                          //       itemCount: school["fields"],
                          //     ),
                          //   );
                          // },

                        //),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Choose a day within a week from today",
                          textAlign: TextAlign.center,
                          style:Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          day = AppCubit.get(context).dateToDay(date: DateTime.parse(cubit.dates[index]).toString());
                          // print(day);
                          // cubit.changeDay();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap:(){
                                  // for(int i=0;i<cubit.dayEmpty.length;i++) print(cubit.dayEmpty[i]);
                                  // print(day);
                                  // cubit.changeDay();
                                  cubit.changeDaySelected(index);
                                  choose = [];
                                  fromTime = [];
                                  count = 0;
                                  dateController.text = cubit.dates[index];
                                  day = AppCubit.get(context).dateToDay(date: DateTime.parse(dateController.text).toString());
                                  if(cubit.daySelected[index]){
                                    if (school["calendar$currentField"][day].length != 1) {
                                      AppCubit.get(context).checkDateInDataBase(
                                          date: dateController.text,
                                          cityId: AppCubit.get(context).currentCity,
                                          schoolId: school["schoolId"],
                                          field: currentField.toString(),
                                          fees: school["fees"],
                                          intervals: school["calendar$currentField"][day]);
                                    }
                                    cubit.changeDate();

                                  }else{
                                    day = "";
                                    dateController.text = "";
                                    cubit.startTimes = [];
                                    cubit.booked = [];
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  color: cubit.daySelected[index]?defaultColor:school["calendar$currentField"][day].length == 1||(cubit.dayEmpty[cubit.searchForField(currentField)][index])?Colors.red:Theme.of(context).scaffoldBackgroundColor,
                                  child: Row(
                                    children: [
                                      Container(
                                        clipBehavior:Clip.antiAliasWithSaveLayer,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadiusDirectional.all(
                                                    Radius.circular(30)
                                                )
                                            ),
                                            height: 100,
                                            width: 100,
                                            child: const Image(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    'assets/images/calender.jpg'
                                                )
                                            ),
                                          ),
                                          const SizedBox(width:10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              Text(
                                                day,
                                                style: TextStyle(
                                                  color:Theme.of(context).textTheme.bodyText1!.color
                                                ),
                                              ),
                                              Text(
                                                DateFormat.yMMMd().format(DateTime.parse(cubit.dates[index])),
                                                style: TextStyle(
                                                    color:Theme.of(context).textTheme.bodyText1!.color
                                                ),
                                              ),
                                              Text(
                                                "Field: $currentField",
                                                style: TextStyle(
                                                    color:Theme.of(context).textTheme.bodyText1!.color
                                                ),
                                              ),
                                              Text(
                                                school["calendar$currentField"][day].length == 1||cubit.dayEmpty[cubit.searchForField(currentField)][index]?"No bookings are available":"Bookings are available",
                                                style: TextStyle(
                                                    color:Theme.of(context).textTheme.bodyText1!.color
                                                ),
                                              ),
                                            ]
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                          },
                        separatorBuilder: (context,index)=>myDivider(),
                        itemCount: cubit.dates.length
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Or choose a date that suits you",
                          textAlign: TextAlign.center,
                          style:Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    defaultFormField(
                    context: context,
                    controller: dateController,
                    prefix: Icons.date_range,
                    text: 'Choose a Date',
                    onTap: () {
                      showRoundedDatePicker(
                          firstDate: DateTime.now(),
                          lastDate: AppCubit.get(context).createLastDate(),
                          context: context,
                          theme: ThemeData(
                            primaryColor: Theme.of(context).scaffoldBackgroundColor
                          ),
                          styleDatePicker: MaterialRoundedDatePickerStyle(
                            textStyleDayButton:
                            TextStyle(
                                fontSize: 36,
                                color: Theme.of(context).textTheme.bodyText1!.color
                            ),
                            textStyleYearButton: TextStyle(
                              fontSize: 52,
                              color: Theme.of(context).textTheme.bodyText1!.color,
                            ),
                            textStyleDayHeader: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).textTheme.bodyText1!.color,
                            ),
                            textStyleCurrentDayOnCalendar: TextStyle(
                                fontSize: 32,
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontWeight: FontWeight.bold),
                            textStyleDayOnCalendar: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).textTheme.bodyText1!.color
                            ),
                            textStyleDayOnCalendarSelected: TextStyle(
                                fontSize: 32,
                                color: Theme.of(context).scaffoldBackgroundColor,
                                fontWeight: FontWeight.bold
                            ),
                            textStyleDayOnCalendarDisabled: TextStyle(
                                fontSize: 28,
                                color: Colors.grey[500]
                            ),
                            textStyleMonthYearHeader: TextStyle(
                                fontSize: 32,
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontWeight: FontWeight.bold
                            ),
                            paddingDatePicker: const EdgeInsets.all(0),
                            paddingMonthHeader: const EdgeInsets.all(32),
                            paddingActionBar: const EdgeInsets.all(16),
                            paddingDateYearHeader: const EdgeInsets.all(32),
                            sizeArrow: 50,
                            colorArrowNext: Theme.of(context).textTheme.bodyText1!.color,
                            colorArrowPrevious: Theme.of(context).textTheme.bodyText1!.color,
                            marginLeftArrowPrevious: 16,
                            marginTopArrowPrevious: 16,
                            marginTopArrowNext: 16,
                            marginRightArrowNext: 32,
                            textStyleButtonAction: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).scaffoldBackgroundColor
                            ),
                            textStyleButtonPositive:TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontWeight: FontWeight.bold
                            ),
                            textStyleButtonNegative: TextStyle(
                                fontSize: 28,
                                color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5)),
                            decorationDateSelected: BoxDecoration(
                                color: defaultColor,
                                shape: BoxShape.circle
                            ),
                            backgroundPicker:  Theme.of(context).scaffoldBackgroundColor,
                            backgroundActionBar: Theme.of(context).scaffoldBackgroundColor,
                            backgroundHeaderMonth: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          styleYearPicker: MaterialRoundedYearPickerStyle(
                            textStyleYear:
                            TextStyle(
                                fontSize: 40,
                                color: Theme.of(context).textTheme.bodyText1!.color
                            ),
                            textStyleYearSelected: TextStyle(
                                fontSize: 56,
                                color:  Theme.of(context).textTheme.bodyText1!.color,
                                fontWeight: FontWeight.bold),
                            heightYearRow: 100,
                            backgroundPicker: Theme.of(context).scaffoldBackgroundColor,
                          )).then((value) {
                            cubit.daySelectedFalse();
                        day = AppCubit.get(context).dateToDay(date: value.toString());
                        dateController.text = DateFormat("yyyy-MM-dd").format(value!);
                        choose = [];
                        fromTime = [];
                        count = 0;
                        if(school["calendar$currentField"][day].length != 1) {
                          AppCubit.get(context).checkDateInDataBase(
                              date: dateController.text,
                              cityId: AppCubit.get(context).currentCity,
                              schoolId: school["schoolId"],
                              field: currentField.toString(),
                              fees: school["fees"],
                              intervals:school["calendar$currentField"][day]);
                        }
                        AppCubit.get(context).changeDate();
                      });

                    }),
                    const SizedBox(height: 10),
                    ConditionalBuilder(
                      condition: dateController.text.isNotEmpty,
                      builder: (context)
                      {
                        day = AppCubit.get(context).dateToDay(date: DateTime.parse(dateController.text).toString());
                        return ConditionalBuilder(
                                condition: school["calendar$currentField"][day].length != 1 && AppCubit.get(context).startTimes.isNotEmpty,
                                builder: (context) {
                                  return Column(
                                    children: [
                                      Text('Times:', style: Theme.of(context).textTheme.bodyText1),
                                      ConditionalBuilder(
                                          condition: state is! AppGetBookingTimeLoadingState && state is! AppCreateBookingTimeLoadingState,
                                          builder: (context) {
                                            return ListView.separated(
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) => ConditionalBuilder(
                                                          condition: true,
                                                          builder: (context) {
                                                            int from = AppCubit.get(context).startTimes[index]["from"];
                                                            int to = AppCubit.get(context).startTimes[index]["to"];
                                                            String strFrom = formatTime(num: from);
                                                            String strTo = formatTime(num: to);
                                                            return Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  cubit.selected[index] = !cubit.selected[index];
                                                                  cubit.changeCardColor();
                                                                  if (cubit.selected[index]) {
                                                                    choose.add(index);
                                                                    fromTime.add(AppCubit.get(context).startTimes[index]["from"]);
                                                                    count++;
                                                                  } else {
                                                                    for (int i = 0; i < choose.length; i++) {
                                                                      if (choose[i] == index) {
                                                                        choose.removeAt(i);
                                                                        fromTime.remove(AppCubit.get(context).startTimes[index]["from"]);
                                                                        count--;
                                                                      }
                                                                    }
                                                                  }
                                                                },
                                                                child: Card(
                                                                  color: cubit.selected[index] ? defaultColor.withOpacity(0.8) : Theme.of(context).scaffoldBackgroundColor,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(30),
                                                                  ),
                                                                  elevation: 2,
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        '$day ${DateFormat.yMMMd().format(DateTime.parse(dateController.text))}, from: $strFrom to: $strTo',
                                                                        style: TextStyle(
                                                                            color: Theme.of(context).textTheme.bodyText1!.color
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                            decoration: const BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(30))),
                                                                            height: 100,
                                                                            width: 100,
                                                                            child: const Image(fit: BoxFit.cover, image: AssetImage('assets/images/field.jpg')),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 10
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                school["name"],
                                                                                style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                                                                              ),
                                                                              Text(
                                                                                'Field $currentField',
                                                                                style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          fallback: (context) =>
                                                              Container(),
                                                        ),
                                                separatorBuilder:
                                                    (context, index) =>
                                                        myDivider(),
                                                itemCount: AppCubit.get(context).startTimes.length);
                                          },
                                          fallback: (context) => Center(
                                                  child: CircularProgressIndicator(
                                                color: defaultColor,
                                              ))),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ConditionalBuilder(
                                            condition: count != 0,
                                            builder: (context) {
                                              return Container(
                                                width: double.infinity,
                                                color: defaultColor,
                                                child: defaultTextButton(
                                                  color: Colors.white,
                                                  backGroundColor: defaultColor,
                                                  function: () {
                                                    choose.sort();
                                                    bool isConsequent = true;
                                                    for(int j=0;j<choose.length;j++){
                                                      if(j!=choose.length-1){
                                                        if(cubit.startTimes[choose[j]]["to"]!=cubit.startTimes[choose[j+1]]["from"]){
                                                          showToast(
                                                              text: "The reservations are not consequent",
                                                              state: ToastStates.ERROR
                                                          );
                                                          isConsequent = false;
                                                          break;
                                                        }
                                                      }
                                                    }
                                                    if(isConsequent) {
                                                      if (count > 3) {
                                                        showToast(
                                                          text: "You a have limit of 3 hours",
                                                        state: ToastStates.WARNING
                                                        );
                                                      } else {
                                                        bool flag = false;
                                                        for (int i = 0; i < cubit.booked.length; i++) {
                                                        if (uId == cubit.booked[i]["userId"] && !cubit.booked[i]["isDone"]) {
                                                          showToast(
                                                              text: "You already reserved in this school on ${dateController.text}",
                                                              state: ToastStates.WARNING
                                                          );
                                                          flag = true;
                                                          break;
                                                        }
                                                      }
                                                      if (!flag) {
                                                        navigateTo(
                                                            context,
                                                            PaymentScreen(
                                                                choose,
                                                                school,
                                                                dateController.text,
                                                                currentField,
                                                                count,
                                                                fromTime
                                                            )
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                                  text: 'YALA',
                                                ),
                                              );
                                            },
                                            fallback: (context) {
                                              return Container(
                                                width: double.infinity,
                                                color: Colors.grey[300],
                                                child: defaultTextButton(
                                                  color: defaultColor,
                                                  backGroundColor:
                                                      Colors.grey[300],
                                                  function: () {
                                                    showToast(
                                                        text:
                                                            "Please choose a reservation",
                                                        state: ToastStates
                                                            .WARNING);
                                                  },
                                                  text: 'YALA',
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  );
                                },
                                fallback: (context) => Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No reservations on $day ${dateController.text} field $currentField",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color),
                                  ),
                                ),
                              );
                            },
                      fallback: (context) => Container()
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
