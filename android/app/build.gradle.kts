plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.my_expense_tracker_hive_database"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // 🎯 ফিক্স ১: coreLibraryDesugaring এনাবল করা হলো
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.my_expense_tracker_hive_database"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 🎯 ফিক্স ২: মাল্টিডেক্স এনাবল করা হলো (Kotlin DSL ফরম্যাটে)
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🎯 ফিক্স: ভার্সনটি 2.0.4 থেকে বাড়িয়ে 2.1.4 বা তার লেটেস্ট করে দেওয়া হলো
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}