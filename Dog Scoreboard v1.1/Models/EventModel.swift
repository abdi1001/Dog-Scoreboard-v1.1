import Foundation
import SwiftUI

class EventModel: ObservableObject {
    @Published var events: [Event] = [] {
        didSet {
            DispatchQueue.main.async {
                self.saveToFile()
            }
        }
    }
    @Published var currentEvent: Event = Event()
    @Published var currentEventIndex: Int = 0
    @Published var currentDogIndex: Int = 0
    @Published var currentDrawingIndex: Int = 0

    @Published var selectedColor: Color = .black

    
    let fileName = "eventsData.json"
    
    init() {
        loadFromFile()
    }
    
    
    
    
    
    func moveEvent(from source: IndexSet, to destination: Int) {
        guard !events.isEmpty else { return }  // Prevent moving if the array is empty
        
        // Ensure the destination index is within bounds
        //let validDestination = max(0, min(destination, events.count - 1))
        
        // Move the event if the source index and destination are valid
        events.move(fromOffsets: source, toOffset: destination)
    }


    
    
    
    func deleteEvent(at offsets: IndexSet) {
        guard !events.isEmpty else { return }  // Prevent deletion if the array is empty
        
        // Ensure that the offsets are valid before removing
        offsets.forEach { index in
            if index < events.count && index >= 0 {
                events.remove(at: index)
            } else {

            }
        }
        
        
    }

    
    func moveDog(from source: IndexSet, to destination: Int) {
        events[currentEventIndex].dogEvaluations.move(fromOffsets: source, toOffset: destination)

    }
    
    func deleteDog(at offsets: IndexSet, navigationStateManager: NavigationStateManager) {
        // Ensure the current event index is valid
        guard events.indices.contains(currentEventIndex) else { return }
        
        // Remove dog evaluations at the given offsets
        events[currentEventIndex].dogEvaluations.remove(atOffsets: offsets)
        
        // Check if there are any dog evaluations left
//        if events[currentEventIndex].dogEvaluations.isEmpty {
//            // Navigate back to the event list if no dog evaluations are left
//            navigationStateManager.editEvent(index: currentEventIndex, event: events[currentEventIndex])
//            return
//        }
        
        // Update currentDogIndex if it's out of bounds
        if currentDogIndex >= events[currentEventIndex].dogEvaluations.count {
            currentDogIndex = events[currentEventIndex].dogEvaluations.indices.last ?? 0
        }
    }


    
//    func saveEvent() {
//        if let index = events.firstIndex(where: { $0.id == currentEvent.id }) {
//            events[index] = currentEvent
//        } else {
//            events.append(currentEvent)
//        }
//    }
    
    
    func deleteCurrentEvaluation() {
        events[currentEventIndex].dogEvaluations.removeAll { $0.id == events[currentEventIndex].dogEvaluations[currentDogIndex].id }
        
        if currentDogIndex >= events[currentEventIndex].dogEvaluations.count {
            // If the current index is out of bounds, set it to the last valid index or reset to 0 if empty
            currentDogIndex = events[currentEventIndex].dogEvaluations.isEmpty ? 0 : events[currentEventIndex].dogEvaluations.count - 1
        }
        
    }
    
    // MARK: - File Handling
    
    // Save the events array to a JSON file in the documents directory
    func saveToFile() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(events)
            if let fileURL = getDocumentsDirectory()?.appendingPathComponent(fileName) {
                try data.write(to: fileURL)
            }
        } catch {
        }
    }
    
    // Load the events array from a JSON file in the documents directory
    func loadFromFile() {
        do {
            if let fileURL = getDocumentsDirectory()?.appendingPathComponent(fileName) {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                events = try decoder.decode([Event].self, from: data)
            }
        } catch {
        }
    }
    
    // Helper function to get the documents directory URL
    func getDocumentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    
    func isValidDrawingIndex() -> Bool {
        return events.indices.contains(currentEventIndex) &&
               events[currentEventIndex].dogEvaluations.indices.contains(currentDogIndex) &&
               events[currentEventIndex].dogEvaluations[currentDogIndex].drawings.indices.contains(currentDrawingIndex)
    }
    
    // Delete a drawing from the list
    func deleteDrawing(at offsets: IndexSet) {
        
        events[currentEventIndex].dogEvaluations[currentDogIndex].drawings.remove(atOffsets: offsets)
        
        if currentDrawingIndex >= events[currentEventIndex].dogEvaluations[currentDogIndex].drawings.count {
            currentDrawingIndex = events[currentEventIndex].dogEvaluations[currentDogIndex].drawings.indices.last ?? 0
        }
        

    }
    
    func moveDrawing(from source: IndexSet, to destination: Int) {

        events[currentEventIndex].dogEvaluations[currentDogIndex].drawings.move(fromOffsets: source, toOffset: destination)
        
        // Update currentDrawingIndex if needed
        if currentDrawingIndex >= events[currentEventIndex].dogEvaluations[currentDogIndex].drawings.count {
            currentDrawingIndex = events[currentEventIndex].dogEvaluations[currentDogIndex].drawings.indices.last ?? 0
        }
    }

}
