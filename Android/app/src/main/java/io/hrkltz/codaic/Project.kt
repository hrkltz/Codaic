package io.hrkltz.codaic
import android.util.Log
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import io.hrkltz.codaic.node.Node
import io.hrkltz.codaic.util.AssetsUtil
import java.util.concurrent.atomic.AtomicBoolean


class Project {
    companion object {
        // The @Volatile annotation makes the instance property is atomic.
        @Volatile
        private var instance: Project? = null


        // The synchronized keyword prevents accessing the method from multiple threads
        // simultaneously.
        fun getInstance() =
            instance ?: synchronized(this) { instance ?: Project().also { instance = it } }
    }

    // Instance - private
    private var nodeMap = mutableMapOf<String, Node>()
    private var _isRunning = AtomicBoolean(false)

    // Instance - public
    val isRunning: Boolean
        get() = _isRunning.get()

    fun init(projectName: String) {
        val gson = GsonBuilder()
            .registerTypeAdapter(Node::class.java, NodeDeserializer.deserializer)
            .create()
        val jsonString = AssetsUtil(Application.context).load("project/$projectName.json")
        val nodeArray: List<Node> = gson.fromJson(jsonString, object : TypeToken<List<Node>>() {}.type)
        nodeArray.forEach { nodeMap.put(it.nodeId, it) }
    }


    fun start() {
        Log.i("Codaic", "Project.start()")
        _isRunning.set(true)
        nodeMap.forEach { it.value.start() }
        //nodeMap.filter { it.value is ScriptStartNode }.forEach { it.value.worker() }
        //nodeMap.filter { it.value is StartNode }.forEach { it.value.worker() }
    }


    fun stop() {
        _isRunning.set(false)
        nodeMap.forEach { it.value.stop() }
        nodeMap.clear()
    }


    fun sendData(nodeId: String, inputIndex: Int, data: Any?) {
        Log.i("Codaic", "Project.sendData($nodeId, $inputIndex, $data)")
        nodeMap[nodeId]!!.nodeInputPortArray[inputIndex]!!.data = data

        //if (nodeMap[nodeId]!!.nodeInputPortArray[inputIndex]!!.mode == "Active") {
            nodeMap[nodeId]!!.worker()
        //}
    }
}