## 0.5.1

* Explicitly set Flutter constraint to >=3.35.5 (Dart >=3.7.0) and verified plugin compatibility.
* No source code changes required besides updated environment constraints.

## 0.5.0

* Update Dart/Flutter SDK constraints to Flutter 3+ (Dart 3).
* Migrate Android build: remove jcenter, Kotlin 1.9, Java 17, AGP 8.4.
* Increase iOS deployment target to 12.0, Swift 5.9.
* Podspec cleanup (remove deprecated architectures).
* Preparatory compliance for 16 KB memory page size (build with modern toolchains; no plugin code changes required).
* (iOS) Align method channel name (fix potential mismatch) - pending implementation update.

## 0.4.0

* Fix duplicated listeners by removing .asBroadcastStream

## 0.3.0

* Fix Android crash by normalizing broadcast intent data

## 0.1.0

Android integration complete:
* send broadcasts on Android via Context.sendBroadcast

## 0.0.1

Initial Release:
* receive broadcasts on Android using BroadcastReceivers
