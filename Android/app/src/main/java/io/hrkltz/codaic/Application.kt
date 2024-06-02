package io.hrkltz.codaic

import android.app.Application
import android.content.Context


class Application : Application() {
    companion object {
        lateinit var context: Context
    }

    // Instance - private
    // Instance - public
    override fun onCreate() {
        super.onCreate()
        context = applicationContext
    }
}