import 'package:flutter/material.dart';

class PetDescription extends StatelessWidget {
  const PetDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffAEBED6), width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Description',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Luna is a playful and affectionate cat who loves to cuddle and explore. She is great with kids and other pets, making her a perfect addition to any family.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              // Handle "Read more" tap
            },
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xff5379B2), width: 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.import_contacts_sharp, color: Color(0xff5379B2)),
                  SizedBox(width: 10),
                  Center(
                    child: Text(
                      'Message Owner',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff5379B2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
