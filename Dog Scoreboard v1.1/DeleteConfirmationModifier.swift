//
//  DeleteConfirmationModifier.swift
//  Dog_Event_ScoreBoard_Drawing
//
//  Created by abdifatah ahmed on 9/22/24.
//

import SwiftUI

struct DeleteConfirmationModifier: ViewModifier {
    @Binding var showAlert: Bool
    let message: String
    let confirmAction: () -> Void

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text(message),
                    primaryButton: .destructive(Text("Delete")) {
                        confirmAction()  // Call the delete action
                    },
                    secondaryButton: .cancel()
                )
            }
    }
}

extension View {
    func deleteConfirmation(showAlert: Binding<Bool>, message: String, confirmAction: @escaping () -> Void) -> some View {
        self.modifier(DeleteConfirmationModifier(showAlert: showAlert, message: message, confirmAction: confirmAction))
    }
}


//#Preview {
//    DeleteConfirmationModifier()
//}
