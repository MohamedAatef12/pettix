import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("app")

    productFlavors {
        create("development") {
            dimension = "app"
            applicationId = "com.pettix.up"
            resValue(type = "string", name = "app_name", value = "Pettix Dev")
        }
        create("production") {
            dimension = "app"
            applicationId = "com.pettix.up"
            resValue(type = "string", name = "app_name", value = "Pettix")
        }
    }
}