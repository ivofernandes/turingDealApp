cd ..
flutter pub run flutter_launcher_icons
echo "Generate icons completed"

# Generate splash screen
flutter pub run flutter_native_splash:create
echo "Generate splash screen completed"