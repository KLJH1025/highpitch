//
//  PracticeSummaryModel.swift
//  highpitch
//
//  Created by 이용준의 Macbook on 10/19/23.
//

import Foundation
import SwiftData

@Model
class PracticeSummaryModel {
    var syllableSum: Int
    var durationSum: Int
    var wordCount: Int
    var fillerWordCount: Int
    @Relationship(deleteRule: .cascade) var eachFillerWordCount: [FillerWordModel]
    var fastSentenceIndex: [Int]
    var slowSentenceIndex: [Int]
    var fillerWordPercentage: Double
    var epmAverage: Double
    var level: Double
    
    init(
        syllableSum: Int = 0,
        durationSum: Int = 0,
        wordCount: Int = 0,
        fillerWordCount: Int = 0,
        eachFillerWordCount: [FillerWordModel] = [],
        fastSentenceIndex: [Int] = [],
        slowSentenceIndex: [Int] = [],
        fillerWordPercentage: Double = -1.0,
        epmAverage: Double = -1.0,
        level: Double = -1.0
    ) {
        self.syllableSum = syllableSum
        self.durationSum = durationSum
        self.wordCount = wordCount
        self.fillerWordCount = fillerWordCount
        self.eachFillerWordCount = eachFillerWordCount
        self.fastSentenceIndex = fastSentenceIndex
        self.slowSentenceIndex = slowSentenceIndex
        self.fillerWordPercentage = fillerWordPercentage
        self.epmAverage = epmAverage
        self.level = level
    }
}
