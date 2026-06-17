buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // 🎯 ফিক্স: কোটলিন ডিএসএল (KTS) ফরম্যাটে ব্র্যাকেট ও ডাবল কোটেশন দিয়ে classpath লেখা হলো
        classpath("com.android.tools.build:gradle:8.0.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}