import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

enum AppIconToken {
  add,
  adopt,
  adoptActive,
  article,
  arrowDown,
  arrowUp,
  back,
  balance,
  birthDate,
  blocked,
  bug,
  calendar,
  cancel,
  category,
  chat,
  chatActive,
  check,
  checkCircle,
  chevronBack,
  chevronDown,
  chevronForward,
  city,
  close,
  colorPalette,
  contact,
  delete,
  edit,
  email,
  emergency,
  error,
  expandMore,
  factCheck,
  family,
  filter,
  gender,
  grid,
  handshake,
  help,
  home,
  homeActive,
  house,
  imageMissing,
  info,
  key,
  language,
  legal,
  like,
  likeActive,
  list,
  location,
  lock,
  map,
  medical,
  minus,
  comment,
  more,
  notes,
  notification,
  offline,
  partner,
  payment,
  pending,
  person,
  pet,
  petActive,
  phone,
  qr,
  refresh,
  review,
  save,
  saveActive,
  schedule,
  search,
  searchOff,
  send,
  settings,
  shield,
  star,
  starActive,
  store,
  success,
  support,
  tune,
  update,
  verified,
  visibility,
  visibilityOff,
  warning,
  report,
  reportSpam,
  reportHarassment,
  reportHate,
  reportHidden,
  reportWarning,
  reportCopyright,
  reportFalse,
  reportOther,
  photo,
  camera,
  public,
}

class AppIcon extends StatelessWidget {
  final AppIconToken? token;
  final IconData? iconData;
  final double? size;
  final Color? color;
  final bool filled;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final List<Shadow>? shadows;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final bool? applyTextScaling;
  final BlendMode? blendMode;

  const AppIcon({
    super.key,
    required this.token,
    this.size,
    this.color,
    this.filled = false,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
    this.applyTextScaling,
    this.blendMode,
  }) : iconData = null;

  const AppIcon.raw(
    this.iconData, {
    super.key,
    this.size,
    this.color,
    this.filled = false,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
    this.applyTextScaling,
    this.blendMode,
  }) : token = null;

  @override
  Widget build(BuildContext context) {
    final resolvedToken = token ?? _tokenFromIconData(iconData);

    return Icon(
      resolvedToken == null
          ? iconData
          : _iconData(resolvedToken, filled: filled),
      size: size ?? 20.w,
      color: color ?? AppColors.current.text,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      shadows: shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      blendMode: blendMode,
    );
  }

