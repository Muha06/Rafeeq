# 1. Protect Audio Service components
-keep class com.ryanheise.audioservice.** { *; }
-keep class androidx.media3.session.** { *; }
-keep class androidx.media.** { *; }
-keep class android.support.v4.media.** { *; }

# 2. Protect Flutter Local Notifications (since it's in your manifest)
-keep class com.dexterous.flutterlocalnotifications.** { *; }
