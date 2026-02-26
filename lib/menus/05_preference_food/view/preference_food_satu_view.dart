import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/recipemate_app_util.dart';
import '../view_model/preference_food_view_model.dart';

class PreferenceFoodSatuView extends StatelessWidget {
  PreferenceFoodSatuView({super.key});

  final vm = Get.put(PreferenceFoodViewModel());

  @override
  Widget build(BuildContext context) {

    RecipeMateAppUtil.init(context);

    return Scaffold(

      backgroundColor: Colors.white,

      body: SafeArea(

        child: Padding(

          padding: EdgeInsets.all(
            RecipeMateAppUtil.screenWidth * 0.06,
          ),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              _buildProgress(context, 1, 3),

              SizedBox(height: 30),

              Text(
                "Basic Information",
                style: TextStyle(
                  fontSize: DimensText.superHeaderText(context),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30),

              TextField(
                onChanged: vm.setName,
                decoration: const InputDecoration(
                  hintText: "Your name",
                ),
              ),

              SizedBox(height: 20),

              TextField(
                onChanged: vm.setAge,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Your age",
                ),
              ),

              const Spacer(),

              Obx(() =>
                  ElevatedButton(

                    onPressed: vm.isStep1Valid
                        ? () => Get.toNamed('/preference_food_dua')
                        : null,

                    child: const Text("Continue"),

                  ),
              ),

            ],

          ),

        ),

      ),

    );

  }

  Widget _buildProgress(BuildContext context, int step, int total) {
    double percent = step / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("STEP $step OF $total"),
        SizedBox(height: 6),
        LinearProgressIndicator(value: percent),
      ],
    );
  }
}