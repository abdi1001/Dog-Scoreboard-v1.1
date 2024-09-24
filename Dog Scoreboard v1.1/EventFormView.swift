//
//  EventFormView.swift
//  Dog_Event_ScoreBoard
//
//  Created by abdifatah ahmed on 9/15/24.
//

import SwiftUI

struct EventFormView: View {
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var eventData: EventModel
    //var onSave: () -> Void  // Closure to handle saving the event
    
    var currentEvent: Event? {
        if eventData.events.indices.contains(eventData.currentEventIndex){
            return eventData.events[eventData.currentEventIndex]
        }
        return nil
    }

    var body: some View {
        guard currentEvent != nil else {
            return AnyView(
                VStack {
                    Text("No valid Event")
                        .foregroundColor(.red)
                    Button("Back to Event List") {
                        navigationStateManager.popToRoot()  // Navigate back to the event list
                    }
                    .padding()
                }
            )
        }
        return AnyView ( VStack {
            Text("Create New Event")
                .font(.headline)
                .padding()

            TextField("Event Name", text: $eventData.events[eventData.currentEventIndex].eventName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack{
                Button(action: {
                    //eventData.saveEvent()
                    navigationStateManager.popToRoot()
                }) {
                    Text("Save Event")
                        .foregroundColor(.white)
                        .padding()
                        .background(eventData.events[eventData.currentEventIndex].eventName.isEmpty ? Color.gray : Color.blue) // Change color if disabled
                        .cornerRadius(10)
                }
                .disabled(eventData.events[eventData.currentEventIndex].eventName.isEmpty)  // Disable if event name is blank
                
                Button(action: {
                    if eventData.events.indices.contains(eventData.currentEventIndex) {
                        // Remove the event at the current index
                        eventData.events.remove(at: eventData.currentEventIndex)
                        
                        // Adjust the currentEventIndex after deletion
                        if eventData.events.isEmpty {
                            eventData.currentEventIndex = 0  // Handle the case where there are no events left
                        } else {
                            eventData.currentEventIndex = max(0, eventData.currentEventIndex - 1)  // Move to the previous valid index
                        }
                        
                        navigationStateManager.popToRoot()
                    }
                }) {
                    Text("Delete Event")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }

 
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .padding()
                         )
    }
}

#Preview {
    EventFormView()
        .environmentObject(EventModel())
        .environmentObject(NavigationStateManager())
}
