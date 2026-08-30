#!/bin/bash
# APK 编译环境一键安装脚本 (JDK 17 + Gradle 8.7 + Android SDK)
# 幂等，可重复执行；重复执行会跳过已完成的步骤
# 用法: bash install-android-env.sh

set -e

export DEBIAN_FRONTEND=noninteractive
ANDROID_HOME=/opt/android-sdk
GRADLE_HOME=/opt/gradle-8.7
DL="https://dl.google.com/android/repository"
WGET="wget -q --tries=5 --timeout=60"

echo "==> [1/8] 安装 JDK17 / unzip / wget"
apt-get update -y
apt-get install -y openjdk-17-jdk-headless unzip wget

echo "==> [2/8] 安装 Gradle 8.7"
if [ ! -x "$GRADLE_HOME/bin/gradle" ]; then
  cd /tmp
  rm -f gradle-8.7-bin.zip
  $WGET https://services.gradle.org/distributions/gradle-8.7-bin.zip
  unzip -q gradle-8.7-bin.zip -d /opt
fi

echo "==> [3/8] 安装 Android cmdline-tools"
mkdir -p "$ANDROID_HOME/cmdline-tools"
if [ ! -x "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
  cd /tmp
  rm -f commandlinetools-linux-11076708_latest.zip
  $WGET $DL/commandlinetools-linux-11076708_latest.zip
  unzip -q commandlinetools-linux-11076708_latest.zip -d "$ANDROID_HOME/cmdline-tools"
  mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
fi

echo "==> [4/8] 接受 SDK 许可"
yes | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --licenses >/dev/null 2>&1 || true

echo "==> [5/8] 安装 platform-tools (adb)"
if [ ! -x "$ANDROID_HOME/platform-tools/adb" ]; then
  cd /tmp
  $WGET $DL/platform-tools-latest-linux.zip
  unzip -q platform-tools-latest-linux.zip -d "$ANDROID_HOME"
fi

echo "==> [6/8] 安装 build-tools 34.0.0"
if [ ! -x "$ANDROID_HOME/build-tools/34.0.0/aapt2" ]; then
  cd /tmp
  rm -f build-tools_r34-linux.zip
  $WGET $DL/build-tools_r34-linux.zip
  rm -rf /tmp/bt "$ANDROID_HOME/build-tools/34.0.0"
  mkdir -p /tmp/bt "$ANDROID_HOME/build-tools/34.0.0"
  unzip -q build-tools_r34-linux.zip -d /tmp/bt
  cp -a /tmp/bt/android-14/. "$ANDROID_HOME/build-tools/34.0.0/"
fi

echo "==> [7/8] 安装 platform android-34"
if [ ! -f "$ANDROID_HOME/platforms/android-34/android.jar" ]; then
  cd /tmp
  rm -f platform-34-ext12_r01.zip
  $WGET $DL/platform-34-ext12_r01.zip
  unzip -q platform-34-ext12_r01.zip -d "$ANDROID_HOME"
  mkdir -p "$ANDROID_HOME/platforms"
  rm -rf "$ANDROID_HOME/platforms/android-34"
  mv "$ANDROID_HOME/android-34-ext12" "$ANDROID_HOME/platforms/android-34"
fi

echo "==> [8/8] 写入环境变量"
cat > /etc/profile.d/android.sh <<EOF
export ANDROID_HOME=$ANDROID_HOME
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$GRADLE_HOME/bin:\$PATH
EOF
chmod +x /etc/profile.d/android.sh

echo "==> 安装完成，验证结果:"
java -version 2>&1 | head -1
"$GRADLE_HOME/bin/gradle" --version 2>/dev/null | grep -E 'Gradle|JVM:'
"$ANDROID_HOME/platform-tools/adb" --version 2>/dev/null | head -1
test -x "$ANDROID_HOME/build-tools/34.0.0/aapt2" && echo "build-tools 34.0.0: OK"
test -f "$ANDROID_HOME/platforms/android-34/android.jar" && echo "platform android-34: OK"
echo "完成。新终端自动生效环境变量，当前终端可执行: source /etc/profile.d/android.sh"
