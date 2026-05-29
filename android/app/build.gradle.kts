plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.io.FileInputStream
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.zad_al_muslim.adnan"
    // compileSdk = flutter.compileSdkVersion
    // رفع compileSdk إلى 36 لدعم sqflite_android-2.4.x+ الذي يستخدم VERSION_CODES.BAKLAVA
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    packagingOptions {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        // sourceCompatibility = JavaVersion.VERSION_17
        // targetCompatibility = JavaVersion.VERSION_17
        // رفع Java إلى 21 لدعم Locale.of() و Thread.threadId() المستخدمتين في sqflite_android-2.4.x+
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        // jvmTarget = JavaVersion.VERSION_17.toString()
        jvmTarget = JavaVersion.VERSION_21.toString()
    }

    defaultConfig {
        applicationId = "com.zad_al_muslim.adnan"
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
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
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
