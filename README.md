# PetCare App

A Flutter application designed for pet care. It communicates with the [PetCare API](https://petcareapi.onrender.com/swagger/index.html).

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (channel stable, 3.41+)
- [Android command-line tools](https://developer.android.com/studio#command-tools) for Android development
- [Visual Studio 2022](https://visualstudio.microsoft.com/) with "Desktop development with C++" workload (Windows only)
- Xcode for iOS/macOS development (macOS only)

## Setup

Install dependencies:

```bash
flutter pub get
```

## Running the app

### Windows desktop

Enable Windows desktop support if not already enabled:

```bash
flutter config --enable-windows-desktop
```

Run the app (PowerShell or Command Prompt):

```powershell
flutter run -d windows
```

> Requires Visual Studio 2022 with the "Desktop development with C++" workload installed.

### macOS desktop (fastest, no emulator needed)

Enable macOS desktop support if not already enabled:

```bash
flutter config --enable-macos-desktop
```

Run the app:

```bash
flutter run -d macos
```

> On Apple Silicon (M1/M2/M3) Rosetta is not required — Flutter builds natively for `arm64`.

### Android emulator

First-time setup (only needed once):

**Windows / macOS Intel (x86_64):**

```bash
sdkmanager --install "platforms;android-36" "build-tools;36.0.0" \
  "system-images;android-36;google_apis;x86_64" "emulator"
yes | sdkmanager --licenses
avdmanager create avd -n pixel_test \
  -k "system-images;android-36;google_apis;x86_64" -d "pixel_6"
```

**macOS Apple Silicon (M1/M2/M3):**

```bash
sdkmanager --install "platforms;android-36" "build-tools;36.0.0" \
  "system-images;android-36;google_apis;arm64-v8a" "emulator"
yes | sdkmanager --licenses
avdmanager create avd -n pixel_test \
  -k "system-images;android-36;google_apis;arm64-v8a" -d "pixel_6"
```

Every session:

**Windows (PowerShell):**

```powershell
Start-Process emulator -ArgumentList "-avd pixel_test -no-metrics"
flutter run
```

**macOS:**

```bash
emulator -avd pixel_test -no-metrics &
flutter run
```

### iOS simulator (macOS only)

```bash
open -a Simulator
flutter run -d "iPhone 17"
```

### Chrome (UI only — API calls may fail due to CORS)

```bash
flutter run -d chrome
```

## Useful commands while `flutter run` is active

| Key | Action |
|---|---|
| `r` | Hot reload — applies code changes, keeps state |
| `R` | Hot restart — restarts the app, resets state |
| `q` | Quit — stops the app and exits cleanly |
| `p` | Toggle widget debug paint |
| `?` | Show all available commands |

## Stopping the emulator/simulator after quitting

**Android emulator (macOS and Windows):**

```bash
adb emu kill
```

**iOS simulator (macOS):**

```bash
xcrun simctl shutdown "iPhone 17"
```

## Running tests

```bash
flutter test
```

## API

Backend: [https://petcareapi.onrender.com](https://petcareapi.onrender.com/swagger/index.html)

Endpoints used:

| Action | Method | Path |
|---|---|---|
| Register | POST | `/api/Auth/register` |
| Login | POST | `/api/Auth/login` |
| Refresh token | POST | `/api/OAuth/refresh` |

> The API is hosted on a free-tier Render instance. The first request after a period of inactivity may take 30–60 seconds while the server wakes up.
