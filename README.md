# 📱 Finance Management App

Ứng dụng Flutter quản lý chi tiêu cá nhân, sử dụng Firebase để xác thực và lưu trữ dữ liệu.

---

## 🚀 Công nghệ sử dụng

- Flutter
- Firebase (Auth, Firestore)
- Firebase CLI + flutterfire_cli
- Dart

---

## ✅ Yêu cầu cài đặt

Trước khi bắt đầu, đảm bảo bạn đã cài:

- Flutter SDK (>= 3.16.0)
- Android Studio hoặc VSCode với plugin Flutter
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)
- Android NDK v27 (`sdkmanager --install "ndk;27.0.12077973"`)

> 📌 **Windows**: Thêm thư mục `C:\Users\<USER>\AppData\Local\Pub\Cache\bin` vào biến môi trường `PATH` để dùng lệnh `flutterfire`.

---

## ⚙️ Thiết lập project lần đầu

1. **Clone project**
```bash
git clone https://github.com/your-username/finance_management.git
cd finance_management
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Tạo Firebase project (chỉ làm 1 lần đầu)**
```bash
flutterfire configure
```
- Chọn tài khoản Google
- Tạo project Firebase (nếu chưa có)
- Chọn platform: Android
- File `firebase_options.dart` sẽ được tự động tạo ở `lib/firebase_options.dart`

4. **(Tuỳ chọn) Cập nhật file cấu hình Firebase**
Nếu có sẵn `firebase_options.dart`, chỉ cần chắc chắn bạn **gọi `initFirebase()` trong `main.dart`** như sau:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(const MyApp());
}
```

---

## 📱 Chạy ứng dụng

```bash
flutter run
```

> 🐞 Nếu lỗi NDK hoặc minSdkVersion, mở `android/app/build.gradle.kts` và chắc chắn có:

```kotlin
android {
    ndkVersion = "27.0.12077973"

    defaultConfig {
        minSdk = 23
    }
}
```


---

## 📦 Build APK để chia sẻ

```bash
flutter build apk --release
```

APK sẽ nằm ở `build/app/outputs/flutter-apk/app-release.apk`

---

## 📸 Thay đổi icon app

Cài package:

```bash
flutter pub add flutter_launcher_icons
```

Cấu hình trong `pubspec.yaml`:

```yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
```

Chạy:

```bash
flutter pub run flutter_launcher_icons
```

---

## ❓ Gặp lỗi?

- Dọn sạch:
```bash
flutter clean
flutter pub get
```
- Kiểm tra kết nối Firebase
- Kiểm tra Android NDK và minSdk

---

