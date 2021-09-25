import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_hagz/layout/bottom_nav_screen.dart';
import 'package:yalla_hagz/modules/choosing_screen.dart';
import 'package:yalla_hagz/shared/components.dart';
import 'package:yalla_hagz/shared/constants.dart';
import 'package:yalla_hagz/shared/cubit/cubit.dart';
import 'package:yalla_hagz/shared/cubit/states.dart';

import 'rating_screen.dart';


class PaymentScreen extends StatelessWidget {

  var choose;
  var school;
  var date;
  var field;
  var count;
  PaymentScreen(this.choose,this.school,this.date,this.field,this.count);
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Payment',
              style: TextStyle(
                  color: Color(0xff388E3C),
                  fontWeight: FontWeight.bold,
                  fontSize: 30
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Credit',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text(
                      '${cubit.userModel["balance"]}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width:5),
                    Text(
                      'EGP',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text(
                  'Pay With',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.circle_outlined),
                      SizedBox(width: 5,),
                      Icon(Icons.credit_card),
                      SizedBox(width: 5),
                      Text('Credit/Debit Card'),
                    ],
                  ),

                ),
                MaterialButton(
                    onPressed: () {
                      cubit.cashSelection();
                    },
                    child: Row(
                      children: [
                        cubit.isCash?Icon(
                            Icons.circle,
                            color:defaultColor
                        ):Icon(
                          Icons.circle_outlined,
                        ),
                        SizedBox(width: 5,),
                        Icon(Icons.money),
                        SizedBox(width: 5),
                        Text('Cash'),
                      ],
                    )
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.circle_outlined),
                      SizedBox(width: 5,),
                      Icon(Icons.money),
                      SizedBox(width: 5),
                      Text('Vodafone Cash'),
                    ],
                  ),

                ),
                SizedBox(height: 20,),
                Text(
                  'Payment Summary',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 15,),

                Row(
                  children: [
                    Text('Hourly Rate'),
                    Spacer(),
                    Text('EGP ${school["fees"]}'),

                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text('Number of Hours'),
                    Spacer(),
                    Text('${choose.length}'),

                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text('Wallet'),
                    Spacer(),
                    Text('(-)${cubit.userModel["balance"]}'),

                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text('Total'),
                    Spacer(),
                    Text('EGP ${choose.length*school["fees"]}'),
                  ],
                ),
                Spacer(),
                Container(
                  width: double.infinity,
                  color: Color(0xff388E3C),
                  child: defaultTextButton(
                    color: Colors.white,
                    backGroundColor: Color(0xff388E3C),
                    function: () {
                      for(int i=0; i<choose.length ; i++){
                        cubit.updateBookingTimeModel(cityId: cubit.currentCity, schoolId: school["schoolId"], date: date, field: field.toString(), from: cubit.startTimes[choose[i]]["from"].toString(), data: {
                          "isBooked": true,
                          "userId":uId
                        });
                      }
                      cubit.userModel["mala3eb"].add({
                        "schoolId":school["schoolId"],
                        "from":cubit.startTimes[choose[0]]["from"],
                        "to":cubit.startTimes[choose[choose.length-1]]["to"],
                        "schoolName":school["name"],
                        "fees":school["fees"],
                        "city":cubit.currentCity,
                        "date": date,
                        "field": field,
                        "location":school["mapLocation"],
                        "isDone":false,
                      });
                      cubit.updateUserData(data: {
                        "mala3eb": cubit.userModel["mala3eb"]
                      });
                      if(count>school["policy"]){
                        showToast(
                            text: "You have successfully booked but Ta3ala 2df3 ya 7iwan ya nasab ya beheema",
                            state: ToastStates.WARNING
                        );
                      }else {
                        showToast(text:"You have successfully booked",state:ToastStates.SUCCESS);
                      }
                      navigateAndFinish(context, BottomNavScreen());
                    },
                    text: 'YALA',
                  ),
                ),



              ],
            ),
          ),
        );
      },
    );

  }
}