  static IconData _iconData(AppIconToken token, {bool filled = false}) {
    switch (token) {
      case AppIconToken.add:
        return Iconsax.add;
      case AppIconToken.adopt:
        return filled ? Iconsax.pet5 : Iconsax.pet;
      case AppIconToken.adoptActive:
        return Iconsax.pet5;
      case AppIconToken.article:
        return filled ? Iconsax.document_text5 : Iconsax.document_text;
      case AppIconToken.arrowDown:
        return Iconsax.arrow_down;
      case AppIconToken.arrowUp:
        return Iconsax.arrow_up;
      case AppIconToken.back:
        return Iconsax.arrow_left_2;
      case AppIconToken.balance:
        return Iconsax.judge;
      case AppIconToken.birthDate:
        return filled ? Iconsax.cake5 : Iconsax.cake;
      case AppIconToken.blocked:
        return Iconsax.shield_cross;
      case AppIconToken.bug:
        return Iconsax.warning_2;
      case AppIconToken.calendar:
        return filled ? Iconsax.calendar5 : Iconsax.calendar;
      case AppIconToken.cancel:
        return Iconsax.close_circle;
      case AppIconToken.category:
        return filled ? Iconsax.category5 : Iconsax.category;
      case AppIconToken.chat:
        return filled ? Iconsax.message_text5 : Iconsax.message_text;
      case AppIconToken.chatActive:
        return Iconsax.messages5;
      case AppIconToken.check:
        return Iconsax.tick_square;
      case AppIconToken.checkCircle:
        return Iconsax.tick_circle;
      case AppIconToken.chevronBack:
        return Iconsax.arrow_left_2;
      case AppIconToken.chevronDown:
        return Iconsax.arrow_down_1;
      case AppIconToken.chevronForward:
        return Iconsax.arrow_right_3;
      case AppIconToken.city:
        return filled ? Iconsax.buildings5 : Iconsax.buildings;
      case AppIconToken.close:
        return Iconsax.close_circle;
      case AppIconToken.colorPalette:
        return filled ? Iconsax.color_swatch5 : Iconsax.color_swatch;
      case AppIconToken.contact:
        return filled ? Iconsax.sms5 : Iconsax.sms;
      case AppIconToken.delete:
        return filled ? Iconsax.trash5 : Iconsax.trash;
      case AppIconToken.edit:
        return filled ? Iconsax.edit5 : Iconsax.edit;
      case AppIconToken.email:
        return filled ? Iconsax.sms5 : Iconsax.sms;
      case AppIconToken.emergency:
        return Iconsax.warning_2;
      case AppIconToken.error:
        return Iconsax.warning_2;
      case AppIconToken.expandMore:
        return Iconsax.arrow_down_1;
      case AppIconToken.factCheck:
        return filled ? Iconsax.clipboard_tick5 : Iconsax.clipboard_tick;
      case AppIconToken.family:
        return filled ? Iconsax.people5 : Iconsax.people;
      case AppIconToken.filter:
        return filled ? Iconsax.document_filter5 : Iconsax.document_filter;
      case AppIconToken.gender:
        return filled ? Iconsax.user_tag5 : Iconsax.user_tag;
      case AppIconToken.grid:
        return filled ? Iconsax.category5 : Iconsax.category;
      case AppIconToken.handshake:
        return filled ? Iconsax.people5 : Iconsax.people;
      case AppIconToken.help:
        return filled ? Iconsax.message_question5 : Iconsax.message_question;
      case AppIconToken.home:
        return filled ? Iconsax.home5 : Iconsax.home;
      case AppIconToken.homeActive:
        return Iconsax.home5;
      case AppIconToken.house:
        return filled ? Iconsax.house5 : Iconsax.house;
      case AppIconToken.imageMissing:
        return Iconsax.gallery_slash;
      case AppIconToken.info:
        return Iconsax.info_circle;
      case AppIconToken.key:
        return filled ? Iconsax.key5 : Iconsax.key;
      case AppIconToken.language:
        return filled ? Iconsax.language_square5 : Iconsax.language_square;
      case AppIconToken.legal:
        return filled ? Iconsax.document_text5 : Iconsax.document_text;
      case AppIconToken.like:
        return filled ? Iconsax.heart5 : Iconsax.heart;
      case AppIconToken.likeActive:
        return Iconsax.heart5;
      case AppIconToken.list:
        return filled ? Iconsax.task_square5 : Iconsax.task_square;
      case AppIconToken.location:
        return filled ? Iconsax.location5 : Iconsax.location;
      case AppIconToken.lock:
        return filled ? Iconsax.lock5 : Iconsax.lock;
      case AppIconToken.map:
        return filled ? Iconsax.map5 : Iconsax.map;
      case AppIconToken.medical:
        return filled ? Iconsax.hospital5 : Iconsax.hospital;
      case AppIconToken.minus:
        return Iconsax.minus_cirlce;
      case AppIconToken.comment:
        return Iconsax.message_text;
      case AppIconToken.more:
        return Iconsax.more;
      case AppIconToken.notes:
        return filled ? Iconsax.note_text5 : Iconsax.note_text;
      case AppIconToken.notification:
        return filled ? Iconsax.notification_bing5 : Iconsax.notification_bing;
      case AppIconToken.offline:
        return Iconsax.cloud_cross;
      case AppIconToken.partner:
        return filled ? Iconsax.heart5 : Iconsax.heart;
      case AppIconToken.payment:
        return filled ? Iconsax.wallet5 : Iconsax.wallet;
      case AppIconToken.pending:
        return filled ? Iconsax.timer5 : Iconsax.timer;
      case AppIconToken.person:
        return filled ? Iconsax.user5 : Iconsax.user;
      case AppIconToken.pet:
        return filled ? Iconsax.pet5 : Iconsax.pet;
      case AppIconToken.petActive:
        return Iconsax.pet5;
      case AppIconToken.phone:
        return filled ? Iconsax.call5 : Iconsax.call;
      case AppIconToken.qr:
        return filled ? Iconsax.scan_barcode5 : Iconsax.scan_barcode;
      case AppIconToken.refresh:
        return Iconsax.refresh;
      case AppIconToken.review:
        return filled ? Iconsax.message_edit5 : Iconsax.message_edit;
      case AppIconToken.save:
        return filled ? Iconsax.archive_15 : Iconsax.archive_1;
      case AppIconToken.saveActive:
        return Iconsax.archive_15;
      case AppIconToken.schedule:
        return filled ? Iconsax.clock5 : Iconsax.clock;
      case AppIconToken.search:
        return Iconsax.search_normal_1;
      case AppIconToken.searchOff:
        return Iconsax.search_status;
      case AppIconToken.send:
        return filled ? Iconsax.send_25 : Iconsax.send_2;
      case AppIconToken.settings:
        return filled ? Iconsax.setting_25 : Iconsax.setting_2;
      case AppIconToken.shield:
        return filled ? Iconsax.shield_tick5 : Iconsax.shield_tick;
      case AppIconToken.star:
        return filled ? Iconsax.star5 : Iconsax.star;
      case AppIconToken.starActive:
        return Iconsax.star5;
      case AppIconToken.store:
        return filled ? Iconsax.shop5 : Iconsax.shop;
      case AppIconToken.success:
        return Iconsax.tick_circle;
      case AppIconToken.support:
        return filled ? Iconsax.message_question5 : Iconsax.message_question;
      case AppIconToken.tune:
        return filled ? Iconsax.setting_45 : Iconsax.setting_4;
      case AppIconToken.update:
        return Iconsax.refresh_circle;
      case AppIconToken.verified:
        return Iconsax.verify;
      case AppIconToken.visibility:
        return Iconsax.eye;
      case AppIconToken.visibilityOff:
        return Iconsax.eye_slash;
      case AppIconToken.warning:
        return Iconsax.warning_2;
      case AppIconToken.report:
        return Iconsax.flag;
      case AppIconToken.reportSpam:
        return Iconsax.sms;
      case AppIconToken.reportHarassment:
        return Iconsax.shield_cross;
      case AppIconToken.reportHate:
        return Iconsax.emoji_sad;
      case AppIconToken.reportHidden:
        return Iconsax.eye_slash;
      case AppIconToken.reportWarning:
        return Iconsax.warning_2;
      case AppIconToken.reportCopyright:
        return Iconsax.document_text;
      case AppIconToken.reportFalse:
        return Iconsax.info_circle;
      case AppIconToken.reportOther:
        return Iconsax.more_circle;
      case AppIconToken.photo:
        return Iconsax.gallery_add;
      case AppIconToken.camera:
        return Iconsax.camera;
      case AppIconToken.public:
        return Iconsax.global;
    }
  }

