import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_hagz/shared/components.dart';
import 'package:yalla_hagz/shared/constants.dart';
import 'package:yalla_hagz/shared/cubit/cubit.dart';
import 'package:yalla_hagz/shared/cubit/states.dart';

class Mala3ebScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int currentIndex=0;
    var cities = AppCubit.get(context).cities;
    if(cities.isNotEmpty){
      AppCubit.get(context).getSchoolsData(cityId:cities[0]);
      AppCubit.get(context).currentCity = cities[0];
    }
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state)  {
          if(state is AppGetCitiesSuccessState){
            AppCubit.get(context).getSchoolsData(cityId:cities[0]);
            AppCubit.get(context).currentCity = cities[0];
          }
        },
        builder: (context, state)  {
          var schools = AppCubit.get(context).schools;
          return Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConditionalBuilder(
                  condition: cities.isNotEmpty,
                  builder: (context)
                  {
                    return Column(
                        children: [
                          Container(
                            height: 50,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  color: (currentIndex == index) ? defaultColor : Colors.grey[300],
                                  child: TextButton(
                                    onPressed: () {
                                      currentIndex = index;
                                      AppCubit.get(context).currentCity = cities[currentIndex];
                                      AppCubit.get(context).getSchoolsData(cityId: cities[currentIndex]);
                                    },
                                    child: Text(
                                      cities[index],
                                      style: TextStyle(
                                        color: (currentIndex == index) ? Colors.white : defaultColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                width: 5,
                              ),
                              itemCount: cities.length,
                            ),
                          ),
                          ConditionalBuilder(
                        condition: state is! AppGetSchoolsLoadingState,
                        builder: (context) {
                          return Column(
                            children: [
                              const SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 8),
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    "${cities[currentIndex]} Schools",
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              ConditionalBuilder(
                                  condition: state is! AppGetSchoolsLoadingState,
                                  builder: (context) => ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) => buildSchool(context, schools[index]),
                                      separatorBuilder: (context, index) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: myDivider(),
                                      ),
                                      itemCount: schools.length
                                  ),
                                  fallback: (BuildContext context) => Center(
                                          child: CircularProgressIndicator(
                                        color: defaultColor,
                                      ))),
                            ],
                          );
                        },
                        fallback: (context) => Center(
                            child: CircularProgressIndicator(
                          color: defaultColor,
                        )),
                      ),
                        ]
                    );
                  },
                  fallback: (context) => Center(child: CircularProgressIndicator(
                    color: defaultColor,
                  )),
                ),
              ),
            ),
          );
        }
    );
  }
}
