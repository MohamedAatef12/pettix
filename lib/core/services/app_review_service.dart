import 'package:flutter/widgets.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pettix/data/caching/shared_prefs_helper.dart';

class AppReviewService {
  static const _hasPromptedAfterTenPostsKey = 'review_prompt_after_ten_posts';
  static const _hasPromptedAfterAdoptionKey = 'review_prompt_after_adoption';

  AppReviewService._();

  static Future<void> requestAfterTenPosts(BuildContext context) async {
    await _requestOnce(context, _hasPromptedAfterTenPostsKey);
  }

  static Future<void> requestAfterFirstAdoption(BuildContext context) async {
    await _requestOnce(context, _hasPromptedAfterAdoptionKey);
  }

  static Future<void> requestFromSettings() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
      return;
    }

    await inAppReview.openStoreListing();
  }

  static Future<void> _requestOnce(BuildContext context, String key) async {
    if (SharedPrefsHelper.getBool(key) == true) return;

    await SharedPrefsHelper.setBool(key, true);
    if (!context.mounted) return;

    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }
}
