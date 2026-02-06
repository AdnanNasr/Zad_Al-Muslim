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
    afterEvaluate {
        if (project.hasProperty("android")) {
            configure<com.android.build.gradle.BaseExtension> {
                compileSdkVersion(34)

                // 1. حل مشكلة الـ Namespace للمكتبات التي تفتقر إليه
                if (namespace == null) {
                    namespace = "com.generated.${project.name.replace("-", "_")}"
                }

                // 2. ضمان قراءة المانيفست بشكل صحيح
                sourceSets.getByName("main") {
                    manifest.srcFile("src/main/AndroidManifest.xml")
                }
            }
            
            // 3. الحل الذكي: حذف سطر package="..." المسبب للخطأ في Isar
            project.tasks.withType<com.android.build.gradle.tasks.ProcessLibraryManifest> {
                doFirst {
                    val manifestFile = mainManifest.get().asFile
                    if (manifestFile.exists()) {
                        val content = manifestFile.readText()
                        if (content.contains("package=")) {
                            val newContent = content.replace(Regex("""package="[^"]*""""), "")
                            manifestFile.writeText(newContent)
                        }
                    }
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}