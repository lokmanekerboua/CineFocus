allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
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
