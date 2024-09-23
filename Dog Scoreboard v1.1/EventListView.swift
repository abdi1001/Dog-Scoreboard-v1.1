import SwiftUI

struct EventListView: View {

    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var eventData: EventModel
    
    var body: some View {
        
            NavigationStack(path: $navigationStateManager.selectedPath) {
                VStack{
                    if !eventData.events.isEmpty {
                        List {
                            ForEach(Array(eventData.events.enumerated()), id: \.element.id) { index, event in
                                NavigationLink(value: SelectionState.editEvent(index, event)) {
                                    HStack {
                                        VStack {
                                            Text(event.eventName)
                                        }
                                        Spacer()
                                        Button(action: {
                                            navigationStateManager.createEvent(index: index, event: event)
                                            
                                        }) {
                                            Text("Edit Name")
                                                .font(.system(size: 14, weight: .bold))  // Custom font size and weight
                                                .foregroundColor(.white)  // Text color
                                                .padding(.vertical, 8)  // Vertical padding
                                                .padding(.horizontal, 16)  // Horizontal padding
                                                .background(Color.blue)  // Button background color
                                                .cornerRadius(8)  // Rounded corners
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                //.contentShape(Rectangle())
                            }
                            .onMove(perform: eventData.moveEvent)
                            .onDelete(perform: eventData.deleteEvent)
                        }
                    }else {
                        VStack {
                            Text("No events available")
                                .foregroundColor(.gray)
                                .font(.headline)
                                .padding()
                            Spacer()
                        }
                    }
                }
                .navigationTitle("All Event")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()  // Wrap EditButton in closure
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            let newEvent = Event()
                            eventData.events.append(newEvent)
                            //eventData.events[] = newEvent
                            
                            if let newEventIndex = eventData.events.firstIndex(of: newEvent) {
                                eventData.currentEventIndex = newEventIndex
                                navigationStateManager.createEvent(index: newEventIndex, event: newEvent)
                                //SelectionState.createEvent(newEventIndex, newEvent)
                            }
                            

                        }) {
                            Label("Add Event", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: SelectionState.self) { state in
                    switch state {
                    case .createEvent(let index, _):
                        EventFormView().onAppear {
                            if index == -1 {
                                let indexcount = eventData.events.indices.last ?? 0
                                eventData.currentEventIndex = indexcount
                                //eventData.currentEvent = newEvent
                            } else {
                                eventData.currentEventIndex = index
                                //eventData.currentEvent = newEvent
                            }

                        }
                        //                case .allDogs(let allDogs):
                        //                    DogListView().onAppear {
                        //                        eventData.currentDogEvaluations = eventData.currentEvent.dogEvaluations
                        //                        eventData.currentEvent.dogEvaluations = allDogs
                        //                    }
                    case .editEvent(let index, _):
                        
                        DogListView().onAppear{
                            eventData.currentEventIndex = index
                        }
                    case .createDog(let index, _):
                        EvaluationForm().onAppear {
                            eventData.currentDogIndex = index

                        }
                    case .editDog(let index, _):
                        EvaluationForm().onAppear {
                            eventData.currentDogIndex = index

                        }
                    case .createDrawingName(let index, _):
                        DrawingNamePromptView( onCancel: {

                        }, onConfirm: {

                        }) .onAppear {

                            eventData.currentDrawingIndex = index
                        }
                    case .dogEvaluations(_):
                        DogListView().onAppear {
                            //eventData.events[eventData.currentEventIndex].dogEvaluations = dogEvaluations
                            //eventData.currentEvent.dogEvaluations = dogEvaluations
                        }
                    case .createDogDrawing(let index, _):
                        DrawingCanvasView()
                            .onAppear {
                                eventData.currentDrawingIndex = index
                               
                        }
                    case .createDogDrawings(let index, _):
                        DrawingApp().onAppear {
                            eventData.currentDogIndex = index
                            //eventData.currentDrawingIndex = index
                        }
                        
                        
                        // Return the DrawingCanvasView and handle the logic in `onAppear`
    //                    DrawingCanvasView(drawing: .constant(Drawing(name: "New Drawing")), selectedColor: .constant(.black))

                    }

                    
                }

        }

    }
}

//#Preview {
//    return NavigationStack {
//        EventListView()
//    }  .environmentObject(EventModel())  // Pass mock EventModel
//        .environmentObject(NavigationStateManager())
//}
