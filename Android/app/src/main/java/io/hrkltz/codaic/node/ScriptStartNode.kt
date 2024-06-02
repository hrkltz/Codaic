package io.hrkltz.codaic.node
import android.util.Log
import com.caoccao.javet.interception.logging.JavetStandardConsoleInterceptor
import com.caoccao.javet.interop.V8Host
import com.caoccao.javet.interop.V8Runtime
import io.hrkltz.codaic.JavetExtension
import io.hrkltz.codaic.Project
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.yield
import kotlinx.serialization.Serializable


class ScriptStartNode: Node() {
    @Serializable
    data class NodeSettings(var code: String = "")
    lateinit var nodeSettings: NodeSettings
    private lateinit var _job: Job
    private lateinit var _v8Runtime: V8Runtime


    override fun start() {
        Log.i("Codaic", "ScriptStartNode.start()")
        worker()
    }


    override fun stop() {
        Log.i("Codaic", "ScriptStartNode.stop()")
        runBlocking {
            _job.cancel()
            _v8Runtime.terminateExecution()
            _v8Runtime.throwError(true)
            _job.join()
        }
    }


    override fun worker() {
        Log.i("Codaic", "ScriptStartNode.worker()")
        // lifecycleScope.launch { ?
        _job = GlobalScope.launch {
            while (true) {
                yield()
                _v8Runtime = V8Host.getV8Instance().createV8Runtime<V8Runtime>()
                _v8Runtime.use {
                    // Link console.log(..) to Log.i(..).
                    JavetStandardConsoleInterceptor(it).register(it.globalObject)
                    // Bind AnnotationBasedCallbackReceiver to V8.
                    val v8ValueObject = it.createV8ValueObject()
                    it.globalObject.set("Codaic", v8ValueObject)
                    val annotationBasedCallbackReceiver = JavetExtension()
                    v8ValueObject.bind(annotationBasedCallbackReceiver)

                    // Execute the code
                    try {
                        val result = it.getExecutor(nodeSettings.code).executeObject<Any>()
                        // Unregister console.
                        JavetStandardConsoleInterceptor(it).unregister(it.globalObject)
                        // Notify V8 to perform GC. (Optional)
                        it.lowMemoryNotification()
                        yield()
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
    }
}