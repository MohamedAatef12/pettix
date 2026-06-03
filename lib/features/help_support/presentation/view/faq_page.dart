import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _buildCategories()
            .map(
              (cat) => _FaqCategory(
                title: cat.title,
                icon: cat.icon,
                color: cat.color,
                items:
                    cat.items
                        .where(
                          (item) =>
                              _query.isEmpty ||
                              item.question.toLowerCase().contains(
                                _query.toLowerCase(),
                              ) ||
                              item.answer.toLowerCase().contains(
                                _query.toLowerCase(),
                              ),
                        )
                        .toList(),
              ),
            )
            .where((cat) => cat.items.isNotEmpty)
            .toList();

    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child:
                filtered.isEmpty
                    ? _EmptySearch()
                    : ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
                      children:
                          filtered
                              .map((cat) => _CategorySection(category: cat))
                              .toList(),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 12.h),
              child: Row(
                children: [
                  AppTopBarBackButton(onPressed: () => context.pop()),
                  Expanded(
                    child: Text(
                      AppText.frequentlyAskedQuestions,
                      style: AppTextStyles.appbar.copyWith(
                        color: AppColors.current.text,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(230),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.current.text,
                  ),
                  decoration: InputDecoration(
                    hintText: AppText.searchQuestions,
                    hintStyle: TextStyle(
                      color: AppColors.current.midGray,
                      fontSize: 13.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.current.midGray,
                      size: 20.w,
                    ),
                    suffixIcon:
                        _query.isNotEmpty
                            ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              child: Icon(
                                Icons.close_rounded,
                                color: AppColors.current.midGray,
                                size: 18.w,
                              ),
                            )
                            : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_FaqCategory> _buildCategories() => [
    _FaqCategory(
      title: AppText.general,
      icon: Icons.info_outline_rounded,
      color: AppColors.current.primary,
      items: [
        _FaqItem(
          question: AppText.faqWhatIsPettix,
          answer: AppText.faqWhatIsPettixAnswer,
        ),
        _FaqItem(
          question: AppText.faqAvailableAndroidIos,
          answer: AppText.faqAvailableAndroidIosAnswer,
        ),
        _FaqItem(
          question: AppText.faqFreeToUse,
          answer: AppText.faqFreeToUseAnswer,
        ),
      ],
    ),
    _FaqCategory(
      title: AppText.accountProfile,
      icon: Icons.person_outline_rounded,
      color: const Color(0xFF7A6FD8),
      items: [
        _FaqItem(
          question: AppText.faqCreateAccount,
          answer: AppText.faqCreateAccountAnswer,
        ),
        _FaqItem(
          question: AppText.faqResetPassword,
          answer: AppText.faqResetPasswordAnswer,
        ),
        _FaqItem(
          question: AppText.faqUpdateProfile,
          answer: AppText.faqUpdateProfileAnswer,
        ),
        _FaqItem(
          question: AppText.faqDeleteAccount,
          answer: AppText.faqDeleteAccountAnswer,
        ),
      ],
    ),
    _FaqCategory(
      title: AppText.adoption,
      icon: Icons.pets_rounded,
      color: const Color(0xFF10B981),
      items: [
        _FaqItem(
          question: AppText.faqAdoptPet,
          answer: AppText.faqAdoptPetAnswer,
        ),
        _FaqItem(
          question: AppText.faqTrackAdoption,
          answer: AppText.faqTrackAdoptionAnswer,
        ),
        _FaqItem(
          question: AppText.faqListPetForAdoption,
          answer: AppText.faqListPetForAdoptionAnswer,
        ),
      ],
    ),
    _FaqCategory(
      title: AppText.storeOrders,
      icon: Icons.storefront_rounded,
      color: const Color(0xFFF97316),
      items: [
        _FaqItem(
          question: AppText.faqPlaceOrder,
          answer: AppText.faqPlaceOrderAnswer,
        ),
        _FaqItem(
          question: AppText.faqPaymentMethods,
          answer: AppText.faqPaymentMethodsAnswer,
        ),
        _FaqItem(
          question: AppText.faqReturnProduct,
          answer: AppText.faqReturnProductAnswer,
        ),
      ],
    ),
  ];
}

class _FaqCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<_FaqItem> items;

  const _FaqCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}

class _CategorySection extends StatelessWidget {
  final _FaqCategory category;
  const _CategorySection({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: category.color.withAlpha(26),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(category.icon, color: category.color, size: 16.w),
            ),
            SizedBox(width: 10.w),
            Text(
              category.title.toUpperCase(),
              style: AppTextStyles.smallDescription.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.current.midGray,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.current.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Column(
              children: List.generate(category.items.length, (i) {
                final item = category.items[i];
                final isLast = i == category.items.length - 1;
                return Column(
                  children: [
                    _FaqTile(item: item, accentColor: category.color),
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: AppColors.current.lightGray,
                        indent: 16.w,
                        endIndent: 16.w,
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

class _FaqTile extends StatefulWidget {
  final _FaqItem item;
  final Color accentColor;
  const _FaqTile({required this.item, required this.accentColor});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => _expanded = !_expanded);
        _expanded ? _controller.forward() : _controller.reverse();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.question,
                    style: AppTextStyles.description.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.current.text,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                RotationTransition(
                  turns: _rotation,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: widget.accentColor,
                    size: 20.w,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: EdgeInsets.only(top: 10.h, right: 24.w),
                child: Text(
                  widget.item.answer,
                  style: AppTextStyles.smallDescription.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.current.midGray,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56.r,
            color: AppColors.current.lightGray,
          ),
          SizedBox(height: 12.h),
          Text(
            AppText.noResultsFound,
            style: AppTextStyles.bold.copyWith(
              fontSize: 16.sp,
              color: AppColors.current.midGray,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppText.tryDifferentSearchTerm,
            style: AppTextStyles.smallDescription.copyWith(
              fontSize: 13.sp,
              color: AppColors.current.midGray,
            ),
          ),
        ],
      ),
    );
  }
}
