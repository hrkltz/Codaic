package io.hrkltz.codaic.util

import android.content.Context
import java.io.IOException


class AssetsUtil(private val context: Context) {
    fun load(fileName: String?): String {
        var result: String

        try {
            val assetManager = context.assets
            val inputStream = assetManager.open(fileName!!)
            val size = inputStream.available()
            val buffer = ByteArray(size)
            inputStream.read(buffer)
            inputStream.close()
            result = String(buffer, charset("UTF-8"))
        } catch (e: IOException) {
            e.printStackTrace()
            throw Exception("AssetsUtil.load.1")
        }

        return result
    }
}