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
struct ScheduleLiveActivity : Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScheduleAttributes.self) { context in
            rainView()
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
    
    @ViewBuilder
    func sunnyView() -> some View {
        ZStack {
            Color.white
            LinearGradient(colors: [
                Color(red: 0.11, green: 0.58, blue: 1.00),
                Color(red: 0.11, green: 0.58, blue: 1.00, opacity: 0.75),
                Color(red: 0.11, green: 0.58, blue: 1.00, opacity: 0.5)
            ], startPoint: .leading, endPoint: .trailing)
            GeometryReader { _ in
                VStack(alignment: .trailing) {
                    Image("sun-weather")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .offset(.init(width: 80, height: -80))
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }.clipped()
            VStack(alignment: .leading) {
                Text("Sunny").font(Font(UIFont.regular(ofSize: 15)))
                    .foregroundColor(.white)
                HStack {
                    Text("25°").foregroundColor(.white).font(.init(UIFont.bold(ofSize: 50)))
                    Rectangle().fill(
                        LinearGradient(colors: [Color.clear, Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom)
                    ).frame(width: 1, height: 50)
                    VStack(alignment: .leading) {
                        Text("Monday, 21 september").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 15)))
                            .padding(.bottom, 3)
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                            
                            Text("San Fransisco").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 15)))
                        }
                    }
                }
                
            }.padding(.horizontal, 30).padding(.vertical, 20)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
               
        }
    }
    
    @ViewBuilder
    func cloudyNightView() -> some View {
        ZStack {
            Color.white
            LinearGradient(colors: [
                Color(red: 0.11, green: 0.58, blue: 1.00),
                Color(red: 0.63, green: 0.49, blue: 0.87, opacity: 1.00)
            ], startPoint: .leading, endPoint: .trailing)
            GeometryReader { _ in
                VStack(alignment: .trailing) {
                    Image("cloudy-night")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .offset(.init(width: 30, height: -30))
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }.clipped()
            VStack(alignment: .leading) {
                Text("Cloudy Night").font(Font(UIFont.regular(ofSize: 15)))
                    .foregroundColor(.white)
                HStack {
                    Text("25°").foregroundColor(.white).font(.init(UIFont.bold(ofSize: 50)))
                    Rectangle().fill(
                        LinearGradient(colors: [Color.clear, Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom)
                    ).frame(width: 1, height: 50)
                    VStack(alignment: .leading) {
                        Text("Monday, 21 september").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 15)))
                            .padding(.bottom, 3)
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                            
                            Text("San Fransisco").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 15)))
                        }
                    }
                }
                
            }.padding(.horizontal, 30).padding(.vertical, 20)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
               
        }
    }
    
    @ViewBuilder
    func rainView() -> some View {
        ZStack {
            Color.white
            LinearGradient(colors: [
                Color(red: 0.01, green: 0.75, blue: 0.65),
                Color(red: 0.54, green: 1.00, blue: 0.63, opacity: 1.00)
            ], startPoint: .leading, endPoint: .trailing)
            GeometryReader { _ in
                VStack(alignment: .trailing) {
                    Image("rain")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .offset(.init(width: 30, height: -20))
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }.clipped()
            VStack(alignment: .leading) {
                Text("Rain").font(Font(UIFont.regular(ofSize: 15)))
                    .foregroundColor(.white)
                HStack {
                    Text("25°").foregroundColor(.white).font(.init(UIFont.bold(ofSize: 50)))
                    Rectangle().fill(
                        LinearGradient(colors: [Color.clear, Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom)
                    ).frame(width: 1, height: 50)
                    VStack(alignment: .leading) {
                        Text("Monday, 21 september").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 15)))
                            .padding(.bottom, 3)
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                            
                            Text("San Fransisco").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 15)))
                        }
                    }
                }
                
            }.padding(.horizontal, 30).padding(.vertical, 20)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
               
        }
    }
}

@available(iOS 15.0, *)
struct Previews_ScheduleLiveActivity_Previews: PreviewProvider {
    @ViewBuilder
    static func cloudyNightView() -> some View {
        ZStack {
            Color.white
            LinearGradient(colors: [
                Color(red: 0.01, green: 0.75, blue: 0.65),
                Color(red: 0.54, green: 1.00, blue: 0.63, opacity: 1.00)
            ], startPoint: .leading, endPoint: .trailing)
            GeometryReader { _ in
                VStack(alignment: .trailing) {
                    Image("rain")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .offset(.init(width: 50, height: -20))
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }.clipped()
            VStack(alignment: .leading) {
                Text("Cloudy Night").font(Font(UIFont.regular(ofSize: 15)))
                    .foregroundColor(.white)
                HStack {
                    Text("25°").foregroundColor(.white).font(.init(UIFont.regular(ofSize: 50)))
                    Rectangle().fill(
                        LinearGradient(colors: [Color.clear, Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom)
                    ).frame(width: 1, height: 50)
                    VStack(alignment: .leading) {
                        Text("Monday, 21 september").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 15)))
                            .padding(.bottom, 3)
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                            
                            Text("San Fransisco").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 15)))
                        }
                    }
                }
                
            }.padding(.horizontal, 30).padding(.vertical, 20)
                .frame(maxWidth: .infinity,maxHeight: 150, alignment: .leading)
               
        }.frame(maxWidth: .infinity,maxHeight: 140, alignment: .leading)
    }
    
    static var previews: some View {
        VStack {
            cloudyNightView()
        }
    }
}
