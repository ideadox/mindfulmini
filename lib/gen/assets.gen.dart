/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/New Hero Regular.otf
  String get newHeroRegular => 'assets/fonts/New Hero Regular.otf';

  /// List of all assets
  List<String> get values => [newHeroRegular];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Apple Logo.svg
  String get appleLogo => 'assets/icons/Apple Logo.svg';

  /// File path: assets/icons/Google Logo.svg
  String get googleLogo => 'assets/icons/Google Logo.svg';

  /// File path: assets/icons/dob_icon.svg
  String get dobIcon => 'assets/icons/dob_icon.svg';

  /// File path: assets/icons/invisble_eye.svg
  String get invisbleEye => 'assets/icons/invisble_eye.svg';

  /// File path: assets/icons/mail.svg
  String get mail => 'assets/icons/mail.svg';

  /// File path: assets/icons/mic.svg
  String get mic => 'assets/icons/mic.svg';

  /// File path: assets/icons/pass_lock.svg
  String get passLock => 'assets/icons/pass_lock.svg';

  /// File path: assets/icons/user.svg
  String get user => 'assets/icons/user.svg';

  /// File path: assets/icons/verify_tick.svg
  String get verifyTick => 'assets/icons/verify_tick.svg';

  /// File path: assets/icons/visible_eye.svg
  String get visibleEye => 'assets/icons/visible_eye.svg';

  /// List of all assets
  List<String> get values => [
    appleLogo,
    googleLogo,
    dobIcon,
    invisbleEye,
    mail,
    mic,
    passLock,
    user,
    verifyTick,
    visibleEye,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Ellipse 70951.png
  AssetGenImage get ellipse70951 =>
      const AssetGenImage('assets/images/Ellipse 70951.png');

  /// File path: assets/images/Star.svg
  String get star => 'assets/images/Star.svg';

  /// File path: assets/images/Star1.svg
  String get star1 => 'assets/images/Star1.svg';

  /// File path: assets/images/Star2.svg
  String get star2 => 'assets/images/Star2.svg';

  /// File path: assets/images/allset.svg
  String get allset => 'assets/images/allset.svg';

  /// File path: assets/images/amazing_feel.svg
  String get amazingFeel => 'assets/images/amazing_feel.svg';

  /// File path: assets/images/angry_feel.svg
  String get angryFeel => 'assets/images/angry_feel.svg';

  /// File path: assets/images/confused.svg
  String get confused => 'assets/images/confused.svg';

  /// File path: assets/images/onboard1.svg
  String get onboard1 => 'assets/images/onboard1.svg';

  /// File path: assets/images/onboard2.svg
  String get onboard2 => 'assets/images/onboard2.svg';

  /// File path: assets/images/onboard3.svg
  String get onboard3 => 'assets/images/onboard3.svg';

  /// File path: assets/images/onboard_background.png
  AssetGenImage get onboardBackgroundPng =>
      const AssetGenImage('assets/images/onboard_background.png');

  /// File path: assets/images/onboard_background.svg
  String get onboardBackgroundSvg => 'assets/images/onboard_background.svg';

  /// File path: assets/images/phoneverficationdailog.svg
  String get phoneverficationdailog =>
      'assets/images/phoneverficationdailog.svg';

  /// File path: assets/images/sad_feel.svg
  String get sadFeel => 'assets/images/sad_feel.svg';

  /// File path: assets/images/sleep_feel.svg
  String get sleepFeel => 'assets/images/sleep_feel.svg';

  /// File path: assets/images/so-so_feel.svg
  String get soSoFeel => 'assets/images/so-so_feel.svg';

  /// File path: assets/images/splash_1.svg
  String get splash1 => 'assets/images/splash_1.svg';

  /// File path: assets/images/splash_img.svg
  String get splashImg => 'assets/images/splash_img.svg';

  /// File path: assets/images/verifiedlottie.json
  String get verifiedlottie => 'assets/images/verifiedlottie.json';

  /// List of all assets
  List<dynamic> get values => [
    ellipse70951,
    star,
    star1,
    star2,
    allset,
    amazingFeel,
    angryFeel,
    confused,
    onboard1,
    onboard2,
    onboard3,
    onboardBackgroundPng,
    onboardBackgroundSvg,
    phoneverficationdailog,
    sadFeel,
    sleepFeel,
    soSoFeel,
    splash1,
    splashImg,
    verifiedlottie,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
