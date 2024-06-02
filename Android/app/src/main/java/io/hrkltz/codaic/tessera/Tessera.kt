package io.hrkltz.codaic.tessera
import io.hrkltz.codaic.item.InputItem
import io.hrkltz.codaic.item.OutputItem


open class Tessera {
    lateinit var tesseraId: String
    lateinit var tesseraType: String
    lateinit var inputPortArray: Array<InputItem?>
    lateinit var outputPortArray: Array<OutputItem?>
    lateinit var tesseraSettingsJson: String


    open fun worker() = Unit
    open fun stop() = Unit
    open fun start() = Unit
}