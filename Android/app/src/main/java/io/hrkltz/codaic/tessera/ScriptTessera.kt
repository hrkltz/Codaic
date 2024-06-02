package io.hrkltz.codaic.tessera

import android.util.Log
import com.caoccao.javet.interception.logging.JavetStandardConsoleInterceptor
import com.caoccao.javet.interop.V8Host
import com.caoccao.javet.interop.V8Runtime
import com.google.gson.Gson
import io.hrkltz.codaic.JavetExtension
import io.hrkltz.codaic.Project
import kotlinx.serialization.Serializable


class ScriptTessera: Tessera() {
    @Serializable
    data class ScriptTesseraSettings(var code: String = "")
    private lateinit var _v8Runtime: V8Runtime
    private lateinit var _code: String


    override fun start() {
        Log.i("Codaic", "ScriptTessera.start()")
        _code =  Gson().fromJson(super.tesseraSettingsJson, ScriptStartTessera.ScriptStartTesseraSettings::class.java).code
    }


    override fun stop() {
        Log.i("Codaic", "ScriptTessera.stop()")
        //_v8Runtime.terminateExecution()
        //_v8Runtime.throwError(true)
    }


    override fun worker() {
        Log.i("Codaic", "ScriptTessera.worker()")
        // lifecycleScope.launch { ?
        _v8Runtime = V8Host.getV8Instance().createV8Runtime<V8Runtime>()
        _v8Runtime.use {
            // Link console.log(..) to Log.i(..).
            JavetStandardConsoleInterceptor(it).register(it.globalObject)
            // Bind AnnotationBasedCallbackReceiver to V8.
            val v8ValueObject = it.createV8ValueObject()
            it.globalObject.set("Codaic", v8ValueObject)
            val annotationBasedCallbackReceiver = JavetExtension()
            v8ValueObject.bind(annotationBasedCallbackReceiver)

            // Add InputPort value to the JS instance.
            // TODO: Switch based on object type.
            val v8Object: Any = when (inputPortArray[0]!!.data) {
                is String -> it.createV8ValueString(inputPortArray[0]!!.data as String)
                is Boolean -> it.createV8ValueBooleanObject(inputPortArray[0]!!.data as Boolean)
                is Int -> it.createV8ValueIntegerObject(inputPortArray[0]!!.data as Int)
                is Double -> it.createV8ValueDoubleObject(inputPortArray[0]!!.data as Double)
                is Float -> it.createV8ValueDoubleObject((inputPortArray[0]!!.data as Float).toDouble())
                // TODO: Support Array and Map.
                else -> it.createV8ValueObject().bind(inputPortArray[0]!!.data)
            }

            it.globalObject.set("input", v8Object)

            // Execute the code
            try {
                val result = it.getExecutor(_code).executeObject<Any>()
                // Unregister console.
                JavetStandardConsoleInterceptor(it).unregister(it.globalObject)
                // Notify V8 to perform GC. (Optional)
                it.lowMemoryNotification()
                if (outputPortArray[0] != null)
                    Project.getInstance().sendData(outputPortArray[0]!!.tesseraId,
                        outputPortArray[0]!!.portIndex, result)
                // Just because Kotlin is strange: "'if' must have both main and 'else' branches if used as an expression"
                else ""
            }
            catch (_: Exception) {
                // Empty
            }
        }
    }
}