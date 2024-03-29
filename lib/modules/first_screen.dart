import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_hagz/layout/bottom_nav_screen.dart';
import 'package:yalla_hagz/modules/after_7agz_rate_screen.dart';
import 'package:yalla_hagz/modules/register/phone_authentication_screen.dart';
import 'package:yalla_hagz/modules/random_number_screen.dart';
import 'package:yalla_hagz/modules/register/validate_email_address_screen.dart';
import 'package:yalla_hagz/modules/withdraw_money_screen.dart';
import 'package:yalla_hagz/shared/components.dart';
import 'package:yalla_hagz/shared/constants.dart';
import 'package:yalla_hagz/shared/cubit/cubit.dart';
import 'package:yalla_hagz/shared/cubit/states.dart';

class FirstScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.userModel!=null,
          builder: (context) {
            return ConditionalBuilder(
              condition: cubit.userModel["isPhoneVerified"],
              builder: (context) {
                return ConditionalBuilder(
                  condition: cubit.userModel["isEmailVerified"],
                  builder: (context) {
                    return ConditionalBuilder(
                      condition: cubit.userModel["mala3eb"].length>0,
                      builder: (context) {
                        return ConditionalBuilder(
                          condition: TimeOfDay.now().hour<(cubit.userModel["mala3eb"][cubit.mal3ab]["from"]-1)||(TimeOfDay.now().hour==(cubit.userModel["mala3eb"][cubit.mal3ab]["from"]-1)&&(TimeOfDay.now().minute)<50),
                          builder: (context) => BottomNavScreen(),
                          fallback: (context) =>ConditionalBuilder(
                            condition: ((TimeOfDay.now().hour==(cubit.userModel["mala3eb"][cubit.mal3ab]["from"]-1)&&(TimeOfDay.now().minute)>=50)||(TimeOfDay.now().hour>=(cubit.userModel["mala3eb"][cubit.mal3ab]["from"])&&TimeOfDay.now().hour<=(cubit.userModel["mala3eb"][cubit.mal3ab]["to"])))&&!cubit.userModel["mala3eb"][cubit.mal3ab]["isVerified"],
                            builder: (context) => RandomNumberScreen(),
                            fallback: (context)=>ConditionalBuilder(
                              condition: cubit.userModel["mala3eb"][cubit.mal3ab]["isDone"],
                              builder: (context)=>ConditionalBuilder(
                                  condition: !cubit.userModel["mala3eb"][cubit.mal3ab]["isVerified"],
                                  builder: (context) => ConditionalBuilder(
                                    condition: !cubit.userModel["mala3eb"][cubit.mal3ab]["hasWithdrawn"],
                                    builder: (context)=>WithdrawMoneyScreen(),
                                    fallback: (context)=>BottomNavScreen(),
                                  ),
                                  fallback: (context)=>ConditionalBuilder(
                                    condition: !cubit.userModel["mala3eb"][cubit.mal3ab]["hasRated"],
                                    builder: (context)=>After7agzRateScreen(),
                                    fallback: (context)=>BottomNavScreen(),
                                  ),
                                ),
                              fallback: (context)=>BottomNavScreen(),
                            )
                          ),
                        );
                      },
                      fallback: (context)=> BottomNavScreen()
                    );
                  },
                  fallback: (context) => ValidateEmailAddressScreen(),//PhoneAuthenticationScreen(),
                );
              },
            fallback: (context) => PhoneAuthenticationScreen(),
            );
          },
          fallback: (context)=>Center(
              child:CircularProgressIndicator(
            color:defaultColor,
          )),
        );
      },
    );
  }
}

