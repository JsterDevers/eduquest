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

// --- ULTRA-ROBUST NAMESPACE & MANIFEST PATCH ---
// This version automatically fixes the "package=" error in older libraries
// like ML Kit without you having to manually edit library files in your cache.
subprojects {
    val applyFix = {
        val android = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (android != null) {
            // 1. Force the namespace if it's missing
            if (android.namespace == null) {
                android.namespace = project.group.toString()
            }
            
            // 2. Automatically strip the forbidden 'package' attribute from the Manifest
            val manifestFile = project.file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val content = manifestFile.readText()
                if (content.contains("package=")) {
                    val updatedContent = content.replace(Regex("""package="[^"]*""""), "")
                    manifestFile.writeText(updatedContent)
                }
            }
        }
    }

    if (project.state.executed) {
        applyFix()
    } else {
        project.afterEvaluate { applyFix() }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}