import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';

// Combined address state — single notifier avoids two separate rebuilds.
@immutable
class _AddressState {
  final String address;
  final bool isLoading;
  const _AddressState({this.address = '', this.isLoading = false});

  _AddressState copyWith({String? address, bool? isLoading}) => _AddressState(
    address: address ?? this.address,
    isLoading: isLoading ?? this.isLoading,
  );
}

class AddressMapPickerPage extends StatefulWidget {
  final String? initialAddress;

  const AddressMapPickerPage({super.key, this.initialAddress});

  @override
  State<AddressMapPickerPage> createState() => _AddressMapPickerPageState();
}

class _AddressMapPickerPageState extends State<AddressMapPickerPage> {
  static const _defaultCenter = LatLng(30.0444, 31.2357); // Cairo

  final _mapController = MapController();

  // One Dio instance; connection timeout set globally so failure is fast.
  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // ValueNotifiers: updating these NEVER rebuilds the map or pin.
  late final ValueNotifier<_AddressState> _addressNotifier;
  final _locationLoadingNotifier = ValueNotifier<bool>(false);

  LatLng _center = _defaultCenter;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _addressNotifier = ValueNotifier(const _AddressState(isLoading: true));
    // Render the first map frame before touching the network or GPS.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initLocation();
    });
  }

  /// Opens at the device's current GPS position; falls back to Cairo.
  Future<void> _initLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        await _fetchAddress(_defaultCenter);
        return;
      }

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        await _fetchAddress(_defaultCenter);
        return;
      }

      // getLastKnownPosition() is instant but can be stale or mocked (emulator
      // default, old VPN position, etc.). Reject mocked or >5-min-old fixes.
      final last = await Geolocator.getLastKnownPosition();
      if (last != null && !last.isMocked && mounted) {
        final age = DateTime.now().difference(last.timestamp);
        if (age.inMinutes <= 5) {
          final lastLatLng = LatLng(last.latitude, last.longitude);
          _center = lastLatLng;
          _mapController.move(lastLatLng, 15.0);
          _fetchAddress(lastLatLng); // fire-and-forget; fresh fix follows
        }
      }

      // Live fix — no timeLimit inside LocationSettings (throws on some Android
      // versions); wrap with .timeout() on the Future instead.
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      ).timeout(const Duration(seconds: 20));

      if (!mounted) return;

      // isMocked == true means the device is an emulator or the app is under
      // test with a fake provider — fall through to the Cairo fallback.
      if (pos.isMocked) {
        _center = _defaultCenter;
        _mapController.move(_defaultCenter, 14.0);
        await _fetchAddress(_defaultCenter);
        return;
      }

      final current = LatLng(pos.latitude, pos.longitude);
      _center = current;
      _mapController.move(current, 15.0);
      await _fetchAddress(current);
    } catch (_) {
      // getCurrentPosition failed — move the map to the fallback so it does
      // not stay frozen on whatever getLastKnownPosition put it.
      if (mounted) {
        _center = _defaultCenter;
        _mapController.move(_defaultCenter, 14.0);
        await _fetchAddress(_defaultCenter);
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _addressNotifier.dispose();
    _locationLoadingNotifier.dispose();
    try {
      _dio.close();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _fetchAddress(LatLng point) async {
    if (!mounted) return;
    // Keep stale address text visible — only flip the loading flag.
    _addressNotifier.value = _addressNotifier.value.copyWith(isLoading: true);
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': point.latitude,
          'lon': point.longitude,
          'format': 'json',
        },
        options: Options(
          headers: {
            'User-Agent': 'Pettix/1.0 (mohamedateefmmeekk@gmail.com)',
            'Accept-Language': 'en',
          },
        ),
      );
      if (mounted) {
        _addressNotifier.value = _AddressState(
          address:
              (response.data?['display_name'] as String?) ??
              AppText.unknownLocation,
          isLoading: false,
        );
      }
    } catch (_) {
      // Failure: stop spinner, keep whatever address was shown.
      if (mounted) {
        _addressNotifier.value = _addressNotifier.value.copyWith(
          isLoading: false,
        );
      }
    }
  }

  Future<void> _goToCurrentLocation() async {
    if (!mounted) return;
    _locationLoadingNotifier.value = true;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar(AppText.locationServicesDisabled);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar(AppText.locationPermissionDenied);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar(AppText.enableLocationSettings);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 20));

      if (!mounted) return;

      if (pos.isMocked) {
        _showSnackBar(AppText.realLocationUnavailable);
        return;
      }

      final current = LatLng(pos.latitude, pos.longitude);
      _center = current;
      _mapController.move(current, 16.0);
      await _fetchAddress(current);
    } on TimeoutException {
      _showSnackBar(AppText.locationRequestTimedOut);
    } catch (e) {
      _showSnackBar(AppText.locationError(e.runtimeType.toString()));
    } finally {
      if (mounted) _locationLoadingNotifier.value = false;
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  void _onMapMoved(MapCamera camera, bool hasGesture) {
    _center = camera.center;
    if (!hasGesture) return;
    // 800 ms debounce — fewer Nominatim calls while dragging.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      _fetchAddress(_center);
    });
  }

  void _zoomIn() {
    final zoom = _mapController.camera.zoom;
    _mapController.move(_center, (zoom + 1).clamp(3.0, 19.0));
  }

  void _zoomOut() {
    final zoom = _mapController.camera.zoom;
    _mapController.move(_center, (zoom - 1).clamp(3.0, 19.0));
  }

  void _confirm() {
    final state = _addressNotifier.value;
    if (state.isLoading || state.address.isEmpty) return;
    HapticFeedback.lightImpact();
    Navigator.of(context).pop(state.address);
  }

  @override
  Widget build(BuildContext context) {
    // Read padding once — build() is only called on first render because we
    // never call setState; all reactive updates go through ValueNotifiers.
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Stack(
        children: [
          // RepaintBoundary ensures address/location updates never repaint the
          // map tiles or the pin — the most expensive elements on screen.
          RepaintBoundary(
            child: _MapLayer(
              mapController: _mapController,
              onMapMoved: _onMapMoved,
            ),
          ),

          // Pin is const and lives entirely outside the update path.
          const _CenterPin(),

          // Back button is static after first build.
          _BackButton(topPadding: padding.top),

          // Zoom controls — static callbacks, no notifier needed.
          _ZoomControls(onZoomIn: _zoomIn, onZoomOut: _zoomOut),

          // Only the FAB icon swaps when location is loading.
          ValueListenableBuilder<bool>(
            valueListenable: _locationLoadingNotifier,
            builder:
                (_, isLoading, __) => _LocationFab(
                  isLoading: isLoading,
                  onTap: _goToCurrentLocation,
                ),
          ),

          // Only the bottom card rebuilds on address/loading changes.
          ValueListenableBuilder<_AddressState>(
            valueListenable: _addressNotifier,
            builder:
                (_, state, __) => _BottomCard(
                  address: state.address,
                  isLoadingAddress: state.isLoading,
                  bottomPadding: padding.bottom,
                  onConfirm: _confirm,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Map layer ────────────────────────────────────────────────────────────────

class _MapLayer extends StatelessWidget {
  final MapController mapController;
  final void Function(MapCamera, bool) onMapMoved;

  const _MapLayer({required this.mapController, required this.onMapMoved});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: const LatLng(30.0444, 31.2357),
        initialZoom: 14.0,
        onPositionChanged: onMapMoved,
        // Clamp zoom so we never request tiles that don't exist.
        minZoom: 3,
        maxZoom: 19,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.pettix.up',
          // Pre-load one ring of tiles beyond the visible viewport so
          // panning reveals content immediately instead of a grey flash.
          panBuffer: 1,
          // maxNativeZoom stops the client scaling up blurry low-res tiles
          // when the user zooms past what OSM provides.
          maxNativeZoom: 19,
        ),
      ],
    );
  }
}

// ── Center pin ───────────────────────────────────────────────────────────────

class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) {
    // Column height ≈ 40w + 10h + 3h. Translate up by half so the tip
    // (bottom of the shadow dot) aligns with the camera center point.
    return IgnorePointer(
      child: Align(
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(0, -26.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.current.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.current.primary.withAlpha(100),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 22.w,
                ),
              ),
              Container(
                width: 2.w,
                height: 10.h,
                color: AppColors.current.primary,
              ),
              Container(
                width: 6.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(50),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Back button ──────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final double topPadding;
  const _BackButton({required this.topPadding});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPadding + 12.h,
      left: 16.w,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 8),
            ],
          ),
          child: AppTopBarBackButton(
            onPressed: () => Navigator.of(context).pop(),
            size: 18.w,
          ),
        ),
      ),
    );
  }
}

