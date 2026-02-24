plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nooralbayan.noor_bayan"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    packagingOptions {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    compileOptions {
        // --- أضف هذا السطر هنا ---
        isCoreLibraryDesugaringEnabled = true 
        
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.nooralbayan.noor_bayan"
        minSdk = flutter.minSdkVersion // يفضل جعل الحد الأدنى 21 لدعم الإشعارات والـ Desugaring بشكل أفضل
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        externalNativeBuild {
            cmake {
                arguments += listOf("-DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON")
            }
        }
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

// --- أضف هذا القسم في نهاية الملف تماماً ---
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
