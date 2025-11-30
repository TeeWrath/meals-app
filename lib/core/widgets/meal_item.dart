import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:annapurna/models/meal.dart';
import 'package:annapurna/pages/meal/meal_detail.dart';
import 'package:annapurna/core/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal});

  final Meal meal;

  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => MealDetailScreen(
                  meal: meal,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20.r), //8
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          selectMeal(context, meal);
        },
        child: Stack(
          children: [
            Hero(
              tag: meal.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                fit: BoxFit.cover,
                height: 75.h, //200
                width: double.infinity,
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(
                      vertical: 2.h, horizontal: 20.w), // 6,44
                  child: Column(
                    children: [
                      Text(
                        meal.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow
                            .ellipsis, // Text will have '...' in the end if it is too long
                        style: TextStyle(
                            fontSize: 50.sp, //20
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 5.h, //12
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MealItemTrait(
                              // we can easily use a row inside a row here without the expanded widget as we have used positioned widget which specifies the total space for child widget
                              icon: Icons.schedule,
                              label: '${meal.duration} min'),
                          SizedBox(
                            width: 5.w, //12
                          ),
                          MealItemTrait(
                              // we can easily use a row inside a row here without the expanded widget as we have used positioned widget which specifies the total space for child widget
                              icon: Icons.work,
                              label: complexityText),
                          SizedBox(
                            width: 5.w,
                          ),
                          MealItemTrait(
                              // we can easily use a row inside a row here without the expanded widget as we have used positioned widget which specifies the total space for child widget
                              icon: Icons.attach_money,
                              label: affordabilityText),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
