//
//  EvaluationRow.swift
//  Dog_Event_ScoreBoard
//
//  Created by abdifatah ahmed on 9/15/24.
//

import SwiftUI

struct EvaluationRow: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var eventData: EventModel
    var title: String
    @Binding var values: [Double?]
    
    var body: some View {
        HStack {
            Text(title)
                .frame(width: UIScreen.main.bounds.width * 0.25, alignment: .leading)
            ForEach(0..<4) { i in
                Picker("Select", selection: $values[i]) {
                    Text("").tag(Optional<Double>.none)  // Blank option
                    ForEach(Array(stride(from: 10.0, through: 0.0, by: -0.5)), id: \.self) { value in
                        Text("\(value, specifier: "%.1f")").tag(Optional(value))
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.12)
                .pickerStyle(MenuPickerStyle())
            }
            if let average = calculateAverage() {
                Text("\(average, specifier: "%.1f")")
                    .frame(width: UIScreen.main.bounds.width * 0.12, alignment: .center)
            } else {
                Text("")
                    .frame(width: UIScreen.main.bounds.width * 0.12, alignment: .center)
            }
        }
    }
    
    func calculateAverage() -> Double? {
        let filteredValues = values.compactMap { $0 }
        guard !filteredValues.isEmpty else { return nil }
        return Double(filteredValues.reduce(0, +)) / Double(filteredValues.count)
    }
}

//#Preview {
//    EvaluationRow(title: "Series", values: Binding([1.5,1.5,1.5,1.5]))
//        .environmentObject(EventModel())  // Pass mock EventModel
//        .environmentObject(NavigationStateManager())  // Pass NavigationStateManager if needed
//}
