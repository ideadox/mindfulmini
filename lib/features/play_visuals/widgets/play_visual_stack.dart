import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindfulminis/features/play_visuals/models/play_visual_asset.dart';
import 'package:video_player/video_player.dart';

/// Full-bleed play background: picks **still** vs **playing** asset, then image vs video.
///
/// When a session starts, [playing] replaces [still] if present; otherwise [still] stays visible.
/// Video motion is muted, loops while the session is active, and follows [audioPlaying].
class PlayVisualStack extends StatelessWidget {
  const PlayVisualStack({
    super.key,
    required this.still,
    required this.playing,
    required this.sessionStarted,
    required this.audioPlaying,
    this.heroTag = 'audio',
  });

  final PlayVisualAsset? still;
  final PlayVisualAsset? playing;
  final bool sessionStarted;
  final bool audioPlaying;
  final String heroTag;

  static PlayVisualAsset? _effective(
    PlayVisualAsset? still,
    PlayVisualAsset? playing,
    bool sessionStarted,
  ) {
    if (!sessionStarted) return still;
    return playing ?? still;
  }

  @override
  Widget build(BuildContext context) {
    final effective = _effective(still, playing, sessionStarted);
    if (effective == null) return const SizedBox.shrink();

    return Hero(
      tag: heroTag,
      child: PlayVisualSurface(
        asset: effective,
        sessionStarted: sessionStarted,
        audioPlaying: audioPlaying,
      ),
    );
  }
}

class PlayVisualSurface extends StatefulWidget {
  const PlayVisualSurface({
    super.key,
    required this.asset,
    required this.sessionStarted,
    required this.audioPlaying,
  });

  final PlayVisualAsset asset;
  final bool sessionStarted;
  final bool audioPlaying;

  @override
  State<PlayVisualSurface> createState() => _PlayVisualSurfaceState();
}

class _PlayVisualSurfaceState extends State<PlayVisualSurface> {
  VideoPlayerController? _controller;
  bool _videoInitFailed = false;

  @override
  void initState() {
    super.initState();
    if (widget.asset.isVideo) {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    final uri = Uri.parse(widget.asset.url);
    final c = VideoPlayerController.networkUrl(
      uri,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller = c;
    try {
      await c.initialize();
      await c.setLooping(widget.sessionStarted);
      await c.setVolume(0);
      await _syncVideoPlayback();
      if (mounted) setState(() {});
    } catch (_) {
      await c.dispose();
      _controller = null;
      if (mounted) {
        setState(() => _videoInitFailed = true);
      }
    }
  }

  Future<void> _disposeVideo() async {
    final c = _controller;
    _controller = null;
    await c?.dispose();
  }

  Future<void> _syncVideoPlayback() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;

    await c.setLooping(widget.sessionStarted);

    if (!widget.sessionStarted) {
      await c.pause();
      await c.seekTo(Duration.zero);
      return;
    }

    if (widget.audioPlaying) {
      await c.play();
    } else {
      await c.pause();
    }
  }

  @override
  void didUpdateWidget(covariant PlayVisualSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    final metaChanged = oldWidget.asset.url != widget.asset.url ||
        oldWidget.asset.mimeType != widget.asset.mimeType;

    if (metaChanged) {
      final oldV = oldWidget.asset.isVideo;
      final newV = widget.asset.isVideo;

      if (oldV) {
        _disposeVideo().then((_) {
          if (!mounted) return;
          setState(() => _videoInitFailed = false);
          if (newV) {
            _initVideo();
          } else {
            setState(() {});
          }
        });
      } else if (newV) {
        setState(() => _videoInitFailed = false);
        _initVideo();
      } else {
        setState(() {});
      }
      return;
    }

    if (widget.asset.isVideo &&
        _controller != null &&
        _controller!.value.isInitialized &&
        (oldWidget.sessionStarted != widget.sessionStarted ||
            oldWidget.audioPlaying != widget.audioPlaying)) {
      _syncVideoPlayback();
    }
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.asset.isVideo && !_videoInitFailed) {
      final c = _controller;
      if (c != null && c.value.isInitialized) {
        return _VideoCover(controller: c);
      }
      return _loadingPlaceholder();
    }

    if (widget.asset.isVideo && _videoInitFailed) {
      return _errorOrRasterFallback();
    }

    if (widget.asset.mimeType == 'image/svg+xml') {
      return _svgLayer();
    }

    if (widget.asset.mimeType.startsWith('audio/')) {
      return _audioPlaceholder();
    }

    return _rasterImage();
  }

  Widget _errorOrRasterFallback() {
    if (widget.asset.isRasterImage) {
      return _rasterImage();
    }
    return Container(
      color: Colors.grey.shade200,
      child: const Center(child: Icon(Icons.broken_image_outlined)),
    );
  }

  Widget _rasterImage() {
    return CachedNetworkImage(
      imageUrl: widget.asset.url,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: double.infinity,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: Duration.zero,
      useOldImageOnUrlChange: true,
      memCacheWidth: (MediaQuery.sizeOf(context).width *
              MediaQuery.devicePixelRatioOf(context))
          .toInt(),
      placeholder: (context, url) => const SizedBox.shrink(),
      errorWidget: (context, url, error) => const ColoredBox(
        color: Color(0xFF1A1A1A),
        child: Center(
          child: Icon(Icons.error_outline, color: Colors.white38),
        ),
      ),
    );
  }

  Widget _svgLayer() {
    return SvgPicture.network(
      widget.asset.url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholderBuilder: (_) => _loadingPlaceholder(),
    );
  }

  Widget _audioPlaceholder() {
    return ColoredBox(
      color: Colors.grey.shade300,
      child: Center(
        child: Icon(Icons.audiotrack, size: 48, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _loadingPlaceholder() {
    return const _VideoShimmer();
  }
}

class _VideoCover extends StatelessWidget {
  const _VideoCover({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final w = controller.value.size.width;
    final h = controller.value.size.height;
    if (w == 0 || h == 0) {
      return const _VideoShimmer();
    }
    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: w,
            height: h,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}

class _VideoShimmer extends StatefulWidget {
  const _VideoShimmer();

  @override
  State<_VideoShimmer> createState() => _VideoShimmerState();
}

class _VideoShimmerState extends State<_VideoShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final position = _controller.value;
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(position * 2 - 1.3, 0),
              end: Alignment(position * 2 - 0.7, 0),
              colors: [Colors.grey[200]!, Colors.grey[100]!, Colors.grey[200]!],
            ).createShader(bounds);
          },
          child: ColoredBox(
            color: Colors.grey[200]!,
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}
