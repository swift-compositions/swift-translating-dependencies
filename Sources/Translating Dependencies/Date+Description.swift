import Dependencies
public import Foundation
import Language
import Translated
public import Translated_String
import Translating_Platform

extension Date {
    public func description(
        dateStyle: DateFormatter.Style = .long,
        timeStyle: DateFormatter.Style = .none
    ) -> TranslatedString {
        @Dependency(\.language) var currentLanguage
        @Dependency(\.languages) var languages

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle

        let format: (Language) -> String = { language in
            dateFormatter.locale = language.locale
            return dateFormatter.string(from: self)
        }

        return .init(
            default: format(currentLanguage),
            dictionary: Dictionary(uniqueKeysWithValues: languages.map { ($0, format($0)) })
        )
    }
}

extension Date? {
    public func description(
        dateStyle: DateFormatter.Style = .long,
        timeStyle: DateFormatter.Style = .none
    ) -> TranslatedString {
        @Dependency(\.language) var currentLanguage
        @Dependency(\.languages) var languages

        let format: (Language) -> String = { language in
            switch (dateStyle, timeStyle) {
            case (.none, .none):
                guard let date = self else {
                    return Date.placeholder()(language)
                }
                return date.description(dateStyle: dateStyle, timeStyle: timeStyle)(language)

            case (.none, _):
                guard let date = self else {
                    return "__:__))"
                }
                return date.description(dateStyle: dateStyle, timeStyle: timeStyle)(language)

            default:
                guard let date = self else {
                    return Date.placeholder()(language)
                }
                return date.description(dateStyle: dateStyle, timeStyle: timeStyle)(language)
            }
        }

        return .init(
            default: format(currentLanguage),
            dictionary: Dictionary(uniqueKeysWithValues: languages.map { ($0, format($0)) })
        )
    }
}
