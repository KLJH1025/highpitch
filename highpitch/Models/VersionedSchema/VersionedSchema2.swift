//
//  VersionedSchema2.swift
//  highpitch
//
//  Created by 이재혁 on 11/16/23.
//

import SwiftUI
import SwiftData

enum VersionedSchema2: VersionedSchema {
    static var versionIdentifier: Schema.Version = .init(0, 0, 2)
    
    static var models: [any PersistentModel.Type] {
        [ProjectModel.self, PracticeModel.self, UtteranceModel.self, WordModel.self, SentenceModel.self, PracticeSummaryModel.self, FillerWordModel.self]
    }

    @Model
    class ProjectModel {
        var projectName: String
        var creatAt: String
        var keynotePath: URL?
        var keynoteCreation: String 
        @Relationship(deleteRule: .cascade)
        var practices = [PracticeModel]()
        
        init(projectName: String, creatAt: String, keynotePath: URL? = nil, keynoteCreation: String) {
            self.projectName = projectName
            self.creatAt = creatAt
            self.keynotePath = keynotePath
            self.keynoteCreation = keynoteCreation
        }
    }
    
    // [Version1과 다른 점]
    // +) remarkable: Bool
    // +) projectID: UUID
    @Model
    class PracticeModel: Comparable {
        var practiceName: String
        var index: Int
        var isVisited: Bool
        var creatAt: String
        var audioPath: URL?
        @Relationship(deleteRule: .cascade)
        var utterances: [UtteranceModel]
        @Relationship(deleteRule: .cascade)
        var words: [WordModel]
        @Relationship(deleteRule: .cascade)
        var sentences: [SentenceModel]
        @Relationship(deleteRule: .cascade)
        var summary: PracticeSummaryModel
        var remarkable: Bool
        var projectID: UUID
        
        init(
            practiceName: String,
            index: Int,
            isVisited: Bool,
            creatAt: String,
            audioPath: URL? = nil,
            utterances: [UtteranceModel],
            words: [WordModel] = [],
            sentences: [SentenceModel] = [],
            summary: PracticeSummaryModel,
            remarkable: Bool,
            projectID: UUID
        ) {
            self.practiceName = practiceName
            self.index = index
            self.isVisited = isVisited
            self.creatAt = creatAt
            self.audioPath = audioPath
            self.utterances = utterances
            self.words = words
            self.sentences = sentences
            self.summary = summary
            self.remarkable = remarkable
            self.projectID = projectID
        }
        
        static func < (lhs: PracticeModel, rhs: PracticeModel) -> Bool {
            return lhs.creatAt < rhs.creatAt
        }

        static func == (lhs: PracticeModel, rhs: PracticeModel) -> Bool {
            return lhs.creatAt == rhs.creatAt
        }
    }

    @Model
    class UtteranceModel: Comparable {
        var startAt: Int
        var duration: Int
        var message: String
        
        init(startAt: Int, duration: Int, message: String) {
            self.startAt = startAt
            self.duration = duration
            self.message = message
        }
        
        static func < (lhs: UtteranceModel, rhs: UtteranceModel) -> Bool {
            return lhs.startAt < rhs.startAt
        }

        static func == (lhs: UtteranceModel, rhs: UtteranceModel) -> Bool {
            return lhs.startAt == rhs.startAt
        }
    }
    
    @Model
    class WordModel {
        var isFillerWord: Bool
        var sentenceIndex: Int
        var index: Int
        var word: String
        
        init(isFillerWord: Bool, sentenceIndex: Int, index: Int, word: String) {
            self.isFillerWord = isFillerWord
            self.sentenceIndex = sentenceIndex
            self.index = index
            self.word = word
        }
    }

    // [Version1과 다른 점]
    // -) empValue
    // ---------------------
    // +) remarkable: Bool
    // +) projectID: UUID
    @Model
    class SentenceModel {
        var index: Int
        var sentence: String
        var startAt: Int
        var endAt: Int
        var spmValue: Double
        var fastOrSlow: Int
        
        init(index: Int, sentence: String, startAt: Int = -1, endAt: Int = -1, spmValue: Double = -1.0, fastOrSlow: Int) {
            self.index = index
            self.spmValue = spmValue
            self.sentence = sentence
            self.startAt = startAt
            self.endAt = endAt
            self.fastOrSlow = fastOrSlow
        }
    }

    // [Version1과 다른점]
    // -) fillerWordPercentage
    // -) level
    // -) empAverage
    // -------------------
    // +) practiceLength: Double
    // +) fwpm: Double
    // +) spmAverage: Double
    @Model
    class PracticeSummaryModel {
        var syllableSum: Int
        var durationSum: Int
        var wordCount: Int
        var fillerWordCount: Int
        @Relationship(deleteRule: .cascade)
        var eachFillerWordCount: [FillerWordModel]
        var fastSentenceIndex: [Int]
        var slowSentenceIndex: [Int]
        var practiceLength: Double
        var spmAverage: Double
        var fwpm: Double
        
        init(
            syllableSum: Int = 0,
            durationSum: Int = 0,
            wordCount: Int = 0,
            fillerWordCount: Int = 0,
            eachFillerWordCount: [FillerWordModel] = [],
            fastSentenceIndex: [Int] = [],
            slowSentenceIndex: [Int] = [],
            practiceLength: Double = -1.0,
            spmAverage: Double = -1.0,
            fwpm: Double = -1.0
        ) {
            self.syllableSum = syllableSum
            self.durationSum = durationSum
            self.wordCount = wordCount
            self.fillerWordCount = fillerWordCount
            self.eachFillerWordCount = eachFillerWordCount
            self.fastSentenceIndex = fastSentenceIndex
            self.slowSentenceIndex = slowSentenceIndex
            self.practiceLength = practiceLength
            self.spmAverage = spmAverage
            self.fwpm = fwpm
        }
    }

    @Model
    class FillerWordModel {
        var fillerWord: String
        var count: Int
        
        init(fillerWord: String, count: Int = 0) {
            self.fillerWord = fillerWord
            self.count = count
        }
    }

}