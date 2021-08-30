//
//  NotificationsView.swift
//  InstagramClone
//
//  Created by Reed Kellett on 4/29/21.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var viewModel = NotificationsViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.notifications) { notification in
                    LazyView(NotificationCell(viewModel: NotificationCellViewModel(notification: notification)))
                        .padding(.top)
                }
            }
        }
    }
}
