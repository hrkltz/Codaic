package io.hrkltz.codaic.tessera
import com.google.gson.*
import java.lang.reflect.Type


class TesseraDeserializer : JsonDeserializer<Tessera?> {
    private val gson = Gson()
    private val nodeTypeRegistry: MutableMap<String, Class<out Tessera>> =
        HashMap()


    fun registerType(nodeTypeName: String, nodeType: Class<out Tessera>) {
        nodeTypeRegistry[nodeTypeName] = nodeType
    }


    override fun deserialize(
        json: JsonElement,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): Tessera {
        val nodeObject: JsonObject = json.getAsJsonObject()
        val nodeTypeElement: JsonElement = nodeObject.get("tesseraType")
        val nodeType = nodeTypeRegistry[nodeTypeElement.asString]!!
        return gson.fromJson(nodeObject, nodeType)
    }


    companion object {
        val deserializer = TesseraDeserializer()


        init {
            deserializer.registerType("ScriptStartTessera", ScriptStartTessera::class.java)
            deserializer.registerType("LogTessera", LogTessera::class.java)
            deserializer.registerType("LightTessera", LightTessera::class.java)
            deserializer.registerType("ScriptTessera", ScriptTessera::class.java)
            deserializer.registerType("VibratorTessera", VibratorTessera::class.java)
        }
    }
}