  static AppIconToken? _tokenFromIconData(IconData? icon) {
    if (icon == null) return null;

    if (icon == Icons.add_rounded || icon == Iconsax.add) {
      return AppIconToken.add;
    }
    if (icon == Icons.arrow_back_ios_new_rounded ||
        icon == Iconsax.arrow_left_2) {
      return AppIconToken.chevronBack;
    }
    if (icon == Icons.arrow_forward_ios ||
        icon == Icons.arrow_forward_ios_rounded ||
        icon == Icons.arrow_circle_right_outlined ||
        icon == Icons.chevron_right_rounded ||
        icon == Iconsax.arrow_right_3) {
      return AppIconToken.chevronForward;
    }
    if (icon == Icons.keyboard_arrow_down_rounded ||
        icon == Icons.expand_more_rounded) {
      return AppIconToken.chevronDown;
    }
    if (icon == Icons.arrow_upward_rounded) return AppIconToken.arrowUp;
    if (icon == Icons.arrow_downward_rounded) return AppIconToken.arrowDown;
    if (icon == Icons.article_rounded ||
        icon == Icons.feed_rounded ||
        icon == Icons.dynamic_feed_rounded) {
      return AppIconToken.article;
    }
    if (icon == Icons.assignment_ind_rounded ||
        icon == Icons.fact_check_outlined) {
      return AppIconToken.factCheck;
    }
    if (icon == Icons.assignment_return_outlined) {
      return AppIconToken.legal;
    }
    if (icon == Icons.balance_rounded || icon == Icons.gavel_rounded) {
      return AppIconToken.balance;
    }
    if (icon == Icons.block_flipped) return AppIconToken.blocked;
    if (icon == Icons.bug_report_outlined || icon == Icons.bug_report_rounded) {
      return AppIconToken.bug;
    }
    if (icon == Icons.cake_outlined || icon == Icons.cake_rounded) {
      return AppIconToken.birthDate;
    }
    if (icon == Icons.calendar_today_rounded) return AppIconToken.calendar;
    if (icon == Icons.cancel_outlined || icon == Icons.cancel_rounded) {
      return AppIconToken.cancel;
    }
    if (icon == Icons.category_outlined) return AppIconToken.category;
    if (icon == Icons.chat_bubble_rounded ||
        icon == Icons.chat_bubble_outline_rounded) {
      return AppIconToken.chat;
    }
    if (icon == Iconsax.messages) return AppIconToken.chatActive;
    if (icon == Icons.check_rounded) return AppIconToken.check;
    if (icon == Icons.check_circle_rounded ||
        icon == Icons.check_circle_outline ||
        icon == Icons.check_circle_outline_rounded) {
      return AppIconToken.checkCircle;
    }
    if (icon == Icons.close ||
        icon == Icons.close_rounded ||
        icon == Iconsax.close_circle) {
      return AppIconToken.close;
    }
    if (icon == Icons.color_lens_outlined || icon == Icons.palette_outlined) {
      return AppIconToken.colorPalette;
    }
    if (icon == Icons.contact_mail_outlined) return AppIconToken.contact;
    if (icon == Icons.delete_rounded || icon == Icons.delete_forever_rounded) {
      return AppIconToken.delete;
    }
    if (icon == Icons.edit_rounded ||
        icon == Icons.edit_note_rounded ||
        icon == Icons.edit_outlined) {
      return AppIconToken.edit;
    }
    if (icon == Icons.email_outlined) return AppIconToken.email;
    if (icon == Icons.emergency_rounded) return AppIconToken.emergency;
    if (icon == Icons.error_outline ||
        icon == Icons.error_outline_rounded ||
        icon == Icons.report_gmailerrorred_rounded) {
      return AppIconToken.error;
    }
    if (icon == Icons.family_restroom_rounded) return AppIconToken.family;
    if (icon == Icons.filter_alt_rounded) return AppIconToken.filter;
    if (icon == Icons.grid_view_rounded) return AppIconToken.grid;
    if (icon == Icons.handshake_outlined) return AppIconToken.handshake;
    if (icon == Icons.help_outline_rounded ||
        icon == Icons.headset_mic_rounded ||
        icon == Icons.quiz_rounded ||
        icon == Icons.support_agent_rounded) {
      return AppIconToken.help;
    }
    if (icon == Icons.home_outlined ||
        icon == Icons.home_work_outlined ||
        icon == Iconsax.home) {
      return AppIconToken.home;
    }
    if (icon == Iconsax.home4) return AppIconToken.homeActive;
    if (icon == Icons.house_outlined) return AppIconToken.house;
    if (icon == Icons.image_not_supported_outlined) {
      return AppIconToken.imageMissing;
    }
    if (icon == Icons.info_outline_rounded ||
        icon == Icons.info_outline ||
        icon == Iconsax.info_circle) {
      return AppIconToken.info;
    }
    if (icon == Icons.vpn_key_outlined) return AppIconToken.key;
    if (icon == Icons.language_rounded) return AppIconToken.language;
    if (icon == Icons.favorite_rounded ||
        icon == Icons.favorite_border_rounded ||
        icon == Iconsax.heart ||
        icon == Iconsax.heart5) {
      return AppIconToken.like;
    }
    if (icon == Icons.location_on_outlined ||
        icon == Icons.location_on_rounded) {
      return AppIconToken.location;
    }
    if (icon == Icons.lock_outline_rounded) return AppIconToken.lock;
    if (icon == Icons.map_outlined || icon == Icons.my_location_rounded) {
      return AppIconToken.map;
    }
    if (icon == Icons.local_hospital_outlined ||
        icon == Icons.health_and_safety_outlined ||
        icon == Icons.medical_services_rounded ||
        icon == Icons.vaccines_rounded) {
      return AppIconToken.medical;
    }
    if (icon == Icons.remove_rounded) return AppIconToken.minus;
    if (icon == Icons.more_horiz_rounded) return AppIconToken.more;
    if (icon == Icons.notes_rounded) return AppIconToken.notes;
    if (icon == Icons.notifications_none_rounded ||
        icon == Icons.notifications_rounded) {
      return AppIconToken.notification;
    }
    if (icon == Icons.payment_rounded ||
        icon == Icons.credit_card_rounded ||
        icon == Icons.shopping_bag_rounded) {
      return AppIconToken.payment;
    }
    if (icon == Icons.hourglass_empty_rounded) return AppIconToken.pending;
    if (icon == Icons.person_outline_rounded) return AppIconToken.person;
    if (icon == Icons.pets_rounded ||
        icon == Icons.pets_outlined ||
        icon == Icons.auto_awesome_rounded ||
        icon == Icons.flutter_dash_rounded ||
        icon == Iconsax.pet) {
      return AppIconToken.pet;
    }
    if (icon == Iconsax.pet4) return AppIconToken.petActive;
    if (icon == Icons.phone_outlined || icon == Icons.phone_android_rounded) {
      return AppIconToken.phone;
    }
    if (icon == Icons.qr_code_2_rounded) return AppIconToken.qr;
    if (icon == Icons.refresh_rounded) return AppIconToken.refresh;
    if (icon == Icons.rate_review_rounded) return AppIconToken.review;
    if (icon == Icons.search_rounded || icon == Iconsax.search_normal_1) {
      return AppIconToken.search;
    }
    if (icon == Icons.search_off_rounded) return AppIconToken.searchOff;
    if (icon == Iconsax.send_2) return AppIconToken.send;
    if (icon == Icons.tune_rounded) return AppIconToken.tune;
    if (icon == Icons.flag_outlined) return AppIconToken.report;
    if (icon == Icons.shield_outlined) return AppIconToken.shield;
    if (icon == Icons.star_border_rounded ||
        icon == Icons.star_outline_rounded) {
      return AppIconToken.star;
    }
    if (icon == Icons.star_rounded) return AppIconToken.starActive;
    if (icon == Icons.storefront_rounded) return AppIconToken.store;
    if (icon == Icons.schedule_rounded || icon == Icons.access_time_rounded) {
      return AppIconToken.schedule;
    }
    if (icon == Icons.speed_rounded) return AppIconToken.tune;
    if (icon == Icons.trending_up_rounded) return AppIconToken.success;
    if (icon == Icons.update_rounded) return AppIconToken.update;
    if (icon == Icons.verified ||
        icon == Icons.verified_rounded ||
        icon == Icons.done_all) {
      return AppIconToken.verified;
    }
    if (icon == Icons.visibility) return AppIconToken.visibility;
    if (icon == Icons.visibility_off || icon == Icons.visibility_off_rounded) {
      return AppIconToken.visibilityOff;
    }
    if (icon == Icons.warning_amber_rounded) return AppIconToken.warning;
    if (icon == Icons.wc_rounded ||
        icon == Icons.male_rounded ||
        icon == Icons.female_rounded) {
      return AppIconToken.gender;
    }
    if (icon == Icons.location_city_outlined ||
        icon == Icons.apartment_rounded ||
        icon == Icons.villa_outlined ||
        icon == Icons.bed_outlined) {
      return AppIconToken.city;
    }
    if (icon == Icons.circle) return null;
    return null;
  }
}

