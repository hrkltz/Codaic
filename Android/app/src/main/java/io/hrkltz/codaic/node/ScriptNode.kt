package io.hrkltz.codaic.node

import android.util.Log
import com.caoccao.javet.interception.logging.JavetStandardConsoleInterceptor
import com.caoccao.javet.interop.V8Host
import com.caoccao.javet.interop.V8Runtime
import io.hrkltz.codaic.JavetExtension
import io.hrkltz.codaic.Project
import kotlinx.coroutines.Job
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.yield
import kotlinx.serialization.Serializable


class ScriptNode: Node() {
    @Serializable
    data class NodeSettings(var code: String = "")
    lateinit var nodeSettings: NodeSettings
    private lateinit var _v8Runtime: V8Runtime


    override fun start() {
        Log.i("Codaic", "ScriptNode.start()")
    }


    override fun stop() {
        Log.i("Codaic", "ScriptNode.stop()")
        //_v8Runtime.terminateExecution()
        //_v8Runtime.throwError(true)
    }


    override fun worker() {
        Log.i("Codaic", "ScriptNode.worker()")
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
            val v8Object: Any = when (nodeInputPortArray[0]!!.data) {
                is String -> it.createV8ValueString(nodeInputPortArray[0]!!.data as String)
                is Boolean -> it.createV8ValueBooleanObject(nodeInputPortArray[0]!!.data as Boolean)
                is Int -> it.createV8ValueIntegerObject(nodeInputPortArray[0]!!.data as Int)
                is Double -> it.createV8ValueDoubleObject(nodeInputPortArray[0]!!.data as Double)
                is Float -> it.createV8ValueDoubleObject((nodeInputPortArray[0]!!.data as Float).toDouble())
                // TODO: Support Array and Map.
                else -> it.createV8ValueObject().bind(nodeInputPortArray[0]!!.data)
            }

            it.globalObject.set("input", v8Object)

            // Execute the code
            try {
                val result = it.getExecutor(nodeSettings.code).executeObject<Any>()
                // Unregister console.
                JavetStandardConsoleInterceptor(it).unregister(it.globalObject)
                // Notify V8 to perform GC. (Optional)
                it.lowMemoryNotification()
                if (nodeOutputPortArray[0] != null)
                    Project.getInstance().sendData(nodeOutputPortArray[0]!!.nodeId,
                        nodeOutputPortArray[0]!!.inputIndex, result)
                // Just because Kotlin is strange: "'if' must have both main and 'else' branches if used as an expression"
                else ""
            }
            catch (_: Exception) {
                // Empty
            }
        }
    }
}