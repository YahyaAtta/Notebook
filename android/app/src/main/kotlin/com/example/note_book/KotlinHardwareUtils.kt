package com.example.note_book
import android.app.Activity
import android.os.Build
import android.widget.Toast
import java.util.HashMap
import androidx.annotation.Keep
import kotlinx.coroutines.*
@Keep
class KotlinHardwareUtils {
    fun getHardwareKotlinUtils() : Map<String, String> {
        val hardware : MutableMap<String,String> = HashMap()
        hardware["Manufacturer"] = Build.MANUFACTURER
        hardware["Model No"] = Build.MODEL
        hardware["Version"] = Build.VERSION.RELEASE
        hardware["Board"] = Build.BOARD
    return hardware
    }
    fun customShowToast(mainActivity: Activity,string: CharSequence,duration:Int){
        mainActivity.runOnUiThread {
            Toast.makeText(mainActivity,string,duration).show()
        }
    }

}
