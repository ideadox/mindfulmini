## Suppress missing Play Core classes (Flutter deferred components — not used but referenced)
-dontwarn com.google.android.play.core.**

## just_audio — keep ExoPlayer classes loaded via reflection
-keep class com.google.android.exoplayer2.** { *; }
-keep class androidx.media3.** { *; }
-dontwarn com.google.android.exoplayer2.**
-dontwarn androidx.media3.**

-keep class com.ryanheise.just_audio.** { *; }
-dontwarn com.ryanheise.just_audio.**

## video_player
-keep class io.flutter.plugins.videoplayer.** { *; }
