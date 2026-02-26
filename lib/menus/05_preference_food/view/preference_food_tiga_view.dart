import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/preference_food_view_model.dart';

class PreferenceFoodTigaView extends StatelessWidget {

  PreferenceFoodTigaView({super.key});

  final vm = Get.find<PreferenceFoodViewModel>();

  final items = [
    "Indonesian",
    "Western",
    "Japanese",
    "Dessert",
    "Healthy",
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Column(

        children: [

          LinearProgressIndicator(value: 1),

          Expanded(

            child: Obx(() =>
                GridView.builder(

                  itemCount: items.length,

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),

                  itemBuilder: (_, i) {

                    final item = items[i];

                    final selected =
                    vm.isFavoriteSelected(item);

                    return GestureDetector(

                      onTap: () =>
                          vm.toggleFavorite(item),

                      child: Card(

                        color:
                        selected
                            ? Colors.orange
                            : Colors.white,

                        child: Center(
                          child: Text(item),
                        ),

                      ),

                    );

                  },

                ),
            ),

          ),

          Obx(() =>
              ElevatedButton(

                onPressed:
                vm.isStep3Valid
                    ? vm.finishOnboarding
                    : null,

                child: const Text("Finish"),

              ),
          ),

        ],

      ),

    );

  }

}