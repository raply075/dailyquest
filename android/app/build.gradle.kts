plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.dailyquest2"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.dailyquest2"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        debug {
            // Kosongkan jika hanya untuk development
        }
        release {
            // Pastikan TIDAK ada shrinkResources
            isMinifyEnabled = false
            // Jangan tambahkan shrinkResources = false kalau pakai Gradle KTS
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}
