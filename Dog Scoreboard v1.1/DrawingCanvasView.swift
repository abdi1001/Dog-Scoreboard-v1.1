//
//  DrawingCanvasView.swift
//  Dog_Event_ScoreBoard_Drawing
//
//  Created by abdifatah ahmed on 9/22/24.
//

import SwiftUI

struct DrawingCanvasView: View {
    @EnvironmentObject var eventData: EventModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager

    //@State var selectedColor: Color
    @State private var currentStroke: [CGPoint] = []
    //@State private var brushThickness: Double = 2.0
    @State private var showDeleteAlert = false  // State to control the alert

    var body: some View {
        VStack {
            // Canvas for drawing
            Canvas { context, size in
                if eventData.isValidDrawingIndex() {
                    for stroke in eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].strokes {
                        var path = Path()
                        for (index, point) in stroke.points.enumerated() {
                            if index == 0 {
                                path.move(to: point)
                            } else {
                                path.addLine(to: point)
                            }
                        }
                        context.stroke(path, with: .color(Color(stroke.uiColor)), lineWidth: stroke.thickness)
                    }
                } else {
                    // Handle the case where the index is invalid (e.g., show an error or placeholder)
                    VStack {
                        Text("No valid drawing available")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                // Draw completed strokes


                // Draw the current in-progress stroke
                var currentPath = Path()
                for (index, point) in currentStroke.enumerated() {
                    if index == 0 {
                        currentPath.move(to: point)
                    } else {
                        currentPath.addLine(to: point)
                    }
                }
                context.stroke(currentPath, with: .color(eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].selectedColor), lineWidth: eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].brushThickness)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        currentStroke.append(value.location)
                    }
                    .onEnded { _ in
                        let newStroke = Stroke(points: currentStroke, uiColor: UIColor(eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].selectedColor), thickness: eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].brushThickness)
                        eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].strokes.append(newStroke)
                        currentStroke = [] // Clear current stroke after saving
                    }
            )
            .background(Color.white)
            .border(Color.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Tool controls: Color picker and brush thickness
            HStack {
                ColorPicker("Select Color", selection: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].selectedColor)
                    .padding()

                VStack {
                    Text("Brush Thickness: \(Int(eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].brushThickness))")
                    Slider(value: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].brushThickness, in: 1...20, step: 1)
                        .padding()
                }
            }
            
            // Control buttons for Undo, Clear, Save, and Delete
            HStack {
                Button("Undo") {
                    if !eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].strokes.isEmpty {
                        eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].strokes.removeLast()
                    }
                }
                .padding()

                Button("Clear") {
                    eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].strokes.removeAll()
                }
                .padding()

                // Delete Button
                
                Button {
                    showDeleteAlert = true  // Trigger the delete alert
                } label: {
                    Text("Delete")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }            // Apply the reusable delete confirmation alert
                .deleteConfirmation(showAlert: $showDeleteAlert, message: "Are you sure you want to delete this drawing?") {
                    if let index = eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings.firstIndex(where: { $0.id == eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].id }) {
                        eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings.remove(at: index)
                        //eventData.saveEvent()
                        navigationStateManager.createDogDrawings(index: eventData.currentDogIndex, drawings: eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings)
                    }
                }

                

                .foregroundColor(.red)
                .padding()

   
            }
        }
        .padding()
        .navigationTitle(drawingTitle)
        .navigationBarBackButtonHidden(false)
    }
    
    var drawingTitle: String {
        if eventData.isValidDrawingIndex() {
            return eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings[eventData.currentDrawingIndex].name
        } else {
            return "Drawing"
        }
    }
}

//#Preview {
//    DrawingCanvasView()
//}
