//
//  Modules.swift
//  Dog_Event_ScoreBoard
//
//  Created by abdifatah ahmed on 9/15/24.
//

import Foundation


struct DogEvaluation: Identifiable, Hashable, Codable, Equatable {
    var id = UUID()  // Unique identifier for each DogEvaluation
    var dogName: String = ""
    var dogNumber: String = ""
    var testLevel: Int = 1  // Default to JR
    var markingSeries: [Double?] = Array(repeating: nil, count: 4)
    var markingStyle: [Double?] = Array(repeating: nil, count: 4)
    var markingPerseverance: [Double?] = Array(repeating: nil, count: 4)
    var markingTrainability: [Double?] = Array(repeating: nil, count: 4)
    var blindStyle: [Double?] = Array(repeating: nil, count: 4)
    var blindPerseverance: [Double?] = Array(repeating: nil, count: 4)
    var blindTrainability: [Double?] = Array(repeating: nil, count: 4)
    var drawings: [Drawing] = []
    
    init(dogName: String, dogNumber: String, testLevel: Int, markingSeries: [Double?], markingStyle: [Double?], markingPerseverance: [Double?], markingTrainability: [Double?], blindStyle: [Double?], blindPerseverance: [Double?], blindTrainability: [Double?]) {
        self.id = UUID()
        self.dogName = dogName
        self.dogNumber = dogNumber
        self.testLevel = testLevel
        self.markingSeries = markingSeries
        self.markingStyle = markingStyle
        self.markingPerseverance = markingPerseverance
        self.markingTrainability = markingTrainability
        self.blindStyle = blindStyle
        self.blindPerseverance = blindPerseverance
        self.blindTrainability = blindTrainability
    }
    
    init() {
        self.id = UUID()
        self.dogName = ""
        self.dogNumber = ""
        self.testLevel = 1
        self.markingSeries = Array(repeating: nil, count: 4)
        self.markingStyle = Array(repeating: nil, count: 4)
        self.markingPerseverance = Array(repeating: nil, count: 4)
        self.markingTrainability = Array(repeating: nil, count: 4)
        self.blindStyle = Array(repeating: nil, count: 4)
        self.blindPerseverance = Array(repeating: nil, count: 4)
        self.blindTrainability = Array(repeating: nil, count: 4)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dogName)
        hasher.combine(dogNumber)
        hasher.combine(testLevel)
        hasher.combine(markingSeries.compactMap { $0 })  // Flatten optionals
        hasher.combine(markingStyle.compactMap { $0 })
        hasher.combine(markingPerseverance.compactMap { $0 })
        hasher.combine(markingTrainability.compactMap { $0 })
        hasher.combine(blindStyle.compactMap { $0 })
        hasher.combine(blindPerseverance.compactMap { $0 })
        hasher.combine(blindTrainability.compactMap { $0 })
        hasher.combine(drawings)  // Drawings are Hashable
    }

    static func == (lhs: DogEvaluation, rhs: DogEvaluation) -> Bool {
        return lhs.id == rhs.id &&
               lhs.dogName == rhs.dogName &&
               lhs.dogNumber == rhs.dogNumber &&
               lhs.testLevel == rhs.testLevel &&
               lhs.markingSeries.elementsEqual(rhs.markingSeries, by: { $0 == $1 }) &&
               lhs.markingStyle.elementsEqual(rhs.markingStyle, by: { $0 == $1 }) &&
               lhs.markingPerseverance.elementsEqual(rhs.markingPerseverance, by: { $0 == $1 }) &&
               lhs.markingTrainability.elementsEqual(rhs.markingTrainability, by: { $0 == $1 }) &&
               lhs.blindStyle.elementsEqual(rhs.blindStyle, by: { $0 == $1 }) &&
               lhs.blindPerseverance.elementsEqual(rhs.blindPerseverance, by: { $0 == $1 }) &&
               lhs.blindTrainability.elementsEqual(rhs.blindTrainability, by: { $0 == $1 }) &&
               lhs.drawings == rhs.drawings
    }
}



struct Event: Identifiable, Hashable, Codable {
    var id = UUID()  // Unique identifier for each DogEvaluation
    var eventName: String = ""
    var dogEvaluations: [DogEvaluation]
    
    init() {
        self.id = UUID()
        self.eventName = ""
        self.dogEvaluations = []
    }
    
    init(eventName: String, dogEvaluations: [DogEvaluation]) {
        self.id = UUID()
        self.eventName = eventName
        self.dogEvaluations = dogEvaluations
    }
    
}



