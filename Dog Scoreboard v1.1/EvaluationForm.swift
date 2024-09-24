import SwiftUI

struct EvaluationForm: View {
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var eventData: EventModel
    @State var defaultNilRow: [Double?] = [nil, nil, nil, nil]
    @State private var showDeleteAlert = false  // State to control the alert

    // Computed property that safely accesses the current dog evaluation
    var currentDogEvaluation: DogEvaluation? {
        if eventData.events.indices.contains(eventData.currentEventIndex),
           eventData.events[eventData.currentEventIndex].dogEvaluations.indices.contains(eventData.currentDogIndex) {
            return eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex]
        }
        return nil
    }

    var totalScore: Double {
        guard let dogEvaluation = currentDogEvaluation else { return 0.0 }
        let allSeries = [
            dogEvaluation.markingSeries, dogEvaluation.markingStyle, dogEvaluation.markingPerseverance, dogEvaluation.markingTrainability,
            dogEvaluation.blindStyle, dogEvaluation.blindPerseverance, dogEvaluation.blindTrainability
        ]
        return allSeries.flatMap { $0.compactMap { $0 } }.reduce(0, +)
    }

    var overallAverage: Double {
        guard let dogEvaluation = currentDogEvaluation else { return 0.0 }
        let allSeries = [
            dogEvaluation.markingSeries, dogEvaluation.markingStyle, dogEvaluation.markingPerseverance, dogEvaluation.markingTrainability,
            dogEvaluation.blindStyle, dogEvaluation.blindPerseverance, dogEvaluation.blindTrainability
        ]
        let averages = allSeries.compactMap { calculateAverage(series: $0) }
        guard !averages.isEmpty else { return 0.0 }
        return averages.reduce(0, +) / Double(averages.count)
    }

    func calculateAverage(series: [Double?]) -> Double? {
        let filteredValues = series.compactMap { $0 }
        guard !filteredValues.isEmpty else { return nil }
        return Double(filteredValues.reduce(0, +)) / Double(filteredValues.count)
    }

    var body: some View {
        // Early exit if the current dog evaluation is invalid
        guard currentDogEvaluation != nil else {
            return AnyView(
                VStack {
                    Text("No valid dog evaluation available")
                        .foregroundColor(.red)
                    Button("Back to Event List") {
                        navigationStateManager.popToRoot()  // Navigate back to the event list
                    }
                    .padding()
                }
            )
        }

        // Main UI body if the dog evaluation is valid
        return AnyView(
            ScrollView {
                VStack(spacing: 20) {
                    Text("Dog Test Evaluation Form")
                        .font(.title)
                        .padding(.top)

                    // Dog Name and Dog Number Inputs
                    VStack(spacing: 15) {
                        HStack {
                            Text("Dog Name:")
                                .frame(width: 100, alignment: .leading)
                            TextField("Enter Dog Name", text: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].dogName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                        }

                        HStack {
                            Text("Dog #:")
                                .frame(width: 100, alignment: .leading)
                            TextField("Enter Dog #", text: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].dogNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: .infinity)
                        }

                        // Test Level Picker
                        Picker("Test Level", selection: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].testLevel) {
                            Text("JR").tag(1)
                            Text("SR").tag(2)
                            Text("MR").tag(3)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)

                    // Marking Series Section
                    VStack(spacing: 5) {
                        Text("Marking Series")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing)
                        DefaultEvaluationRow(title: "Default Entire Series", values: $defaultNilRow)

                        HStack {
                            Spacer().frame(width: UIScreen.main.bounds.width * 0.25)
                            ForEach(0..<4) { i in
                                Text("Series \(i + 1)")
                                    .frame(width: UIScreen.main.bounds.width * 0.12, alignment: .center)
                            }
                            Text("Average")
                                .frame(width: UIScreen.main.bounds.width * 0.12, alignment: .center)
                        }

                        EvaluationRow(title: "Marking (Memory)", values: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].markingSeries)
                        EvaluationRow(title: "Style", values: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].markingStyle)
                        EvaluationRow(title: "Perseverance", values: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].markingPerseverance)
                        EvaluationRow(title: "Trainability", values: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].markingTrainability)
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                    // Blind Series Section
                    VStack(spacing: 5) {
                        Text("Blind Series")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing)

                        HStack {
                            Spacer().frame(width: UIScreen.main.bounds.width * 0.25)
                            ForEach(0..<4) { i in
                                Text("Series \(i + 1)")
                                    .frame(width: UIScreen.main.bounds.width * 0.12, alignment: .center)
                            }
                            Text("Average")
                                .frame(width: UIScreen.main.bounds.width * 0.12, alignment: .center)
                        }
                        EvaluationRow(title: "Style", values: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].blindStyle)
                        EvaluationRow(title: "Perseverance", values: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].blindPerseverance)
                        EvaluationRow(title: "Trainability", values: $eventData.events[eventData.currentEventIndex].dogEvaluations[eventData.currentDogIndex].blindTrainability)

                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                    // Total Score and Overall Average
                    VStack(spacing: 5) {
                        Text("Total Score: \(totalScore, specifier: "%.1f")")
                            .font(.title2)
                        Text("Overall Average: \(overallAverage, specifier: "%.1f")")
                            .font(.title2)
                            .padding(.top, 5)
                    }
                    .padding(.horizontal)

                    // Buttons for Save and Delete
                    HStack {
                        Button(action: {
                            showDeleteAlert = true  // Trigger the delete alert
                        }) {
                            Text("Delete")
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }            // Apply the reusable delete confirmation alert
                        .deleteConfirmation(showAlert: $showDeleteAlert, message: "Are you sure you want to delete this evaluation?") {
                            eventData.deleteCurrentEvaluation()
                            navigationStateManager.goToCurrentEventDogs(event: eventData.currentEvent)
                        }
//                        Button(action: {
//  
//   
//                            navigationStateManager.goToCurrentEventDogs(event: eventData.events[eventData.currentEventIndex])
//                        }) {
//                            Text("Save")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.blue)
//                                .cornerRadius(10)
//                        }
                    }
                    .padding(.horizontal)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            navigationStateManager.goToCurrentEventDogs(event: eventData.events[eventData.currentEventIndex])
                        }) {
                            Label("Go back", systemImage: "arrowshape.backward.fill")
                        }
                    }
                }
            }.navigationBarBackButtonHidden(true)

        )
    }
}

#Preview {
    EvaluationForm()
        .environmentObject(EventModel())
        .environmentObject(NavigationStateManager())
}
