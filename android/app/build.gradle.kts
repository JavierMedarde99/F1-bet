plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin debe ir al final
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.f1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.f1"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            applicationIdSuffix = ".debug"
            isDebuggable = true
            // Debug, no minificación
            isMinifyEnabled = false
            isShrinkResources = false
        }
        release {
            // Para testear, puedes usar debug signing, luego cambiar por release
            signingConfig = signingConfigs.getByName("debug")

            // ⚡ Deshabilitar temporalmente minificación hasta asegurar que funciona
            isMinifyEnabled = false
            isShrinkResources = false

            // Opcional: activar proguard después de probar
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    // Si usas HTTP (no recomendado), habilitar tráfico claro
    // buildFeatures { ... } // No requerido si solo HTTPS
}

flutter {
    source = "../.."
}