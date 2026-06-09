allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    project.evaluationDependsOn(":app")

    // Force des versions stables pour éviter l'erreur "requires AGP 8.9.1"
    configurations.all {
        resolutionStrategy {
            force("androidx.browser:browser:1.8.0")
            force("androidx.core:core:1.13.1")
            force("androidx.core:core-ktx:1.13.1")
        }
    }

    project.plugins.withId("com.android.application") {
        val android = project.extensions.findByName("android")
        if (android is com.android.build.gradle.BaseExtension) {
            android.testOptions.unitTests.isIncludeAndroidResources = false
        }
    }
    project.plugins.withId("com.android.library") {
        val android = project.extensions.findByName("android")
        if (android is com.android.build.gradle.BaseExtension) {
            android.testOptions.unitTests.isIncludeAndroidResources = false
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
