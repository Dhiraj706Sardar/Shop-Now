# 🚀 Flutter CI/CD Setup - Build & Generate APK

## 📋 Step-by-Step Guide

### **Step 1: Understanding the Workflow**

The workflow file at `.github/workflows/flutter-ci-cd.yaml` will automatically:
- ✅ Build your Flutter app
- ✅ Run all tests
- ✅ Generate Debug APK
- ✅ Generate Release APK
- ✅ Make APKs available for download

**Triggers:** Runs automatically when you push to `main` or `develop` branches

---

### **Step 2: Commit and Push the Workflow**

```bash
# Add the workflow file
git add .github/workflows/flutter-ci-cd.yaml

# Commit
git commit -m "Add CI/CD workflow for Flutter app"

# Push to trigger the workflow
git push origin main
```

---

### **Step 3: Monitor the Build**

1. Go to your GitHub repository
2. Click on the **"Actions"** tab at the top
3. You'll see your workflow running (yellow dot = running, green = success, red = failed)
4. Click on the workflow run to see detailed logs

**Build typically takes:** 5-10 minutes

---

### **Step 4: Download the APK Files**

After the build completes successfully:

1. Scroll down to the **"Artifacts"** section at the bottom
2. You'll see two downloadable files:
   - `debug-apk` - Debug version of your app
   - `release-apk` - Release version of your app
3. Click to download the ZIP file
4. Extract and install the APK on your Android device

---

### **Step 5: Test the APK**

**Debug APK:**
- Good for testing
- Larger file size
- Includes debugging symbols

**Release APK:**
- Smaller and optimized
- Better performance
- This is what users should get

**To install:**
```bash
# Transfer to device via ADB
adb install app-release.apk

# OR: Download on device and tap to install (enable "Install from Unknown Sources")
```

---

## 🔧 Workflow Details

Here's what happens in each step:

| Step | Description | Duration |
|------|-------------|----------|
| 1️⃣ **Checkout** | Downloads your code | 5s |
| 2️⃣ **Setup Java** | Installs Java 17 (needed for Android) | 10s |
| 3️⃣ **Setup Flutter** | Installs Flutter SDK | 30s |
| 4️⃣ **Verify Flutter** | Checks Flutter installation | 5s |
| 5️⃣ **Get Dependencies** | Runs `flutter pub get` | 30s |
| 6️⃣ **Analyze Code** | Runs `flutter analyze` | 20s |
| 7️⃣ **Run Tests** | Runs `flutter test` | 30s-2m |
| 8️⃣ **Build Debug APK** | Creates debug APK | 2-3m |
| 9️⃣ **Build Release APK** | Creates release APK | 2-3m |
| 🔟 **Upload APKs** | Saves APKs as artifacts | 10s |

**Total Time:** ~5-10 minutes

---

## 📁 Where to Find Build Outputs

### In GitHub:
- **Actions Tab** → Select workflow run → **Artifacts** section

### Locally (if building on your machine):
```
build/app/outputs/flutter-apk/
├── app-debug.apk
└── app-release.apk
```

---

## 🎯 How to Use Different Branches

The workflow is configured to run on:
- ✅ `main` branch (production)
- ✅ `develop` branch (development)
- ✅ Any Pull Request to `main`

**Example workflow:**
```bash
# Work on feature branch
git checkout -b feature/new-feature

# Make changes
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# Create Pull Request to 'main'
# CI/CD runs automatically to test before merging!
```

---

## 🔍 Troubleshooting

### ❌ **Build Fails at "Run Tests"**
**Problem:** Tests are failing

**Solutions:**
1. Run tests locally first: `flutter test`
2. Fix failing tests
3. Or allow tests to fail without stopping build:
   ```yaml
   - name: 🧪 Run Tests
     run: flutter test
     continue-on-error: true  # Add this line
   ```

---

### ❌ **Build Fails at "Build APK"**
**Problem:** Compilation errors

**Solutions:**
1. Verify local build works: `flutter build apk --release`
2. Check the error logs in GitHub Actions
3. Fix the errors in your code
4. Push the fixes

---

### ❌ **Workflow Doesn't Appear**
**Problem:** Workflow file not detected

**Solutions:**
1. Ensure file is at: `.github/workflows/flutter-ci-cd.yaml`
2. Note: It's `workflows` (plural), not `workflow`
3. Check file has `.yaml` or `.yml` extension

---

### ❌ **APK Won't Install on Device**
**Problem:** "App not installed" error

**Solutions:**
1. Enable "Install from Unknown Sources" in device settings
2. If updating, uninstall old version first
3. Try debug APK instead of release APK

---

## 🎨 Customization Options

### Change Flutter Version
```yaml
- name: 🐦 Setup Flutter SDK
  uses: subosito/flutter-action@v2
  with:
    channel: 'stable'
    flutter-version: '3.16.0'  # Specify exact version
```

### Build for Specific Platform Only
```yaml
# Build only release APK (skip debug)
- name: 🏗️ Build Release APK
  run: flutter build apk --release
# Remove the debug build step
```

### Add Build Flavors
```yaml
# Build different flavors
- name: Build Production APK
  run: flutter build apk --release --flavor production

- name: Build Staging APK
  run: flutter build apk --release --flavor staging
```

### Keep Artifacts Longer
```yaml
- name: 📤 Upload Release APK
  uses: actions/upload-artifact@v3
  with:
    name: release-apk
    path: build/app/outputs/flutter-apk/app-release.apk
    retention-days: 90  # Default is 90, max is 90
```

---

## ✅ Success Checklist

After setup, verify:
- [ ] Workflow file exists at `.github/workflows/flutter-ci-cd.yaml`
- [ ] Workflow appears in GitHub Actions tab
- [ ] Build completes successfully (green checkmark)
- [ ] Both APKs are available in Artifacts
- [ ] Debug APK installs and runs on device
- [ ] Release APK installs and runs on device

---

## 📊 What You Have Now

✅ **Automatic Building** - Every push triggers a build  
✅ **Automatic Testing** - Tests run before building  
✅ **APK Generation** - Both debug and release APKs created  
✅ **Easy Download** - APKs available in GitHub for 90 days  
✅ **Quality Checks** - Code analysis runs automatically  

---

## 🚀 Next Steps (Optional)

If you want to enhance further:

1. **Add Signed APK** - For production releases
2. **Build App Bundle** - For Play Store submission (.aab)
3. **Add Notifications** - Get notified when builds complete
4. **Matrix Builds** - Test on multiple Flutter versions
5. **Performance Testing** - Add performance benchmarks

But for now, you have a **complete, working CI/CD pipeline** for building and testing your Flutter app! 🎉

---

## 📝 Quick Commands Reference

```bash
# Local testing before pushing
flutter analyze          # Check for issues
flutter test            # Run all tests
flutter build apk       # Build APK locally

# Git workflow
git add .
git commit -m "Your message"
git push origin main    # Triggers CI/CD

# ADB commands
adb devices                              # List connected devices
adb install app-release.apk            # Install APK
adb install -r app-release.apk        # Reinstall (keep data)
adb uninstall com.example.ecommerce_app # Uninstall
```

---

**You're all set! Push your code and watch the magic happen! 🎉**
