//
//  MovieScheduleWidget.swift
//  MovieScheduleWidget
//
//  Created by TrucPham on 04/05/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MovieSchedule {
        MovieSchedule(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (MovieSchedule) -> ()) {
        let entry = MovieSchedule(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        Task {
            
            if let scheduleData = try? await fetchData() {
                var arrPosterData : [Data?] = []
                for i in 0..<scheduleData.movies.count {
                    let posterData = try? await fetchImage(urlString: scheduleData.movies[i].poster!)
                    arrPosterData.append(posterData)
                }
                
                let timelineData = MovieSchedule(date: currentDate, weekday: scheduleData.weekday, movies: scheduleData.movies.enumerated().map({ ele in
                    return MovieSchedule.Movie(name: ele.element.name, episode: ele.element.episode, poster: arrPosterData[ele.offset])
                }))
                let nextUpdate = Calendar.current.date(bySetting: .second, value: 15, of: currentDate)!
                let timeline = Timeline(entries: [timelineData], policy: .after(nextUpdate))
                completion(timeline)
            }
        }
    }
    
    func fetchData() async throws -> MovieScheduleResponse {
        let session = URLSession(configuration: .default)
        let response = try await session.data(from: URL(string: scheduleUrl)!)
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

fileprivate let scheduleUrl = "http://localhost:27017/api/movie/schedule?weekday=0"

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
        ZStack {
            Rectangle().fill(Color(.black))
            switch family {
            case .systemSmall:
                smallView(entry.movies)
            default:
                mediumView(entry.movies)
            }
           
        }
    }
    @ViewBuilder
    func smallView(_ data : [MovieSchedule.Movie]) -> some View {
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
                Text("THURSDAY 4").foregroundColor(.red).font(.system(size: 12, weight: .bold))
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading).rotationEffect(.degrees(-90))
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).padding(.all)
    }
    @ViewBuilder
    func mediumView(_ data : [MovieSchedule.Movie]) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("THURSDAY").foregroundColor(.red).font(.system(size: 12))
                Text("4").foregroundColor(.white).font(.system(size: 30, weight: .bold))
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

