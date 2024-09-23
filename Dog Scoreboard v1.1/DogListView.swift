//
//  DogListView.swift
//  Dog_Event_ScoreBoard
//
//  Created by abdifatah ahmed on 9/15/24.
//

import SwiftUI

struct DogListView: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var eventData: EventModel
    
    var currentDogEvaluation: [DogEvaluation]? {
        if eventData.events.indices.contains(eventData.currentEventIndex),
           eventData.events[eventData.currentEventIndex].dogEvaluations.indices.contains(eventData.currentDogIndex) {
            return eventData.events[eventData.currentEventIndex].dogEvaluations
        }
        return nil
    }
    
    
    var body: some View {
        VStack {
        if eventData.events.indices.contains(eventData.currentEventIndex) &&
            !eventData.events[eventData.currentEventIndex].dogEvaluations.isEmpty {
            List {
                ForEach(Array(eventData.events[eventData.currentEventIndex].dogEvaluations.enumerated()), id: \.element) { dogIndex, dogEval in
                    NavigationLink(value: SelectionState.editDog(dogIndex, dogEval)
                    ) {
                        HStack {
                            VStack {
                                Text(dogEval.dogName)
                                Text("Dog #: \(dogEval.dogNumber)").font(.subheadline).foregroundColor(.gray)
                            }
                            Spacer()
                            
                            Button(action: {
                                eventData.currentDogIndex = dogIndex
                                navigationStateManager.createDogDrawings(index: eventData.currentDogIndex, drawings: eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].drawings)
                            }) {
                                Text("Draw Evaluation")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .contentShape(Rectangle())
                }
                .onMove(perform: eventData.moveDog)
                .onDelete {offsets in
                    eventData.deleteDog(at: offsets, navigationStateManager: navigationStateManager) }
            }
        } else {
            VStack {
                Text("No dogs in this event")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding()
                Spacer()
            }
        }
    }.navigationTitle(
        eventData.events.indices.contains(eventData.currentEventIndex)
        ? "Dogs in Event \(eventData.events[eventData.currentEventIndex].eventName)"
        : "No valid event"
    )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        let newDog = DogEvaluation()
                        eventData.events[eventData.currentEventIndex].dogEvaluations.append(newDog)
                        if let newDogIndex = eventData.events[eventData.currentEventIndex].dogEvaluations.firstIndex(where: { $0.id == newDog.id }) {
                            eventData.currentDogIndex = newDogIndex
                            navigationStateManager.createDog(index: newDogIndex, dog: newDog)
                        }

                    }, label: {
                        Label("Add Dog", systemImage: "plus")
                    })
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        navigationStateManager.popToRoot()
                    }, label: {
                        Label("Add Dog", systemImage: "arrowshape.backward.fill")
                    })
                }
            }
            .navigationBarBackButtonHidden(true)  // Hide default back button
        }
       
}


#Preview {
    NavigationStack{
        DogListView()
            .environmentObject(EventModel())  // Pass mock EventModel
            .environmentObject(NavigationStateManager())  // Pass NavigationStateManager if needed
    }

}
