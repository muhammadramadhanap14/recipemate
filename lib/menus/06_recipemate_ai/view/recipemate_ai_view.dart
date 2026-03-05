import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipemate/utils/constant_var.dart';
import '../../../utils/recipemate_app_util.dart';
import '../../../utils/color_var.dart';
import '../../../utils/dimens_text.dart';
import '../../../utils/view_utils/primary_global_view.dart';
import '../view_model/recipemate_ai_view_model.dart';

class RecipemateAiView extends StatelessWidget {
  const RecipemateAiView({super.key});

  @override
  Widget build(BuildContext context) {
    final RecipemateAiViewModel viewModel = Get.put(RecipemateAiViewModel());
    RecipeMateAppUtil.init(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await RecipeMateAppUtil.lockToPortrait();
    });

    return Scaffold(
      backgroundColor: HexColor(ColorVar.bgAppColor),
      appBar: AppBar(
        backgroundColor: HexColor(ColorVar.bgAppColor),
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              "assets/images/cover_logo_recipemate.png",
              width: RecipeMateAppUtil.screenWidth * 0.08,
            ),
            SizedBox(width: RecipeMateAppUtil.screenWidth * 0.03),
            customText(
              text: ConstantVar.recipeMateAi,
              fontSize: DimensText.headerMenusText(context),
              fontWeight: FontWeight.bold,
              color: HexColor(ColorVar.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none, 
              color: HexColor(ColorVar.black),
              size: RecipeMateAppUtil.screenWidth * 0.065,
            ),
          ),
          SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: RecipeMateAppUtil.screenWidth * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
              _buildSearchBar(context, viewModel),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
              _buildSuggestions(context, viewModel),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      customText(
                        text: "Best Match",
                        fontSize: DimensText.subHeaderText(context),
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: RecipeMateAppUtil.screenWidth * 0.02, 
                          vertical: RecipeMateAppUtil.screenHeight * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor(ColorVar.appColor).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.05),
                        ),
                        child: customText(
                          text: "AI DRIVEN",
                          fontSize: DimensText.microText(context),
                          fontWeight: FontWeight.bold,
                          color: HexColor(ColorVar.appColor),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: customText(
                      text: "View All",
                      fontSize: DimensText.captionText(context),
                      color: HexColor(ColorVar.appColor),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.bestMatches.length,
                separatorBuilder: (_, _) => SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
                itemBuilder: (context, index) {
                  final recipe = viewModel.bestMatches[index];
                  return _buildRecipeCard(context, recipe);
                },
              ),
              SizedBox(height: RecipeMateAppUtil.screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, RecipemateAiViewModel vm) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: RecipeMateAppUtil.screenWidth * 0.03, 
        vertical: RecipeMateAppUtil.screenHeight * 0.005,
      ),
      decoration: BoxDecoration(
        color: HexColor(ColorVar.white),
        borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.08),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search, 
            color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.4),
            size: RecipeMateAppUtil.screenWidth * 0.06,
          ),
          SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
          Expanded(
            child: Obx(() => Wrap(
              spacing: RecipeMateAppUtil.screenWidth * 0.015,
              runSpacing: RecipeMateAppUtil.screenHeight * 0.005,
              children: [
                ...vm.selectedIngredients.map((tag) => Chip(
                  label: customText(text: tag, fontSize: DimensText.captionText(context)),
                  onDeleted: () => vm.removeIngredient(tag),
                  backgroundColor: HexColor(ColorVar.bgGray8).withValues(alpha: 0.1),
                  deleteIcon: Icon(Icons.close, size: RecipeMateAppUtil.screenWidth * 0.035),
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.only(left: RecipeMateAppUtil.screenWidth * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.05)
                  ),
                  side: BorderSide.none,
                )),
                SizedBox(
                  width: RecipeMateAppUtil.screenWidth * 0.15,
                  child: TextField(
                    onChanged: (val) => vm.searchText.value = val,
                    decoration: const InputDecoration(
                      hintText: "Ba",
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    style: TextStyle(fontSize: DimensText.bodySmallText(context)),
                  ),
                ),
              ],
            )),
          ),
          Icon(
            Icons.cancel, 
            color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.4),
            size: RecipeMateAppUtil.screenWidth * 0.05,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, RecipemateAiViewModel vm) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor(ColorVar.white),
        borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.05),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: vm.suggestions.map((item) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: HexColor(ColorVar.bgGray8).withValues(alpha: 0.1),
              radius: RecipeMateAppUtil.screenWidth * 0.05,
              child: Icon(
                item['icon'], 
                color: HexColor(ColorVar.appColor), 
                size: RecipeMateAppUtil.screenWidth * 0.05,
              ),
            ),
            title: customText(
              text: item['name'], 
              fontSize: DimensText.bodySmallText(context),
              fontWeight: FontWeight.w500,
            ),
            trailing: Icon(
              Icons.add_circle, 
              color: HexColor(ColorVar.appColor),
              size: RecipeMateAppUtil.screenWidth * 0.06,
            ),
            onTap: () {},
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    final double cardBorderRadius = RecipeMateAppUtil.screenWidth * 0.06;
    
    return Container(
      decoration: BoxDecoration(
        color: HexColor(ColorVar.white),
        borderRadius: BorderRadius.circular(cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(cardBorderRadius)),
                child: Image.network(
                  recipe['image'],
                  height: RecipeMateAppUtil.screenHeight * 0.25,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: RecipeMateAppUtil.screenHeight * 0.015,
                left: RecipeMateAppUtil.screenWidth * 0.03,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: RecipeMateAppUtil.screenWidth * 0.025, 
                    vertical: RecipeMateAppUtil.screenHeight * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: HexColor(ColorVar.white),
                    borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.05),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bolt, 
                        color: HexColor(ColorVar.appColor), 
                        size: RecipeMateAppUtil.screenWidth * 0.04,
                      ),
                      SizedBox(width: RecipeMateAppUtil.screenWidth * 0.01),
                      customText(
                        text: "${recipe['match']}% Match",
                        fontSize: DimensText.captionText(context),
                        fontWeight: FontWeight.bold,
                        color: HexColor(ColorVar.appColor),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: RecipeMateAppUtil.screenHeight * 0.015,
                right: RecipeMateAppUtil.screenWidth * 0.03,
                child: CircleAvatar(
                  backgroundColor: HexColor(ColorVar.white),
                  radius: RecipeMateAppUtil.screenWidth * 0.05,
                  child: Icon(
                    Icons.favorite_border, 
                    color: Colors.grey,
                    size: RecipeMateAppUtil.screenWidth * 0.055,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(RecipeMateAppUtil.screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: recipe['title'],
                  fontSize: DimensText.bodyText(context),
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.015),
                Row(
                  children: [
                    _buildInfoBadge(context, recipe['kcal']),
                    SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
                    _buildInfoBadge(context, recipe['protein']),
                    SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
                    _buildInfoBadge(context, recipe['time']),
                  ],
                ),
                SizedBox(height: RecipeMateAppUtil.screenHeight * 0.02),
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined, 
                      size: RecipeMateAppUtil.screenWidth * 0.04, 
                      color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.6),
                    ),
                    SizedBox(width: RecipeMateAppUtil.screenWidth * 0.02),
                    Expanded(
                      child: customText(
                        text: recipe['status'],
                        fontSize: DimensText.captionText(context),
                        color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.6),
                        intMaxLine: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: RecipeMateAppUtil.screenWidth * 0.02, 
        vertical: RecipeMateAppUtil.screenHeight * 0.005,
      ),
      decoration: BoxDecoration(
        color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(RecipeMateAppUtil.screenWidth * 0.02),
      ),
      child: customText(
        text: text, 
        fontSize: DimensText.captionText(context),
        color: HexColor(ColorVar.bgGray8).withValues(alpha: 0.6),
      ),
    );
  }
}