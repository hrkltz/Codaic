package io.hrkltz.codaic
import android.util.Log
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import io.hrkltz.codaic.tessera.Tessera
import io.hrkltz.codaic.tessera.TesseraDeserializer
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
    private var nodeMap = mutableMapOf<String, Tessera>()
    private var _isRunning = AtomicBoolean(false)

    // Instance - public
    val isRunning: Boolean
        get() = _isRunning.get()

    fun init(projectName: String) {
        val gson = GsonBuilder()
            .registerTypeAdapter(Tessera::class.java, TesseraDeserializer.deserializer)
            .create()
        val jsonString = AssetsUtil(Application.context).load("project/$projectName.json")
        val nodeArray: List<Tessera> = gson.fromJson(jsonString, object : TypeToken<List<Tessera>>() {}.type)
        nodeArray.forEach { nodeMap.put(it.tesseraId, it) }
    }


    fun start() {
        Log.i("Codaic", "Project.start()")
        _isRunning.set(true)
        nodeMap.forEach { it.value.start() }
        //nodeMap.filter { it.value is ScriptStartTessera }.forEach { it.value.worker() }
        //nodeMap.filter { it.value is StartTessera }.forEach { it.value.worker() }
    }


    fun stop() {
        _isRunning.set(false)
        nodeMap.forEach { it.value.stop() }
        nodeMap.clear()
    }


    fun sendData(tesseraId: String, portIndex: Int, data: Any?) {
        Log.i("Codaic", "Project.sendData($tesseraId, $portIndex, $data)")
        nodeMap[tesseraId]!!.inputPortArray[portIndex]!!.data = data

        //if (nodeMap[tesseraId]!!.inputPortArray[portIndex]!!.mode == "Active") {
            nodeMap[tesseraId]!!.worker()
        //}
    }
}