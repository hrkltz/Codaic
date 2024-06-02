package io.hrkltz.codaic.tessera

import android.content.Context
import android.os.VibrationEffect
import android.os.VibratorManager
import android.util.Log
import io.hrkltz.codaic.Application


class VibratorTessera : Tessera() {
    /*constructor() : super(1, 0) {
        inputPortArray[0]!!.mode = "Active"
    }*/


    // The StartTessera simply sends a true to the connected node.
    override fun worker() {
        Log.i("Codaic", "VibratorTessera.worker()")

        if (inputPortArray[0]!!.data !is Boolean) {
            Log.i("Codaic", "VibratorTessera.worker(): Invalid input.")
            return
        }

        val vibratorManager = Application.context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE)
                as VibratorManager
        val vibrator = vibratorManager.defaultVibrator

        if (inputPortArray[0]!!.data == true) {
            Log.i("Codaic", "VibratorTessera.worker(): Vibrate.")
            vibrator.vibrate(VibrationEffect.createWaveform(longArrayOf(500L, 500L),
                intArrayOf(VibrationEffect.DEFAULT_AMPLITUDE, 0), -1))
        } else {
            Log.i("Codaic", "VibratorTessera.worker(): Don't vibrate.")
            vibrator.cancel()
        }
    }
}