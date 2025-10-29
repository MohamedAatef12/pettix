import 'package:flutter/material.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/category_list.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/category_list_body.dart';

import 'adoption_text_field.dart';

class AdoptionBody extends StatelessWidget {
  const AdoptionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),

        Text(
          'Find Your Fur-ever Friend',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3F425A),
          ),
        ),
        SizedBox(height: 10),
        AdoptionTextField(),
        SizedBox(height: 20),
        CategoryList(),
        Expanded(child: CategoryListBody()),
      ],
    );
  }
}
