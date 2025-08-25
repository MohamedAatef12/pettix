import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("app")

    productFlavors {
        create("dev") {
            dimension = "app"
            applicationId = "com.example.myapp.dev"
            resValue(type = "string", name = "app_name", value = "MyApp Dev")
        }
        create("prod") {
            dimension = "app"
            applicationId = "com.example.myapp"
            resValue(type = "string", name = "app_name", value = "MyApp")
        }
    }
}