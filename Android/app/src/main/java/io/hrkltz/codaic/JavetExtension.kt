// Source: https://www.caoccao.com/Javet/reference/v8_values/v8_function.html

package io.hrkltz.codaic

import android.util.Log
import com.caoccao.javet.annotations.V8Function


class JavetExtension {
    @V8Function(name = "sleep")
    fun sleep(millis: Long) {
        Log.i("Codaic", "JavetExtension.sleep($millis)")
        Thread.sleep(millis)
    }
}