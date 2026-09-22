import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:latlong2/latlong.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:recipemate/utils/color_var.dart';
import 'package:recipemate/utils/view_utils/connection_wrapper.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repository/api_repository.dart';
import '../../../utils/data_session_util_controller.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/find_nearby_restaurants_controller.dart';

class FindNearbyRestaurantView extends StatelessWidget {
  const FindNearbyRestaurantView({super.key});

  @override
  Widget build(BuildContext context) {
    final FindNearbyRestaurantsController controller = Get.put(
      FindNearbyRestaurantsController(
        apiRepository: Get.find<ApiRepository>(),
        session: Get.find<DataSessionUtilController>(),
      ),
    );
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    final primaryColor = HexColor(ColorVar.appColor);
    final darkBg = const Color(0xFF121212);

    return ConnectionWrapper(
      child: Material(
        color: darkBg,
        child: GlassScaffold(
          backgroundColor: darkBg,
          edgeToEdge: true,
          extendBody: true,
          edgeFade: false,
          background: Stack(
            children: [
              Container(color: darkBg),
              Positioned(
                top: -60,
                right: -60,
                child: buildBlurBlob(primaryColor.withValues(alpha: 0.15), 400),
              ),
              Positioned(
                bottom: -60,
                left: -80,
                child: buildBlurBlob(primaryColor.withValues(alpha: 0.1), 380),
              ),
            ],
          ),
          appBar: GlassAppBar(
            backgroundColor: Colors.transparent,
            title: customText(
              text: AppLocalizations.of(context)!.stFindNearbyRestaurants,
              fontSize: DimensText.headerMenusText(context),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'times_new_roman_bold',
            ),
          ),
          body: Obx(() {
            final pos = controller.currentPosition.value;
            final restaurants = controller.restaurants;
            
            return Stack(
              children: [
                if (pos != null)
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(pos.latitude, pos.longitude),
                      initialZoom: 15,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.recipemate.app',
                        tileBuilder: (context, tileWidget, tile) {
                          return ColorFiltered(
                            colorFilter: const ColorFilter.matrix(<double>[
                              -1,  0,  0, 0, 255,
                               0, -1,  0, 0, 255,
                               0,  0, -1, 0, 255,
                               0,  0,  0, 1, 0,
                            ]),
                            child: tileWidget,
                          );
                        },
                      ),
                      MarkerLayer(
                        markers: [
                          // User Location Marker
                          Marker(
                            point: LatLng(pos.latitude, pos.longitude),
                            width: 120,
                            height: 80,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: primaryColor, width: 2),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: customText(text: "Lokasi Anda", color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          // Restaurant Markers
                          ...restaurants.map((place) {
                            final isSelected = place.name == "Sambal Setan Lambe Turah";
                            return Marker(
                              point: LatLng(place.lat ?? 0, place.lon ?? 0),
                              width: 160,
                              height: 70,
                              alignment: Alignment.topCenter,
                              child: _buildMapPin(
                                label: place.name ?? "Restaurant",
                                rating: "4.9 ★",
                                isSelected: isSelected,
                                primaryColor: primaryColor,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  )
                else
                  const Center(child: CircularProgressIndicator()),

                DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.4,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      text: "Restoran Terdekat",
                                      fontSize: DimensText.headerMenusText(context),
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    customText(
                                      text: "${restaurants.length} Tempat Kuliner Terdekat",
                                      fontSize: DimensText.captionText(context),
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: restaurants.length,
                              itemBuilder: (context, index) {
                                return _buildRestaurantCard(controller, index, primaryColor, context);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMapPin({
    required String label,
    required String rating,
    required bool isSelected,
    required Color primaryColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? Colors.transparent : Colors.white24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) const Icon(Icons.restaurant, color: Colors.black, size: 14),
              if (isSelected) const SizedBox(width: 4),
              Flexible(
                child: customText(
                  text: label,
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 4),
              customText(
                text: rating,
                color: isSelected ? Colors.black87 : Colors.white70,
                fontSize: 10,
              ),
            ],
          ),
        ),
        if (isSelected)
          CustomPaint(
            size: const Size(10, 8),
            painter: TrianglePainter(color: primaryColor),
          ),
      ],
    );
  }

  Widget _buildRestaurantCard(FindNearbyRestaurantsController controller, int index, Color primaryColor, BuildContext context) {
    final place = controller.restaurants[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(text: place.name ?? "Restaurant", fontSize: DimensText.bodyText(context), fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                customText(text: place.category ?? "Healthy food integration...", fontSize: DimensText.microText(context), color: Theme.of(context).colorScheme.onSecondary, intMaxLine: 2),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GlassButton.custom(
            onTap: () {
              controller.openDirections(place.lat ?? 0, place.lon ?? 0, place.name ?? "");
            },
            enabled: true,
            shape: LiquidRoundedRectangle(borderRadius: 10),
            style: GlassButtonStyle.filled,
            useOwnLayer: true,
            settings: LiquidGlassSettings(
              glassColor: Theme.of(context).cardColor,
              thickness: 10,
              blur: 8,
              chromaticAberration: 0.4,
              lightIntensity: 1.2,
              refractiveIndex: 1.68,
              saturation: 1.1,
              ambientStrength: 1.1,
              ambientRim: 0.3,
              edgeAbsorption: 0.12,
            ),
            child: Row(
              children:[
                Icon(
                  Icons.near_me,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 18
                ),
                const SizedBox(width: 4),
                customText(
                  text: "Petunjuk Arah",
                  fontSize: DimensText.captionText(context),
                  color: Theme.of(context).colorScheme.onSurface
                ),
              ]
            ),
          )
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = ui.Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
