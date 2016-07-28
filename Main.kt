import java.io.File
import java.util.regex.Pattern

fun main(args: Array<String>) {
    val text = File("samples/sample.html").readText()
    val indexOfBody = text.indexOf("<body")
    val body = text.substring(indexOfBody)
    val cleanBody = body.replace(Regex("\\<[^>]*>"), "")
    //println(cleanBody)
    //val words = cleanBody.split(Pattern.compile("[^a-zA-Z]")).filter { it != "" }
    //println(words)
    val sentences = cleanBody.split(Pattern.compile("[.?!]")).filter {
        it != ""
    }.map {
        it.trim().replace('\n', ' ')
    }

    for(s in sentences) {
        println("--- " + s)
    }
}
