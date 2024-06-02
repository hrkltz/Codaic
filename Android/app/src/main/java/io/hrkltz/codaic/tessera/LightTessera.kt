package io.hrkltz.codaic.tessera
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.hardware.SensorManager.SENSOR_DELAY_FASTEST
import android.util.Log
import io.hrkltz.codaic.Application
import io.hrkltz.codaic.Project


class LightTessera : Tessera() {
    private var mSensorManager: SensorManager? = null
    private var mSensorEventListener: SensorEventListener? = null
    private var mSensor: Sensor? = null


    override fun start() {
        Log.i("Codaic", "LightTessera.start()")
        mSensorManager = Application.context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        mSensor = mSensorManager!!.getDefaultSensor(Sensor.TYPE_LIGHT)
        mSensorEventListener = object : SensorEventListener {
            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
            override fun onSensorChanged(event: SensorEvent) {
                if (outputPortArray[0] != null)
                    Project.getInstance().sendData(outputPortArray[0]!!.tesseraId,
                        outputPortArray[0]!!.portIndex, event.values[0])
            }
        }
        mSensorManager!!.registerListener(mSensorEventListener, mSensor, SENSOR_DELAY_FASTEST)
    }


    override fun stop() {
        Log.i("Codaic", "LightTessera.stop()")
        mSensorManager!!.unregisterListener(mSensorEventListener, mSensor)
        mSensorEventListener = null
        mSensorManager = null
        mSensor = null
    }


    protected fun finalize() {
        Log.i("Codaic", "LightTessera.finalize()")
        // finalization logic
    }


    override fun worker() {
        Log.i("Codaic", "LightTessera.worker()")
    }
}