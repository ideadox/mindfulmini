import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayVisualsTopBar extends StatelessWidget {
  const PlayVisualsTopBar({
    super.key,
    required this.safeTop,
    required this.onBack,
    required this.favouriteAsset,
    this.onFavourite,
    this.isFavorited = false,
  });

  final double safeTop;
  final VoidCallback onBack;
  final String favouriteAsset;
  final VoidCallback? onFavourite;
  final bool isFavorited;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: safeTop + 8,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _WhiteCircleButton(
            onPressed: onBack,
            icon: Icons.keyboard_arrow_down_rounded,
          ),
          _FavoriteCircleButton(
            onPressed: onFavourite ?? () {},
            iconAsset: favouriteAsset,
            isFavorited: isFavorited,
          ),
        ],
      ),
    );
  }
}

class _WhiteCircleButton extends StatelessWidget {
  const _WhiteCircleButton({
    this.onPressed,
    this.icon,
    this.iconAsset,
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: icon != null
            ? Icon(icon, size: 24, color: Colors.black87)
            : SvgPicture.asset(
                iconAsset!,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.black87,
                  BlendMode.srcIn,
                ),
              ),
      ),
    );
  }
}

class _FavoriteCircleButton extends StatefulWidget {
  const _FavoriteCircleButton({
    required this.onPressed,
    required this.iconAsset,
    required this.isFavorited,
  });

  final VoidCallback onPressed;
  final String iconAsset;
  final bool isFavorited;

  @override
  State<_FavoriteCircleButton> createState() => _FavoriteCircleButtonState();
}

class _FavoriteCircleButtonState extends State<_FavoriteCircleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant _FavoriteCircleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorited != widget.isFavorited) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isFavorited
              ? Colors.red.shade50
              : Colors.white,
        ),
        child: IconButton(
          onPressed: widget.onPressed,
          padding: EdgeInsets.zero,
          icon: widget.isFavorited
              ? const Icon(Icons.favorite_rounded, size: 22, color: Colors.red)
              : SvgPicture.asset(
                  widget.iconAsset,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.black87,
                    BlendMode.srcIn,
                  ),
                ),
        ),
      ),
    );
  }
}
