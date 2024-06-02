package io.hrkltz.codaic.node
import io.hrkltz.codaic.item.InputItem
import io.hrkltz.codaic.item.OutputItem


open class Node {
    lateinit var nodeId: String
    lateinit var nodeInputPortArray: Array<InputItem?>
    lateinit var nodeOutputPortArray: Array<OutputItem?>


    open fun worker() = Unit
    open fun stop() = Unit
    open fun start() = Unit
}