// ── Current location FAB ─────────────────────────────────────────────────────

class _LocationFab extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _LocationFab({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 208.h,
      right: 16.w,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 8),
            ],
          ),
          child:
              isLoading
                  ? Padding(
                    padding: EdgeInsets.all(12.w),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.current.primary,
                    ),
                  )
                  : Icon(
                    Icons.my_location_rounded,
                    size: 22.w,
                    color: AppColors.current.primary,
                  ),
        ),
      ),
    );
  }
}

// ── Zoom controls ────────────────────────────────────────────────────────────

class _ZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const _ZoomControls({required this.onZoomIn, required this.onZoomOut});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16.w,
      bottom: 272.h,
      child: Container(
        width: 44.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ZoomButton(icon: Icons.add_rounded, onTap: onZoomIn),
            Divider(height: 1, thickness: 1, color: Colors.grey.withAlpha(40)),
            _ZoomButton(icon: Icons.remove_rounded, onTap: onZoomOut),
          ],
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 44.w,
        height: 44.w,
        child: Icon(icon, size: 20.w, color: AppColors.current.text),
      ),
    );
  }
}

// ── Bottom confirmation card ─────────────────────────────────────────────────

class _BottomCard extends StatelessWidget {
  final String address;
  final bool isLoadingAddress;
  final double bottomPadding;
  final VoidCallback onConfirm;

