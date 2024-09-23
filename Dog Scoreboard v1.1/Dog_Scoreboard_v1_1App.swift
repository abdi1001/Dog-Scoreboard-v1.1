//
//  Dog_Event_ScoreBoardApp.swift
//  Dog_Event_ScoreBoard
//
//  Created by abdifatah ahmed on 9/15/24.
//

import SwiftUI

@main
struct Dog_Event_ScoreBoardApp: App {

    @StateObject var eventData = EventModel()  // This is the instance of EventModel
    @StateObject var navigationStateManager = NavigationStateManager()  // This is the instance of NavigationStateManager

    var body: some Scene {
        WindowGroup {
            EventListView()
                .environmentObject(eventData)  // Pass the instance of EventModel
                .environmentObject(navigationStateManager)  // Pass the instance of NavigationStateManager
        }
    }
}