class AppIconButton extends StatelessWidget {
  final AppIconToken token;
  final VoidCallback? onTap;
  final double? size;
  final double? iconSize;
  final Color? color;
  final Color? backgroundColor;
  final String? tooltip;
  final bool filled;

  const AppIconButton({
    super.key,
    required this.token,
    this.onTap,
    this.size,
    this.iconSize,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? 36.w;
    final child = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(dimension / 2),
      child: Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.current.lightBlue,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AppIcon(
            token: token,
            size: iconSize ?? 18.w,
            color: color ?? AppColors.current.text,
            filled: filled,
          ),
        ),
      ),
    );

    if (tooltip == null) return child;
    return Tooltip(message: tooltip!, child: child);
  }
}

class AppIconPill extends StatelessWidget {
  final AppIconToken token;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const AppIconPill({
    super.key,
    required this.token,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(token: token, size: 20.w, color: color),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.description.copyWith(
                color: AppColors.current.text,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineActionButton extends StatelessWidget {
  final AppIconToken token;
  final AppIconToken? activeToken;
  final bool active;
  final int? count;
  final VoidCallback onTap;
  final Color? activeColor;

  const TimelineActionButton({
    super.key,
    required this.token,
    this.activeToken,
    this.active = false,
    this.count,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = activeColor ?? AppColors.current.primary;
    final iconColor =
        active ? selectedColor : AppColors.current.text.withValues(alpha: 0.72);
    final backgroundColor =
        active
            ? selectedColor.withValues(alpha: 0.1)
            : AppColors.current.lightBlue.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: 8.w,
          end: count == null ? 8.w : 10.w,
          top: 6.h,
          bottom: 6.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color:
                active
                    ? selectedColor.withValues(alpha: 0.16)
                    : AppColors.current.lightGray.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              token: active ? activeToken ?? token : token,
              size: 20.w,
              color: iconColor,
              filled: active,
            ),
            if (count != null) ...[
              SizedBox(width: 5.w),
              Text(
                count.toString(),
                style: AppTextStyles.description.copyWith(
                  color: AppColors.current.text.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