  const _BottomCard({
    required this.address,
    required this.isLoadingAddress,
    required this.bottomPadding,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, bottomPadding + 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppText.selectedLocationUpper,
              style: AppTextStyles.smallDescription.copyWith(
                color: AppColors.current.midGray,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            SizedBox(height: 10.h),
            _AddressRow(address: address, isLoading: isLoadingAddress),
            SizedBox(height: 16.h),
            _ConfirmButton(
              isDisabled: isLoadingAddress || address.isEmpty,
              onTap: onConfirm,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Address row ───────────────────────────────────────────────────────────────

class _AddressRow extends StatelessWidget {
  final String address;
  final bool isLoading;

  const _AddressRow({required this.address, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Icon(
            Icons.location_on_outlined,
            color: AppColors.current.red,
            size: 18.w,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child:
              isLoading
                  ? _AddressShimmer()
                  : address.isEmpty
                  ? Text(
                    AppText.moveMapSelectLocation,
                    style: AppTextStyles.description.copyWith(
                      color: AppColors.current.midGray,
                      fontSize: 13.sp,
                    ),
                  )
                  : Text(
                    address,
                    style: AppTextStyles.description.copyWith(
                      color: AppColors.current.text,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
        ),
      ],
    );
  }
}

class _AddressShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmer(
          width: double.infinity,
          height: 14.h,
          borderRadius: BorderRadius.circular(7.r),
        ),
        SizedBox(height: 5.h),
        AppShimmer(
          width: 180.w,
          height: 14.h,
          borderRadius: BorderRadius.circular(7.r),
        ),
      ],
    );
  }
}

// ── Confirm button ────────────────────────────────────────────────────────────

class _ConfirmButton extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onTap;

  const _ConfirmButton({required this.isDisabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52.h,
        decoration: BoxDecoration(
          color:
              isDisabled
                  ? AppColors.current.primary.withAlpha(140)
                  : AppColors.current.primary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow:
              isDisabled
                  ? []
                  : [
                    BoxShadow(
                      color: AppColors.current.primary.withAlpha(80),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
        ),
        child: Center(
          child: Text(
            AppText.confirmLocation,
            style: AppTextStyles.bold.copyWith(
              color: Colors.white,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
