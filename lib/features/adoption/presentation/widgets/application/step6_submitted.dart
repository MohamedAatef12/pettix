import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/core/utils/custom_button.dart';

class StepSubmitted extends StatelessWidget {
  final String petName;
  final String applicantName;
  final VoidCallback onViewApplication;
  final VoidCallback onBrowseMore;

  const StepSubmitted({
    super.key,
    this.petName = "Buddy",
    this.applicantName = "User",
    required this.onViewApplication,
    required this.onBrowseMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Submitted your application",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xff3F425A),
            ),
          ),
          const SizedBox(height: 40),
          // Placeholder for the envelope icon/image
          SvgPicture.asset(
            'assets/icons/success_envelope.svg', // Ensure this asset exists or use Icon
            height: 150.h,
            // fallback if svg not found
            placeholderBuilder:
                (context) => Icon(
                  Icons.mark_email_read,
                  size: 100.h,
                  color: Color(0xff5379B2),
                ),
          ),
          const SizedBox(height: 40),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff4A4C68),
                height: 1.5,
              ),
              children: [
                const TextSpan(text: "Thank you , "),
                TextSpan(
                  text: "$applicantName . \n",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "your application for $petName has submitted\nsuccessfully",
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "What Next",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff3F425A),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Color(0xff5379B2),
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "The Owner will Review your application and may contact via chat",
                  style: TextStyle(color: Color(0xff4A4C68), fontSize: 14),
                ),
              ),
            ],
          ),
          const Spacer(),
          CustomFilledButton(
            onPressed: onViewApplication,
            text: "View Your Application",
            backgroundColor: const Color(0xff5379B2),
          ),
          const SizedBox(height: 12),
          CustomFilledButton(
            onPressed: onBrowseMore,
            text: "Browse More Pets",
            backgroundColor: Colors.white,
            textColor: const Color(0xff5379B2),
            // Border or outline style if CustomFilledButton supports it?
            // Assuming default implementation allows some customization or we wrap it.
            // If CustomFilledButton doesn't support border, we might need a different widget or careful styling.
            // For now assume it's fine.
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
