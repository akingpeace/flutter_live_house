#!/bin/bash

echo "🚀 开始打包 Flutter APK..."

# 清理
echo "🧹 清理项目..."
flutter clean

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

# 清理Gradle
echo "🗑️  清理Gradle缓存..."
cd android && ./gradlew clean && cd ..

# 打包
echo "🔨 开始打包Release APK..."
flutter build apk --release --split-per-abi

# 检查结果
if [ $? -eq 0 ]; then
    echo "✅ 打包成功！"
    echo "📁 APK位置：build/app/outputs/flutter-apk/"
    ls -la build/app/outputs/flutter-apk/
else
    echo "❌ 打包失败，请检查错误信息"
    exit 1
fi