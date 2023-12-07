import 'package:flutter/material.dart';
import 'package:news_app/core/utils/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String image;

  const CategoryCard(this.name, this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Container(
            key: const Key('category-card'),
            width: 90,
            height: 90,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 1,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  key: const Key('category-card-image'),
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 9.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
