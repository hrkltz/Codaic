package io.hrkltz.codaic.node

import android.util.Log
import com.caoccao.javet.interception.logging.JavetStandardConsoleInterceptor
import com.caoccao.javet.interop.V8Host
import com.caoccao.javet.interop.V8Runtime
import com.google.gson.annotations.SerializedName
import io.hrkltz.codaic.JavetExtension
import io.hrkltz.codaic.Project
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.serialization.Serializable


class ScriptStartNode: Node() {
    @Serializable
    data class NodeSettings(var code: String = "")
    lateinit var nodeSettings: NodeSettings


    override fun worker() {
        Log.i("Codaic", "ScriptStartNode.worker()")
        // lifecycleScope.launch { ?
        GlobalScope.launch {
            while (Project.getInstance().isRunning) {
                V8Host.getV8Instance().createV8Runtime<V8Runtime>().use {
                    // Link console.log(..) to Log.i(..).
                    JavetStandardConsoleInterceptor(it).register(it.globalObject)
                    // Bind AnnotationBasedCallbackReceiver to V8.
                    val v8ValueObject = it.createV8ValueObject()
                    it.globalObject.set("Codaic", v8ValueObject)
                    val annotationBasedCallbackReceiver = JavetExtension()
                    v8ValueObject.bind(annotationBasedCallbackReceiver)
                    // Execute the code
                    val result = it.getExecutor(nodeSettings.code).executeObject<Any>()
                    //Log.i("Codaic", "Result: $result")
                    // Unregister console.
                    JavetStandardConsoleInterceptor(it).unregister(it.globalObject)
                    // Notify V8 to perform GC. (Optional)
                    it.lowMemoryNotification()

                    if (nodeOutputPortArray[0] != null)
                        Project.getInstance().sendData(nodeOutputPortArray[0]!!.nodeId,
                            nodeOutputPortArray[0]!!.inputIndex, result)
                }
            }
        }
    }
}