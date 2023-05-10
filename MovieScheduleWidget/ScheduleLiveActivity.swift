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
struct ScheduleAttributes : ActivityAttributes {
    public struct ContentState : Codable, Hashable {
        
    }
    var name : String
}
@available(iOS 16.1, *)
struct ScheduleLiveActivity : Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScheduleAttributes.self) { context in
            VStack {
                Text("Hello")
            }
            .activityBackgroundTint(.clear)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                }            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("R")
            } minimal: {
                Text("min")
            }
            .widgetURL(URL(string: ""))
            .keylineTint(.red)
        }

    }
}
