//
//  ScheduleLiveActivity.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 10/05/2023.
//  Copyright © 2023 TrucPham. All rights reserved.
//

import Foundation
import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)

@available(iOS 16.1, *)
struct ScheduleLiveActivity : Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScheduleAttributes.self) { context in
            VStack {
                Text(context.state.name)
            }
        } dynamicIsland: { context in
            // Create the presentations that appear in the Dynamic Island.
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.name)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.name)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.name)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.name)
                }
            } compactLeading: {
                Text("compactLeading")
            } compactTrailing: {
                Text("compactLeading")
            } minimal: {
                Text("compactLeading")
            }
            .keylineTint(.cyan)
        }
        
        
    }
}
