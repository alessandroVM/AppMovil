// Top-level build file
buildscript {
    repositories {
        google()
        mavenCentral()
    }

    //ext.kotlin_version = '2.1.0' //NUEVO

    dependencies {
        classpath("com.android.tools.build:gradle:7.3.1") // Usa la versión actual
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0") // Ajusta la versión
        classpath("com.google.gms:google-services:4.3.15") // 🔥 Añade esto para Firebase
    }
} //FIREBASE

allprojects {
    repositories {
        google()
        mavenCentral()
    }
    

}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
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