struct MovieScheduleWidget: Widget {
    let kind: String = "MovieScheduleWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MovieScheduleWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium, .systemSmall])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MovieScheduleWidget_Previews: PreviewProvider {
    static var previews: some View {
        MovieScheduleWidgetEntryView(entry: MovieSchedule(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
public struct WrappingHStack: Layout {
    /// The guide for aligning the subviews in this stack. This guide has the same screen coordinate for every subview.
    public var alignment: Alignment

    /// The distance between adjacent subviews in a row or `nil` if you want the stack to choose a default distance.
    public var horizontalSpacing: CGFloat?

    /// The distance between consequtive rows or`nil` if you want the stack to choose a default distance.
    public var verticalSpacing: CGFloat?

    /// Creates a wrapping horizontal stack with the given spacings and alignment.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the subviews in this stack. This guide has the same screen coordinate for every subview.
    ///   - horizontalSpacing: The distance between adjacent subviews in a row or `nil` if you want the stack to choose a default distance.
    ///   - verticalSpacing: The distance between consequtive rows or`nil` if you want the stack to choose a default distance.
    ///   - content: A view builder that creates the content of this stack.
    @inlinable public init(alignment: Alignment = .center,
                           horizontalSpacing: CGFloat? = nil,
                           verticalSpacing: CGFloat? = nil) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    public static var layoutProperties: LayoutProperties {
        var properties = LayoutProperties()
        properties.stackOrientation = .horizontal

        return properties
    }

    /// A shared computation between `sizeThatFits` and `placeSubviews`.
    public struct Cache {

        /// The minimal size of the view.
        var minSize: CGSize

        /// The cached rows.
        var rows: (Int, [Row])?
    }

    public func makeCache(subviews: Subviews) -> Cache {
        Cache(minSize: minSize(subviews: subviews))
    }

    public func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.minSize = minSize(subviews: subviews)
    }

    public func sizeThatFits(proposal: ProposedViewSize,
                             subviews: Subviews,
                             cache: inout Cache) -> CGSize {
        let rows = arrangeRows(proposal: proposal, subviews: subviews, cache: &cache)

        if rows.isEmpty { return cache.minSize }

        let width = proposal.width ?? rows.map { $0.width }.reduce(.zero) { max($0, $1) }

        var height: CGFloat = .zero
        if let lastRow = rows.last {
            height = lastRow.yOffset + lastRow.height
        }

        return CGSize(width: width, height: height)
    }

    public func placeSubviews(in bounds: CGRect,
                              proposal: ProposedViewSize,
                              subviews: Subviews,
                              cache: inout Cache) {
        let rows = arrangeRows(proposal: proposal, subviews: subviews, cache: &cache)

        let anchor = UnitPoint(alignment)

        for row in rows {
            for element in row.elements {
                let x: CGFloat = element.xOffset + anchor.x * (bounds.width - row.width)
                let y: CGFloat = row.yOffset + anchor.y * (row.height - element.size.height)
                let point = CGPoint(x: x + bounds.minX, y: y + bounds.minY)

                subviews[element.index].place(at: point, anchor: .topLeading, proposal: proposal)
            }
        }
    }
}

extension WrappingHStack {
    struct Row {
        var elements: [(index: Int, size: CGSize, xOffset: CGFloat)] = []
        var yOffset: CGFloat = .zero
        var width: CGFloat = .zero
        var height: CGFloat = .zero
    }

    private func arrangeRows(proposal: ProposedViewSize,
                             subviews: Subviews,
                             cache: inout Cache) -> [Row] {
        if cache.minSize.width > proposal.width ?? .infinity,
           cache.minSize.height > proposal.height ?? .infinity {
            return []
        }

        let sizes = subviews.map { $0.sizeThatFits(proposal) }

        let hash = computeHash(proposal: proposal, sizes: sizes)
        if let (oldHash, oldRows) = cache.rows,
           oldHash == hash {
            return oldRows
        }

        var currentX = CGFloat.zero
        var currentRow = Row()
        var rows = [Row]()

        for index in subviews.indices {
            var spacing = CGFloat.zero
            if let previousIndex = currentRow.elements.last?.index {
                spacing = horizontalSpacing(subviews[previousIndex], subviews[index])
            }

            let size = sizes[index]

            if currentX + size.width + spacing > proposal.width ?? .infinity,
               !currentRow.elements.isEmpty {
                currentRow.width = currentX
                rows.append(currentRow)
                currentRow = Row()
                spacing = .zero
                currentX = .zero
            }

            currentRow.elements.append((index, sizes[index], currentX + spacing))
            currentX += size.width + spacing
        }

        currentRow.width = currentX
        rows.append(currentRow)

        var currentY = CGFloat.zero
        var previousMaxHeightIndex: Int?

        for index in rows.indices {
            let maxHeightIndex = rows[index].elements
                .max { $0.size.height < $1.size.height }!
                .index

            let size = sizes[maxHeightIndex]

            var spacing = CGFloat.zero
            if let previousMaxHeightIndex {
                spacing = verticalSpacing(subviews[previousMaxHeightIndex], subviews[maxHeightIndex])
            }

            rows[index].yOffset = currentY + spacing
            currentY += size.height + spacing
            rows[index].height = size.height
            previousMaxHeightIndex = maxHeightIndex
        }

        cache.rows = (hash, rows)

        return rows
    }

    private func computeHash(proposal: ProposedViewSize, sizes: [CGSize]) -> Int {
        let proposal = proposal.replacingUnspecifiedDimensions(by: .infinity)

        var hasher = Hasher()

        for size in [proposal] + sizes {
            hasher.combine(size.width)
            hasher.combine(size.height)
        }

        return hasher.finalize()
    }

    private func minSize(subviews: Subviews) -> CGSize {
        subviews
            .map { $0.sizeThatFits(.zero) }
            .reduce(CGSize.zero) { CGSize(width: max($0.width, $1.width), height: max($0.height, $1.height)) }
    }

    private func horizontalSpacing(_ lhs: LayoutSubview, _ rhs: LayoutSubview) -> CGFloat {
        if let horizontalSpacing { return horizontalSpacing }

        return lhs.spacing.distance(to: rhs.spacing, along: .horizontal)
    }

    private func verticalSpacing(_ lhs: LayoutSubview, _ rhs: LayoutSubview) -> CGFloat {
        if let verticalSpacing { return verticalSpacing }

        return lhs.spacing.distance(to: rhs.spacing, along: .vertical)
    }
}

private extension CGSize {
    static var infinity: Self {
        .init(width: CGFloat.infinity, height: CGFloat.infinity)
    }
}

private extension UnitPoint {
    init(_ alignment: Alignment) {
        switch alignment {
        case .leading:
            self = .leading
        case .topLeading:
            self = .topLeading
        case .top:
            self = .top
        case .topTrailing:
            self = .topTrailing
        case .trailing:
            self = .trailing
        case .bottomTrailing:
            self = .bottomTrailing
        case .bottom:
            self = .bottom
        case .bottomLeading:
            self = .bottomLeading
        default:
            self = .center
        }
    }
}
