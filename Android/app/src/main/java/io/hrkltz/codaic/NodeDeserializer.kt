package io.hrkltz.codaic
import com.google.gson.*
import io.hrkltz.codaic.node.Node
import io.hrkltz.codaic.node.ScriptStartNode
import java.lang.reflect.Type


class NodeDeserializer : JsonDeserializer<Node?> {
    private val gson = Gson()
    private val nodeTypeRegistry: MutableMap<String, Class<out Node>> =
        HashMap()

    fun registerType(nodeTypeName: String, nodeType: Class<out Node>) {
        nodeTypeRegistry[nodeTypeName] = nodeType
    }

    override fun deserialize(
        json: JsonElement,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): Node {
        val nodeObject: JsonObject = json.getAsJsonObject()
        val nodeTypeElement: JsonElement = nodeObject.get("nodeType")
        val nodeType = nodeTypeRegistry[nodeTypeElement.asString]!!
        return gson.fromJson(nodeObject, nodeType)
    }


    companion object {
        val deserializer = NodeDeserializer()


        init {
            deserializer.registerType("ScriptStartNode", ScriptStartNode::class.java)
        }
    }
}