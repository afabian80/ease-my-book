import java.io.File
import java.util.regex.Pattern

fun main(args: Array<String>) {
    if (args.size == 0) {
        println("Parameters: <html-file>")
        return
    }
    val text = File(args[0]).readText()
    val indexOfBody = text.indexOf("<body")
    val body = text.substring(indexOfBody)
    val cleanBody = body.replace(Regex("\\<[^>]*>"), "")
    //println(cleanBody)
    //val words = cleanBody.split(Pattern.compile("[^a-zA-Z]")).filter { it != "" }
    //println(words)
    val sentences = cleanBody.split(Pattern.compile("[.?!]\\s")).filter {
        it != ""
    }.map {
        //it.trim().replace('\n', ' ')
        it
    }

    for(s in sentences) {
        println("--- " + s)
    }
}
