//
//  MovieScheduleWidget.swift
//  MovieScheduleWidget
//
//  Created by TrucPham on 04/05/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI
struct ScheduleProvider: IntentTimelineProvider {
    private let scheduleUrl = "\(Constants.appEndPointUrl)api/movie/schedule"
    func placeholder(in context: Context) -> MovieSchedule {
        MovieSchedule(date: Date(),maxCount: 4, movies: [
            .init(name: "Movie name 1", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 2", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 3", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 4", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
        ])
    }
    
    func getSnapshot(for configuration: TrucPhamScheduleConfigurationIntent, in context: Context, completion: @escaping (MovieSchedule) -> ()) {
        let entry = MovieSchedule(date: Date(),filterBookmark: configuration.filterBookmark as? Bool ?? false, maxCount: 4, movies: [
            .init(name: "Movie name 1", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 2", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 3", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 4", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
        ])
        completion(entry)
    }
    
    func getTimeline(for configuration: TrucPhamScheduleConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        Task {
            @Storage(key: Authorization.key, defaultValue: nil, group: Constants.groupShared)
            var auth : Authorization?
            let filter = configuration.filterBookmark as? Bool ?? true
            if let scheduleData = try? await fetchData(currentDate, id: filter ? auth?.userId : nil) {
                var arrPosterData : [Data?] = []
                for i in 0..<scheduleData.movies.count {
                    let posterData = try? await fetchImage(urlString: scheduleData.movies[i].poster!)
                    arrPosterData.append(posterData)
                }
                
                let movies = scheduleData.movies.enumerated().map({ ele in
                    return MovieSchedule.Movie(name: ele.element.name, episode: ele.element.episode, poster: arrPosterData[ele.offset])
                })
                let timelineData = MovieSchedule(date: currentDate, filterBookmark: filter, maxCount: configuration.maxCount as? Int ?? 2, weekday: scheduleData.weekday, movies: movies)
//                let nextUpdate = Calendar.current.date(bySetting: .hour, value: 3, of: currentDate)!
                let timeline = Timeline(entries: [timelineData], policy: .after(Date.tomorrow))
                completion(timeline)
            }
        }
    }
    
    func fetchData(_ date: Date, id: String? = nil) async throws -> MovieScheduleResponse {
        let dayOfWeek = Calendar.current.dateComponents([.weekday], from: date).weekday ?? 0
        var url =  "\(scheduleUrl)?weekday=\(max(0, dayOfWeek-1))"
        if let id = id {  url += "&id=\(id)" }
        let session = URLSession(configuration: .default)
        let response = try await session.data(from: URL(string: url)!)
        let scheduleData = try JSONDecoder().decode(ApiResponse<MovieScheduleResponse>.self, from: response.0)
        if let schedule = scheduleData.data {
            return schedule
        }
        
        return .init()
    }
    func fetchImage(urlString: String) async throws -> Data {
        let session = URLSession(configuration: .default)
        let response = try await session.data(from: URL(string: urlString)!)
        return response.0
    }
    
}



// MARK: - MovieScheduleResponse
struct ApiResponse<T : Codable>: Codable {
    let status: Int?
    let data: T?
    let message: String?
}

// MARK: - DataClass
struct MovieScheduleResponse: Codable {
    var weekday: String?
    var movies: [MovieResponse] = []
    // MARK: - Movie
    struct MovieResponse: Codable {
        let name, poster, episode: String?
    }
}

struct MovieSchedule : TimelineEntry {
    let date: Date
    var filterBookmark: Bool = true
    var maxCount : Int = 2
    var weekday: String?
    var movies: [Movie] = []
    struct Movie {
        let name, episode: String?
        let poster : Data?
    }
}




struct MovieScheduleWidgetEntryView : View {
    var entry: ScheduleProvider.Entry
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family {
        case .systemSmall:
            smallView()
        case .systemMedium:
            mediumView()
        case .accessoryRectangular:
            accessoryRectangularView()
        case .accessoryCircular:
            accessoryCircularView()
        default:
            mediumView()
        }
    }
    
    @ViewBuilder
    func accessoryCircularView() -> some View {
        ZStack {
            if entry.movies.count == 0 {
                Circle().stroke(.white, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                Circle().trim(from: 0.0, to: CGFloat(entry.movies.count * 10) / 100)
                    .stroke(.white, style: StrokeStyle(lineWidth: 6, lineCap: .butt, lineJoin: .round))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Text("\(entry.movies.count)").font(Font(UIFont.bold(ofSize: 18)))
        }
    }
    
    @ViewBuilder
    func accessoryRectangularView() -> some View {
        VStack {
            if entry.movies.count > 0 {
                ForEach(entry.movies[0..<min(entry.movies.count, entry.maxCount)], id: \.name) { m in
                    HStack {
                        if let p = m.poster, let uiImage = UIImage(data: p) {
                            Image(uiImage: uiImage).resizable().scaledToFill().frame(width: 15, height: 15)
                                .mask(Circle())
                        }
                        Text(m.name ?? "").lineLimit(1).foregroundColor(.white).font(Font(UIFont.regular(ofSize: 10)))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            else {
                HStack {
                    Image(systemName: "xmark").resizable().frame(width: 8, height: 8).foregroundColor(.white)
                    Text("Movie not found").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 10)))
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(.all)
    }
    
    @ViewBuilder
    func smallView() -> some View {
        ZStack {
            Rectangle().fill(Color(.black))
            ZStack {
                if entry.movies.count > 0 {
                    VStack {
                        ForEach(entry.movies[0..<min(entry.movies.count, entry.maxCount)], id: \.name) { m in
                            HStack {
                                if let p = m.poster, let uiImage = UIImage(data: p) {
                                    Image(uiImage: uiImage).resizable().scaledToFill().frame(width: 24, height: 24)
                                        .mask(Circle())
                                }
                                Text(m.name ?? "").lineLimit(2).foregroundColor(.white).font(Font(UIFont.regular(ofSize: 10)))
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .widgetURL(URL(string: "movietp://\(m.name ?? "")"))
                        }
                    }.frame(maxWidth: .infinity,  alignment: .topLeading).padding(.trailing, 15)
                }
                else {
                    ZStack {
                        Text("Movie not found").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 12)))
                    }.padding(.trailing, 15)
                }
                VStack(alignment: .leading) {
                    Text("\(entry.date.dayOfWeek() ?? "") \(entry.date.get(.day))").foregroundColor(.red).font(Font(UIFont.bold(ofSize: 12)))
                        .padding(.bottom, -3)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading).rotationEffect(.degrees(-90))
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(.all)
        }
        
    }
    @ViewBuilder
    func mediumView() -> some View {
        ZStack {
            Rectangle().fill(Color(.black))
            HStack {
                VStack(alignment: .leading) {
                    Text("\(entry.date.dayOfWeek() ?? "")").foregroundColor(.red).font(Font(UIFont.regular(ofSize: 12)))
                    Text("\(entry.date.get(.day))").foregroundColor(.white).font(Font(UIFont.bold(ofSize: 30)))
                }.padding(.trailing, 10)
                VStack(alignment: .center) {
                    if entry.movies.count > 0 {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ]
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach(entry.movies[0..<min(entry.movies.count, entry.maxCount)], id: \.name) { m in
                                HStack {
                                    if let p = m.poster, let uiImage = UIImage(data: p) {
                                        Image(uiImage: uiImage).resizable().scaledToFill().frame(width: 24, height: 24)
                                            .mask(Circle())
                                    }
                                    Text(m.name ?? "").lineLimit(2).foregroundColor(.white).font(Font(UIFont.regular(ofSize: 10)))
                                }
                                
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                    else {
                        ZStack(alignment: .center) {
                            Text("Movie not found").foregroundColor(.white).font(Font(UIFont.regular(ofSize: 15)))
                        }.frame(maxWidth: .infinity)
                    }
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(.all)
        }
    }
}

struct MovieScheduleWidget: Widget {
    let kind: String = "MovieScheduleWidget"
    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.0, *) {
            return IntentConfiguration(kind: kind, intent: TrucPhamScheduleConfigurationIntent.self, provider: ScheduleProvider()) { entry in
                MovieScheduleWidgetEntryView(entry: entry)
            }
            .supportedFamilies([.systemMedium, .systemSmall, .accessoryRectangular, .accessoryCircular])
            .configurationDisplayName("Schedule")
            .description("The movie schedule for today")
        } else {
            return IntentConfiguration(kind: kind, intent: TrucPhamScheduleConfigurationIntent.self, provider: ScheduleProvider()) { entry in
                MovieScheduleWidgetEntryView(entry: entry)
            }
            .supportedFamilies([.systemMedium, .systemSmall])
            .configurationDisplayName("Schedule")
            .description("The movie schedule for today")
        }
    }
}

struct MovieScheduleWidget_Previews: PreviewProvider {
    static var previews: some View {
        MovieScheduleWidgetEntryView(entry: MovieSchedule(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    static var tomorrow:  Date {
        let today = Date()
        let midnight = Calendar.current.startOfDay(for: today)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        return tomorrow
    }
    static var today: Date {return Date()}
}
