package io.hrkltz.codaic.node

import android.content.Context
import android.os.VibrationEffect
import android.os.VibratorManager
import android.util.Log
import io.hrkltz.codaic.Application


class VibratorNode : Node() {
    /*constructor() : super(1, 0) {
        nodeInputPortArray[0]!!.mode = "Active"
    }*/


    // The StartNode simply sends a true to the connected node.
    override fun worker() {
        Log.i("Codaic", "VibratorNode.worker()")

        if (nodeInputPortArray[0]!!.data !is Boolean) {
            Log.i("Codaic", "VibratorNode.worker(): Invalid input.")
            return
        }

        val vibratorManager = Application.context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE)
                as VibratorManager
        val vibrator = vibratorManager.defaultVibrator

        if (nodeInputPortArray[0]!!.data == true) {
            Log.i("Codaic", "VibratorNode.worker(): Vibrate.")
            vibrator.vibrate(VibrationEffect.createWaveform(longArrayOf(500L, 500L),
                intArrayOf(VibrationEffect.DEFAULT_AMPLITUDE, 0), -1))
        } else {
            Log.i("Codaic", "VibratorNode.worker(): Don't vibrate.")
            vibrator.cancel()
        }
    }
}