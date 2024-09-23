//
//  DrawingModel.swift
//  Dog_Event_ScoreBoard_Drawing
//
//  Created by abdifatah ahmed on 9/22/24.
//

import SwiftUI
import CoreGraphics

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}


// Define the Stroke and Drawing model with Codable conformance
struct Stroke: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var points: [CGPoint]
    var uiColor: UIColor
    var thickness: Double // Store the thickness of the stroke
    
    // Custom encoding for UIColor to support Codable
    enum CodingKeys: CodingKey {
        case id, points, colorData, thickness
    }

    init(points: [CGPoint], uiColor: UIColor, thickness: Double) {
        self.points = points
        self.uiColor = uiColor
        self.thickness = thickness
    }

    // Encoding UIColor as data
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(points, forKey: .points)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .colorData)
        try container.encode(thickness, forKey: .thickness)
    }

    // Decoding UIColor from data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        points = try container.decode([CGPoint].self, forKey: .points)
        let colorData = try container.decode(Data.self, forKey: .colorData)
        thickness = try container.decode(Double.self, forKey: .thickness)
        if let decodedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            uiColor = decodedColor
        } else {
            uiColor = .black // Default color in case decoding fails
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(points)
        hasher.combine(thickness)
        hasher.combine(uiColor.cgColor)  // Use `cgColor` for hashing
    }

    static func == (lhs: Stroke, rhs: Stroke) -> Bool {
        return lhs.id == rhs.id &&
               lhs.points == rhs.points &&
               lhs.thickness == rhs.thickness &&
               lhs.uiColor.isEqual(rhs.uiColor)  // Use isEqual for UIColor comparison
    }
}

struct Drawing: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var name: String // Drawing name
    var strokes: [Stroke] = []
    var selectedColor: Color
    var brushThickness: Double = 2.0
    
    init(name: String, selectedColor: Color = .black) {
        self.name = name
        self.selectedColor = selectedColor
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case strokes
        case selectedColor
        case brushThickness
    }
    
    // Custom Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(strokes, forKey: .strokes)
        try container.encode(brushThickness, forKey: .brushThickness)
        
        // Encode selectedColor as RGB components
        let colorComponents = selectedColor.cgColor?.components ?? [0, 0, 0]
        try container.encode(colorComponents, forKey: .selectedColor)
    }
    
    // Custom Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        strokes = try container.decode([Stroke].self, forKey: .strokes)
        brushThickness = try container.decode(Double.self, forKey: .brushThickness)
        
        // Decode the color components and recreate the Color object
        let colorComponents = try container.decode([CGFloat].self, forKey: .selectedColor)
        selectedColor = Color(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2])
    }
}

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)  // Adds a slight animation on press
            .opacity(configuration.isPressed ? 0.8 : 1.0)      // Adjust opacity when pressed
    }
}
