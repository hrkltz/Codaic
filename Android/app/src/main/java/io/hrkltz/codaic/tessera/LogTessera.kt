package io.hrkltz.codaic.tessera
import com.google.gson.Gson
import android.util.Log
import io.hrkltz.codaic.Project


class LogTessera : Tessera() {
    override fun start() {
        Log.i("Codaic", "LogTessera.start()");
    }


    override fun stop() {
        Log.i("Codaic", "LogTessera.stop()");
    }


    override fun worker() {
        Log.i("Codaic", Gson().toJson(inputPortArray[0]!!.data))

        if (outputPortArray[0] != null)
            Project.getInstance().sendData(outputPortArray[0]!!.tesseraId,
                outputPortArray[0]!!.inputIndex, inputPortArray[0]!!.data)
    }
}