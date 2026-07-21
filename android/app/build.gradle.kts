import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // kotlin-android is deliberately not declared here. The Flutter Gradle Plugin
    // applies it itself when it is absent, and declaring it explicitly triggers the
    // "applies the Kotlin Gradle Plugin" migration warning on every build.
    // The Flutter Gradle Plugin must be applied after the Android Gradle plugin.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing, kept out of source control in android/key.properties (gitignored).
// https://docs.flutter.dev/deployment/android#sign-the-app
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "cz.studankyapp.studanky"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Final application ID — matches the iOS bundle identifier and the
        // package_name in /.well-known/assetlinks.json. Must never change after the
        // first Play Store release, since App Links verification binds to it.
        applicationId = "cz.studankyapp.studanky"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
