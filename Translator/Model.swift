//
//  Models.swift
//  Translator
//
//  Created by jhshin on 11/4/24.
//

import Foundation

struct Root: Codable {
		let detectedLanguage: DetectedLanguage
		let translations: [Translations]
}

struct DetectedLanguage: Codable {
		let language: String
		let score: Double
}

struct Translations: Codable {
	let text: String
	let to: String
}
