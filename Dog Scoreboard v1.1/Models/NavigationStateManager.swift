import SwiftUI
import Foundation

class NavigationStateManager: ObservableObject {
    @Published var selectedPath = [SelectionState]()
    
    // Navigate to the root of the navigation stack
    func popToRoot() {
        selectedPath = []
    }
    
    // Navigate to create a new event
    func createEvent(index: Int, event: Event) {
        popToRoot()
        selectedPath.append(SelectionState.createEvent(index, event))
    }
    
    func editEvent(index: Int, event: Event) {
        popToRoot()
        selectedPath.append(SelectionState.createEvent(index, event))
    }
    
    // Navigate to create a new dog evaluation
    func createDog(index: Int, dog: DogEvaluation) {
        popToRoot()
        selectedPath.append(SelectionState.createDog(index, dog))
    }
    
    // New function: Navigate to the current event's dog evaluations (DogListView)
    func goToCurrentEventDogs(event: Event) {
        popToRoot()
        selectedPath.append(SelectionState.dogEvaluations(event.dogEvaluations))
    }
    
    // Navigate back to the previous screen
    func popToPrevious() {
        if !selectedPath.isEmpty {
            selectedPath.removeLast()
        }
    }
    
    // Add a function to navigate to the drawing screen
    func createDrawingName(index: Int, drawing: Drawing) {
        popToRoot()
        selectedPath.append(SelectionState.createDrawingName(index, drawing))
    }
    
    func createDogDrawings(index: Int, drawings: [Drawing]) {
        popToRoot()
        selectedPath.append(SelectionState.createDogDrawings(index, drawings))
    }
    
//    func createDrawingName(_ drawing: Drawing) {
//        selectedPath.append(SelectionState.createDrawingName(drawing))
//    }
    
}

enum SelectionState: Hashable {
    case editEvent(Int,Event)
    case createEvent(Int, Event)
    case editDog(Int, DogEvaluation)
    case createDog(Int, DogEvaluation)
    case dogEvaluations([DogEvaluation])
    case createDogDrawing(Int, Drawing)  // New case for dog drawing
    case createDogDrawings(Int, [Drawing])  // New case for dog drawing
    case createDrawingName(Int, Drawing)  // New case for dog drawing
}
