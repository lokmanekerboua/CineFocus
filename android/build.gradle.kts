allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    project.evaluationDependsOn(":app")

    // FIX: This solves the "this and base files have different roots" error on Windows
    // by disabling a unit test feature that causes cross-drive path failures.
    // Using plugins.withId avoids the "already evaluated" lifecycle error.
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
