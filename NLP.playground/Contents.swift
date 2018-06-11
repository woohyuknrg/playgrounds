//: Playground - noun: a place where people can play
//NLLanguageRecognizer，NLTokenizer，NLTagger：https://www.swiftbysundell.com/daily-wwdc/a-first-look-at-the-natural-language-framework

import Foundation

//语种识别
let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)

tagger.string = "我是雷军"

let language = tagger.dominantLanguage

//分词
typealias TaggedToken = (String, NSLinguisticTag, NSRange)

private func tag(text: String, scheme: NSLinguisticTagScheme, unit: NSLinguisticTaggerUnit = .word) -> [TaggedToken] {
    let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(for: unit, language: "en"),
                                    options: 0)
    tagger.string = text

    let range = NSMakeRange(0, text.utf16.count)
    let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitOther]

    var taggedTokens: [TaggedToken] = []

    tagger.enumerateTags(in: range, unit: unit, scheme: scheme, options: options) { tag, tokenRange, _ in
        guard let tag = tag else { return }

        let token = (text as NSString).substring(with: tokenRange)
        taggedTokens.append((token, tag, tokenRange))
    }
    return taggedTokens
}

print(tag(text: "Ooops, seems like you are using a vintage version of our app. Please update to the latest version, we have lots of cool features wating for you!", scheme: .nameTypeOrLexicalClass))

//名字识别
func tagNames(text: String) -> [TaggedToken] {
    let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)

    tagger.string = text

    let range = NSMakeRange(0, text.utf16.count)
    //.joinNames. So in a text that contains, for example, personal names, the first and last name will be joined. A city name such as New York that has multiple words, will also get joined into one word
    let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]

    let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
    var taggedTokens: [TaggedToken] = []

    tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, _ in
        guard let tag = tag, tags.contains(tag) else { return }

        let token = (text as NSString).substring(with: tokenRange)
        taggedTokens.append((token, tag, tokenRange))
    }
    return taggedTokens
}

print("------------------------")

print(tagNames(text: "Ray Allen is at Symbio in New York"))
