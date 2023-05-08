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
fileprivate let scheduleUrl = "\(Constants.appEndPointUrl)api/movie/schedule"
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MovieSchedule {
        MovieSchedule(date: Date(),movies: [
            .init(name: "Movie name 1", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 2", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 3", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 4", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
        ])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MovieSchedule) -> ()) {
        let entry = MovieSchedule(date: Date(),movies: [
            .init(name: "Movie name 1", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 2", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 3", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
            .init(name: "Movie name 4", episode: "Episode", poster: UIImage(named: "avatar")?.jpegData(compressionQuality: 1)),
        ])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        Task {
            
            if let scheduleData = try? await fetchData(currentDate) {
                var arrPosterData : [Data?] = []
                for i in 0..<scheduleData.movies.count {
                    let posterData = try? await fetchImage(urlString: scheduleData.movies[i].poster!)
                    arrPosterData.append(posterData)
                }
                
                let movies = scheduleData.movies.enumerated().map({ ele in
                    return MovieSchedule.Movie(name: ele.element.name, episode: ele.element.episode, poster: arrPosterData[ele.offset])
                })
                let timelineData = MovieSchedule(date: currentDate, weekday: scheduleData.weekday, movies: movies)
//                let nextUpdate = Calendar.current.date(bySetting: .hour, value: 3, of: currentDate)!
                let timeline = Timeline(entries: [timelineData], policy: .after(Date.tomorrow))
                completion(timeline)
            }
        }
    }
    
    func fetchData(_ date: Date) async throws -> MovieScheduleResponse {
        let dayOfWeek = Calendar.current.dateComponents([.weekday], from: date).weekday ?? 0
        let url =  "\(scheduleUrl)?weekday=\(max(0, dayOfWeek-1))"
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
    var weekday: String?
    var movies: [Movie] = []
    struct Movie {
        let name, episode: String?
        let poster : Data?
    }
}




struct MovieScheduleWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family {
        case .systemSmall:
            smallView(entry.movies)
        case .systemMedium:
            let data = Array(entry.movies[0...min(entry.movies.count - 1, 7)])
            mediumView(data)
        case .accessoryRectangular:
            accessoryRectangularView(entry.movies)
        default:
            mediumView(entry.movies)
        }
        
    }
    @ViewBuilder
    func accessoryRectangularView(_ data : [MovieSchedule.Movie]) -> some View {
        VStack {
            ForEach(data[0...min(data.count - 1, 1)], id: \.name) { m in
                HStack {
                    if let p = m.poster, let uiImage = UIImage(data: p) {
                        Image(uiImage: uiImage).resizable().scaledToFill().frame(width: 15, height: 15)
                            .mask(Circle())
                    }
                    Text(m.name ?? "").lineLimit(1).foregroundColor(.white).font(.system(size: 10))
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(.all)
    }
    
    @ViewBuilder
    func smallView(_ data : [MovieSchedule.Movie]) -> some View {
        ZStack {
            Rectangle().fill(Color(.black))
            ZStack {
                VStack {
                    ForEach(data[0...min(data.count - 1, 3)], id: \.name) { m in
                        HStack {
                            if let p = m.poster, let uiImage = UIImage(data: p) {
                                Image(uiImage: uiImage).resizable().scaledToFill().frame(width: 24, height: 24)
                                    .mask(Circle())
                            }
                            Text(m.name ?? "").lineLimit(2).foregroundColor(.white).font(.system(size: 10))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.frame(maxWidth: .infinity,  alignment: .topLeading).padding(.trailing, 15)
                VStack(alignment: .leading) {
                    Text("\(entry.date.dayOfWeek() ?? "") \(entry.date.get(.day))").foregroundColor(.red).font(.system(size: 12, weight: .bold))
                        .padding(.bottom, -3)
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading).rotationEffect(.degrees(-90))
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(.all)
        }
        
    }
    @ViewBuilder
    func mediumView(_ data : [MovieSchedule.Movie]) -> some View {
        ZStack {
            Rectangle().fill(Color(.black))
            HStack {
                VStack(alignment: .leading) {
                    Text("\(entry.date.dayOfWeek() ?? "")").foregroundColor(.red).font(.system(size: 12))
                    Text("\(entry.date.get(.day))").foregroundColor(.white).font(.system(size: 30, weight: .bold))
                }.padding(.trailing, 10)
                VStack(alignment: .leading) {
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ]
                    LazyVGrid(columns: columns, alignment: .leading) {
                        ForEach(data, id: \.name) { m in
                            HStack {
                                if let p = m.poster, let uiImage = UIImage(data: p) {
                                    Image(uiImage: uiImage).resizable().scaledToFill().frame(width: 24, height: 24)
                                        .mask(Circle())
                                }
                                Text(m.name ?? "").lineLimit(2).foregroundColor(.white).font(.system(size: 10))
                            }
                            
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(.all)
        }
    }
}

struct MovieScheduleWidget: Widget {
    let kind: String = "MovieScheduleWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MovieScheduleWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium, .systemSmall, .accessoryRectangular])
        .configurationDisplayName("Schedule")
        .description("The movie schedule for today")
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
    static var tomorrow:  Date { return Date().dayAfter }
    static var today: Date {return Date()}
    var dayAfter: Date {
          return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
}
