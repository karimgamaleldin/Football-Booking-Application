import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_hagz/modules/login/cubit/cubit.dart';
import 'package:yalla_hagz/modules/login/cubit/states.dart';
import 'package:yalla_hagz/shared/components.dart';
import 'package:yalla_hagz/shared/cubit/cubit.dart';

class ChangePasswordScreen extends StatelessWidget {
  var oldPassController = TextEditingController();
  var newPassController = TextEditingController();
  var newPassConfirmationController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = AppCubit.get(context).userModel;
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  'Change your Password',
                  style: TextStyle(
                      color: Color(0xff388E3C),
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultFormField(
                        controller: oldPassController,
                        validate: (value) {
                          if (value!.isEmpty)
                            return ('Oldpassword shouldn\'t be empty');
                        },
                        isObscure: LoginCubit.get(context).isPassword,
                        text: 'Old Password',
                        prefix: Icons.lock_outline,
                        suffix: LoginCubit.get(context).suffix,
                        suffixOnPressed: () {
                          LoginCubit.get(context).changePasswordVisibility();
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        controller: newPassController,
                        validate: (value) {
                          if (value!.isEmpty)
                            return ('Password shouldn\'t be empty');
                        },
                        isObscure: LoginCubit.get(context).isPassword,
                        text: 'New Password',
                        prefix: Icons.lock_outline,
                        suffix: LoginCubit.get(context).suffix,
                        suffixOnPressed: () {
                          LoginCubit.get(context).changePasswordVisibility();
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        controller: newPassConfirmationController,
                        validate: (value) {
                          if (value!.isEmpty)
                            return ('Password shouldn\'t be empty');
                        },
                        isObscure: LoginCubit.get(context).isPassword,
                        text: 'Confirm new Password',
                        prefix: Icons.lock_outline,
                        suffix: LoginCubit.get(context).suffix,
                        suffixOnPressed: () {
                          LoginCubit.get(context).changePasswordVisibility();
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: defaultTextButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              // FirebaseAuth.instance.currentUser!
                              //     .reauthenticateWithCredential(
                              //         EmailAuthProvider.credential(
                              //             email: userModel["email"],
                              //             password:
                              //                 oldPassController.toString()))
                              //     .then((value) {
                                  cubit.changePassword(
                                      newPassword:
                                          newPassController.toString());
                                  Navigator.pop(context);
                            //   }).catchError((onError){
                            //     showToast(
                            //         text:
                            //         'An error has occurreddddd, Please try again}',
                            //         state: ToastStates.WARNING);
                            //   });
                             }
                          },
                          text: 'Change Password'),
                    ),
                  ],
                ),
              ));
        });
  }
}
