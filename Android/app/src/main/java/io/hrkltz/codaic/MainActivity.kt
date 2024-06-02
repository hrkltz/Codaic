package io.hrkltz.codaic

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.lifecycleScope
import com.caoccao.javet.exceptions.JavetTerminatedException
import com.caoccao.javet.interop.V8Host
import com.caoccao.javet.interop.V8Runtime
import io.hrkltz.codaic.ui.theme.CodaicTheme
import kotlinx.coroutines.launch
import java.util.concurrent.TimeUnit


class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CodaicTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Greeting("Android")
                    Column {
                        Button(onClick = {
                            // Launch a coroutine
                            lifecycleScope.launch {
                                val projectInstance = Project.getInstance()

                                if (projectInstance.isRunning) {
                                    projectInstance.stop()
                                } else {
                                    projectInstance.init("01")
                                    projectInstance.start()
                                }
                            }
                        }) {
                            Text(text = "01")
                        }
                        Button(onClick = {
                            // Launch a coroutine
                            lifecycleScope.launch {
                                val projectInstance = Project.getInstance()

                                if (projectInstance.isRunning) {
                                    projectInstance.stop()
                                } else {
                                    projectInstance.init("02")
                                    projectInstance.start()
                                }
                            }
                        }) {
                            Text(text = "02")
                        }
                        Button(onClick = {
                            // Launch a coroutine
                            lifecycleScope.launch {
                                val projectInstance = Project.getInstance()

                                if (projectInstance.isRunning) {
                                    projectInstance.stop()
                                } else {
                                    projectInstance.init("03")
                                    projectInstance.start()
                                }
                            }
                        }) {
                            Text(text = "03")
                        }
                        Button(onClick = {
                            // Launch a coroutine
                            lifecycleScope.launch {
                                val projectInstance = Project.getInstance()

                                if (projectInstance.isRunning) {
                                    projectInstance.stop()
                                } else {
                                    projectInstance.init("04")
                                    projectInstance.start()
                                }
                            }
                        }) {
                            Text(text = "04")
                        }
                        Button(onClick = {
                            // Launch a coroutine
                            lifecycleScope.launch {
                                val projectInstance = Project.getInstance()

                                if (projectInstance.isRunning) {
                                    projectInstance.stop()
                                } else {
                                    projectInstance.init("05")
                                    projectInstance.start()
                                }
                            }
                        }) {
                            Text(text = "05")
                        }
                        Button(onClick = {
                            // Launch a coroutine
                            lifecycleScope.launch {
                                val projectInstance = Project.getInstance()

                                if (projectInstance.isRunning) {
                                    projectInstance.stop()
                                } else {
                                    projectInstance.init("x1")
                                    projectInstance.start()
                                }
                            }
                        }) {
                            Text(text = "x1")
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    CodaicTheme {
        Greeting("Android")
    }
}