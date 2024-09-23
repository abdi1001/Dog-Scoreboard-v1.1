//
//  DrawingNamePromptView.swift
//  Dog_Event_ScoreBoard_Drawing
//
//  Created by abdifatah ahmed on 9/22/24.
//

import SwiftUI

struct DrawingNamePromptView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var eventData: EventModel
    
    var onCancel: () -> Void
    var onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Drawing Name")
                .font(.headline)

            if eventData.events.indices.contains(eventData.currentEventIndex),
               eventData.events[eventData.currentEventIndex].dogEvaluations.indices.contains(eventData.currentDogIndex),
               eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings.indices.contains(eventData.currentDrawingIndex) {

                TextField("Drawing Name", text: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else {
                TextField("Drawing Name", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            HStack {
//                Button("Cancel") {
//                    onCancel()
//                    navigationStateManager.createDogDrawings(index: eventData.currentDogIndex, drawings: eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings)
////                }
//                .padding(.horizontal)
                
                Button(action: {
                    //eventData.saveEvent()
                    onConfirm()
                    navigationStateManager.createDogDrawings(index: eventData.currentDogIndex, drawings: eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings)
                }) {
                    Text("Save Drawing")
                        .foregroundColor(.white)
                        .padding()
                        .background(eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].name.isEmpty ? Color.gray : Color.blue) // Change color if disabled
                        .cornerRadius(10)
                }
                .disabled(eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].name.isEmpty)  // Disable if event name is blank

//                Button("OK") {
//                    onConfirm()
//                    navigationStateManager.createDogDrawings(index: eventData.currentDogIndex, drawings: eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings)
//                }
//                .disabled(eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].name.isEmpty)
                .padding(.horizontal)
            }
        }
        .padding()
        .frame(maxWidth: 300)
    }
}

//#Preview {
//    DrawingNamePromptView()
//}
