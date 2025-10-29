import 'package:flutter/material.dart';
import 'package:pettix/core/utils/custom_button.dart';

import '../../../../core/themes/app_colors.dart';
import '../widgets/application/application_body.dart';

class ApplicationScreens extends StatefulWidget {
  const ApplicationScreens({super.key});

  @override
  State<ApplicationScreens> createState() => _ApplicationScreens();
}

class _ApplicationScreens extends State<ApplicationScreens> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final int pageCount = 4;

  void _nextPage() {
    if (_currentPage < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  List<String> stepTitles = [
    "Set up your information",
    "Living Situation",
    "Pet Experience",
    "Understanding & Agreements",
  ];

  bool agreed = false;
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.white,
      appBar: AppBar(
        title: const Text('Adopt Buddy'),
        centerTitle: true,
        backgroundColor: AppColors.current.white,
        surfaceTintColor: AppColors.current.white,
        shadowColor: AppColors.current.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            "Application for Buddy",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Color(0xff3F425A),
            ),
          ),
          Text(
            "Step ${_currentPage + 1} of 4 : ${stepTitles[_currentPage]}",
            style: const TextStyle(color: Color(0xff4A4C68)),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0.0,
                  end: (_currentPage + 1) / pageCount,
                ),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xff4A4C68),
                    ),
                    minHeight: 8,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                const Step1PersonalInfo(),
                const Step2LivingSituation(),
                const Step3PetExperience(),
                Step4Agreements(
                  agreed: agreed,
                  termsAccepted: termsAccepted,
                  onAgreedChanged: (v) => setState(() => agreed = v),
                  onTermsChanged: (v) => setState(() => termsAccepted = v),
                ),
              ],
            ),
          ),
          _buildBottomButtons(),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    bool isLastPage = _currentPage == 3;
    bool isFormValid = agreed && termsAccepted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              _currentPage == 0 ? null : _previousPage();
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xff5379B2), width: 1),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Color(0xff5379B2),
                    size: 26,
                  ),
                  SizedBox(width: 5),
                  Center(
                    child: Text(
                      'Back',
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
          const SizedBox(width: 12),
          CustomFilledButton(
            onPressed:
                isLastPage
                    ? (isFormValid ? _submitApplication() : validateForm)
                    : _nextPage,

            trailing: const Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.white,
              size: 26,
            ),
            hasTrailing: true,
            text: "Next",
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.current.white,
            ),
            backgroundColor:
                isLastPage
                    ? (isFormValid ? const Color(0xff5379B2) : Colors.grey)
                    : const Color(0xff5379B2),
          ),
        ],
      ),
    );
  }

  _submitApplication() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Application Submitted ✅")));
  }

  validateForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please agree to the terms to proceed.")),
    );
  }
}
