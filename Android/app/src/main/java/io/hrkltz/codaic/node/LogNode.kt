package io.hrkltz.codaic.node
import com.google.gson.Gson
import android.util.Log
import io.hrkltz.codaic.Project


class LogNode : Node() {
    override fun start() {
        Log.i("Codaic", "LogNode.start()");
    }


    override fun stop() {
        Log.i("Codaic", "LogNode.stop()");
    }


    override fun worker() {
        Log.i("Codaic", Gson().toJson(nodeInputPortArray[0]!!.data))

        if (nodeOutputPortArray[0] != null)
            Project.getInstance().sendData(nodeOutputPortArray[0]!!.nodeId,
                nodeOutputPortArray[0]!!.inputIndex, nodeInputPortArray[0]!!.data)
    }
}