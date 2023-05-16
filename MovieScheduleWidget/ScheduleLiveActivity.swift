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
            liveMatch(context: context)
        } dynamicIsland: { context in
            // Create the presentations that appear in the Dynamic Island.
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Image(context.state.teamA.id.rawValue).resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        Text(context.state.teamA.id.name)
                            .foregroundColor(.white)
                            .font(.init(UIFont.bold(ofSize: 10)))
                            .multilineTextAlignment(.center)
                    }
                    
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Image(context.state.teamB.id.rawValue).resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        Text(context.state.teamB.id.name).foregroundColor(.white)
                            .font(.init(UIFont.bold(ofSize: 10)))
                            .multilineTextAlignment(.center)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        Text("\(context.state.teamA.scored.count) - \(context.state.teamB.scored.count)").foregroundColor(.white)
                            .font(.init(UIFont.bold(ofSize: 25)))
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text(context.state.state == .playing ? "LIVE" : "END")
                            .foregroundColor(.white)
                            .font(.init(UIFont.bold(ofSize: 12)))
                            .padding(.all, 5)
                            .background(RoundedRectangle(cornerRadius: 5, style: RoundedCornerStyle.continuous).fill(Color(red: 0.80, green: 0.26, blue: 0.27, opacity: 1.00)))
                            .padding(.trailing, 15)
                        GeometryReader { proxy in
                            let width = proxy.size.width
                            let ts : [Time] = (context.state.teamA.scored.map{s in
                                return Time(time: s.time, name: s.name, color: context.state.teamA.primaryColor)
                            } + context.state.teamB.scored.map {s in
                                return Time(time: s.time, name: s.name, color: context.state.teamB.primaryColor)
                            }).sorted(by: {x , x2 in return x.time < x2.time })
                            
                            let totalTime : Int = 90
                            ZStack {
                                let max : CGFloat = CGFloat(ts.max(by: { x,x2  in return x.time < x2.time })?.time ?? 0)
                                RoundedRectangle(cornerSize: .init(width: 5, height: 5)).fill(.white.opacity(0.5))
                                    .frame(width: .infinity, height: 2, alignment: .leading)
                                let time = max * CGFloat(width) / CGFloat(totalTime)
                                RoundedRectangle(cornerSize: .init(width: 5, height: 5)).fill(.red)
                                    .frame(width: time, height: 2, alignment: .leading)
                                    .offset(x: -(width - time) / 2)
                                
                                ForEach(Array(ts.enumerated()), id: \.offset) { i in
                                    Text("\(i.element.name) \(i.element.time)'").foregroundColor(.white.opacity(0.8)) .font(.init(UIFont.regular(ofSize: 8)))
                                        .offset(.init(width: -width/2, height: 0))
                                        .offset(.init(width: i.element.time * Int(width) / totalTime, height: 0))
                                        .offset(.init(width: 0, height: i.offset % 2 == 0 ? -15 : 15))
                                    
                                    Circle().fill(Color(hex: i.element.color)).frame(width: 5, height: 5)
                                        .offset(.init(width: -width/2, height: 0))
                                        .offset(.init(width: i.element.time * Int(width) / totalTime, height: 0))
                                }
                            }.frame(maxHeight: .infinity, alignment: .center)
                        }.frame(width: .infinity, height: 45)
                    }
                    
                }
            } compactLeading: {
                HStack {
                    Image(context.state.teamA.id.rawValue).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Text("\(context.state.teamA.scored.count)").foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 16)))
                }
            } compactTrailing: {
                HStack {
                    Text("\(context.state.teamB.scored.count)").foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 16)))
                    Image(context.state.teamB.id.rawValue).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
            } minimal: {
                ZStack {
                    Image(context.state.teamA.id.rawValue).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40).offset(x: -20)
                    Image(context.state.teamB.id.rawValue).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40).offset(x: 20)
                        .frame(width: .infinity, height: .infinity)
                    LinearGradient(colors: [
                        .clear,
                        .black.opacity(0.7),
                        .clear
                    ], startPoint: .leading, endPoint: .trailing)
                    .frame(width: 100, height: 100)
                    Text("\(context.state.teamA.scored.count) - \(context.state.teamB.scored.count)").foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 15)))
                        .shadow(radius: 3)
                }
                
            }
            .keylineTint(.clear)
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
    
    
    
    @ViewBuilder
    func liveMatch(context: ActivityViewContext<ScheduleAttributes>) -> some View {
        VStack {
            HStack {
                Text(context.state.state == .playing ? "LIVE" : "END")
                    .foregroundColor(.white)
                    .font(.init(UIFont.bold(ofSize: 12)))
                    .padding(.all, 5)
                    .background(RoundedRectangle(cornerRadius: 5, style: RoundedCornerStyle.continuous).fill(Color(red: 0.80, green: 0.26, blue: 0.27, opacity: 1.00)))
                Text("MATCH STARTS").foregroundColor(.white).font(.init(UIFont.regular(ofSize: 12)))
            }.frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                VStack {
                    Image(context.state.teamA.id.rawValue).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text(context.state.teamA.id.name)
                        .foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 10)))
                        .multilineTextAlignment(.center)
                }
                VStack {
                    Text("\(context.state.teamA.scored.count) - \(context.state.teamB.scored.count)").foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 20)))
                }.padding(.horizontal, 20)
                VStack {
                    Image(context.state.teamB.id.rawValue).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text(context.state.teamB.id.name).foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 10)))
                        .multilineTextAlignment(.center)
                }
            }
            GeometryReader { proxy in
                let width = proxy.size.width
                let ts : [Time] = (context.state.teamA.scored.map{s in
                    return Time(time: s.time, name: s.name, color: context.state.teamA.primaryColor)
                } + context.state.teamB.scored.map {s in
                    return Time(time: s.time, name: s.name, color: context.state.teamB.primaryColor)
                }).sorted(by: {x , x2 in return x.time < x2.time })
                
                let totalTime : Int = 90
                ZStack {
                    let max : CGFloat = CGFloat(ts.max(by: { x,x2  in return x.time < x2.time })?.time ?? 0)
                    RoundedRectangle(cornerSize: .init(width: 5, height: 5)).fill(.white.opacity(0.5)).frame(width: .infinity, height: 2)
                    let time = max * CGFloat(width) / CGFloat(totalTime)
                    RoundedRectangle(cornerSize: .init(width: 5, height: 5)).fill(.red)
                        .frame(width: time, height: 2, alignment: .leading)
                        .offset(x: -(width - time) / 2)
                    ForEach(Array(ts.enumerated()), id: \.offset) { i in
                        Text("\(i.element.name) \(i.element.time)'").foregroundColor(.white.opacity(0.8)) .font(.init(UIFont.regular(ofSize: 9)))
                            .offset(.init(width: -width/2, height: 0))
                            .offset(.init(width: i.element.time * Int(width) / totalTime, height: 0))
                            .offset(.init(width: 0, height: i.offset % 2 == 0 ? -15 : 15))
                        
                        Circle().fill(Color(hex: i.element.color)).frame(width: 5, height: 5)
                            .offset(.init(width: -width/2, height: 0))
                            .offset(.init(width: i.element.time * Int(width) / totalTime, height: 0))
                    }
                }.frame(maxHeight: .infinity, alignment: .center)
            }.frame(width: .infinity, height: 45).padding(.top, -5)
            
        }.frame(maxWidth: .infinity)
            .padding(.horizontal, 20).padding(.vertical, 15).background(Color(red: 0.15, green: 0.21, blue: 0.25, opacity: 0.4))
        
    }
}
struct Time : Hashable {
    let time : Int
    let name : String
    let color : String
}
@available(iOS 15.0, *)
struct Previews_ScheduleLiveActivity_Previews: PreviewProvider {
    @ViewBuilder
    static func liveMatch() -> some View {
        VStack {
            HStack {
                Text("LIVE")
                    .foregroundColor(.white)
                    .font(.init(UIFont.bold(ofSize: 12)))
                    .padding(.all, 5)
                    .background(Color(red: 0.80, green: 0.26, blue: 0.27, opacity: 1.00))
                    .cornerRadius(5)
                Text("MATCH STARTS").foregroundColor(.white).font(.init(UIFont.regular(ofSize: 12)))
            }.frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                VStack {
                    Image("Manchester_City_FC").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text("Manchester City")
                        .foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 10)))
                        .multilineTextAlignment(.center)
                }
                VStack {
                    Text("3 - 1").foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 20)))
                }.padding(.horizontal, 20)
                VStack {
                    Image("Man_Utd_FC").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text("Manchester United").foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 10)))
                        .multilineTextAlignment(.center)
                }
            }
            GeometryReader { proxy in
                let width = proxy.size.width
                let ts : [Time] = [
                    .init(time: 13, name: "B. Philip", color: "#71AFDF"),
                    .init(time: 22, name: "B. Walker", color: "#71AFDF"),
                    .init(time: 58, name: "C. Cabrera", color: "#71AFDF"),
                    .init(time: 72, name: "J. IBra", color: "#CC4244"),
                ]
                let totalTime : Int = 90
                ZStack {
                    RoundedRectangle(cornerSize: .init(width: 5, height: 5)).fill(.white.opacity(0.5)).frame(width: .infinity, height: 2)
                    ForEach(Array(ts.enumerated()), id: \.offset) { i in
                        Text(i.element.name).foregroundColor(.white.opacity(0.8)) .font(.init(UIFont.regular(ofSize: 8)))
                            .offset(.init(width: -width/2, height: 0))
                            .offset(.init(width: i.element.time * Int(width) / totalTime, height: 0))
                            .offset(.init(width: 0, height: i.offset % 2 == 0 ? -15 : 15))
                        
                        Circle().fill(Color(hex: i.element.color)).frame(width: 5, height: 5)
                            .offset(.init(width: -width/2, height: 0))
                            .offset(.init(width: i.element.time * Int(width) / totalTime, height: 0))
                    }
                }.frame(maxHeight: .infinity, alignment: .center)
            }.frame(width: .infinity, height: 45).background(Color.red)
            
        }.padding(.horizontal, 20).padding(.vertical, 10).frame(width: .infinity, height: 160)
        
            .background(Color(red: 0.15, green: 0.21, blue: 0.25, opacity: 0.8))
        
    }
    
    @ViewBuilder
    static func endMatch() -> some View {
        VStack {
            HStack {
                Text("END")
                    .foregroundColor(.white)
                    .font(.init(UIFont.regular(ofSize: 13)))
                    .padding(.all, 4)
                    .background(Color(red: 0.80, green: 0.26, blue: 0.27, opacity: 1.00))
                    .cornerRadius(5)
                Text("MATCH STARTS").foregroundColor(.white).font(.init(UIFont.regular(ofSize: 13)))
            }.frame(maxWidth: .infinity, alignment: .leading)
            GeometryReader { proxy in
                let width = proxy.size.width
                let ts : [Time] = [
                    .init(time: 13, name: "B. Philip", color: "#71AFDF"),
                    .init(time: 22, name: "B. Walker", color: "#71AFDF"),
                    .init(time: 58, name: "C. Cabrera", color: "#71AFDF"),
                    .init(time: 72, name: "J. IBra", color: "#CC4244"),
                ]
                let totalTime : Int = 90
                ZStack {
                    RoundedRectangle(cornerSize: .init(width: 5, height: 5)).fill(Color.gray).frame(width: .infinity, height: 2)
                    ForEach(Array(ts.enumerated()), id: \.offset) { i in
                        Text(i.element.name).foregroundColor(.gray) .font(.init(UIFont.regular(ofSize: 10)))
                            .offset(.init(width: -width/2, height: 0))
                            .offset(.init(width: i.element.time * Int(width) / totalTime, height: 0))
                            .offset(.init(width: 0, height: i.offset % 2 == 0 ? -15 : 15))
                        
                        Circle().fill(Color(hex: i.element.color)).frame(width: 5, height: 5)
                            .offset(.init(width: -width/2, height: 0))
                            .offset(.init(width: i.element.time * Int(width) / totalTime, height: 0))
                    }
                }.frame(maxHeight: .infinity, alignment: .center)
            }.frame(width: .infinity, height: 30).padding(.top, 10)
            VStack {
                HStack {
                    Image("Manchester_City_FC").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 25, maxHeight: 25)
                    Text("Manchester City")
                        .foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 10)))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("3").foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 20)))
                        .padding(.leading, 30)
                }.frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Image("Man_Utd_FC").resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 25, maxHeight: 25)
                    Text("Manchester United").foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 10)))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("1").foregroundColor(.white)
                        .font(.init(UIFont.bold(ofSize: 20)))
                        .padding(.leading, 30)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }.frame(maxWidth: .infinity)
            .padding(.all, 20)
            .background(Color(red: 0.15, green: 0.21, blue: 0.25, opacity: 0.8))
    }
    
    @ViewBuilder
    static var previews: some View {
        liveMatch()
        
    }
}
@available(iOS 13.0, *)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
