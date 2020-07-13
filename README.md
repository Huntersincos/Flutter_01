# Flutter_01
安装flutter
git clone -b master https://github.com/flutter/flutter.git
 ./flutter/bin/flutter --version

export PUB_HOSTED_URL=https://pub.flutter-io.cn

export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

export PATH=`pwd`/flutter/bin:$PATH


pub get failed (66; Could not find a file named "pubspec.yaml" in
"xxxx/dependencies/
Nima-Flutter".)

解决办法
git submodule init
git submodule update
flutter run
