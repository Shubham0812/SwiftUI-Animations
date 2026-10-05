//
//  ColorfulHeatmapsView.swift
//  SwiftUI-Animations
//
//  Created by Claude on 05/10/26.
//

import SwiftUI

// MARK: - Main View

/// A GitHub-style yearly contribution heatmap with a year picker and a palette menu in the nav bar.
struct ColorfulHeatmapsView: View {

    // MARK: - Variables
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var year = Calendar.current.component(.year, from: .now)
    @State private var palette: HeatmapPalette = .emerald

    var countForDate: (Date) -> Int = HeatmapDates.demoCount

    // MARK: - Views
    @ViewBuilder
    var body: some View {
        ScrollView {
            YearHeatmap(year: year, palette: palette, countForDate: countForDate)
                .safeAreaPadding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .padding(.top, 84)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Year", selection: $year) {
                        ForEach(max(1, year - 10)...min(9999, year + 10), id: \.self) { value in
                            Text(String(value))
                                .tag(value)
                        }
                    }
                    Menu("More years") {
                        Button("20 years earlier") { year = max(1, year - 20) }
                            .disabled(year <= 1)
                        Button("20 years later") { year = min(9999, year + 20) }
                            .disabled(year >= 9999)
                        Button("Current year") { year = Calendar.current.component(.year, from: .now) }
                    }
                } label: {
                    HStack(spacing: 5) {
                        Text(String(year))
                            .monospacedDigit()
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                }
                .accessibilityLabel("Choose year, currently \(String(year))")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    // A Picker supplies the native selected-item checkmark.
                    Picker("Heatmap color", selection: $palette) {
                        ForEach(HeatmapPalette.allCases) { color in
                            Label {
                                Text(color.rawValue)
                            } icon: {
                                Image(uiImage: color.menuDot)
                                    .renderingMode(.original)
                            }
                            .tag(color)
                        }
                    }
                } label: {
                    Circle()
                        .fill(palette.tint)
                        .frame(width: 22, height: 22)
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Heatmap color, \(palette.rawValue)")
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.25), value: palette)
        .tint(.primary)
    }
}

// MARK: - Palette

enum HeatmapPalette: String, CaseIterable, Identifiable {
    case emerald = "Emerald Matrix"
    case blue = "Sky Blue Grid"
    case violet = "Violet Pulse"

    // MARK: - Variables
    var id: Self { self }

    var tint: Color {
        switch self {
        case .emerald: Color(red: 0.20, green: 0.86, blue: 0.34)
        case .blue: Color(red: 0.22, green: 0.52, blue: 1)
        case .violet: Color(red: 0.68, green: 0.29, blue: 0.96)
        }
    }

    // Original-rendering images retain their color in native UIKit-backed menus.
    var menuDot: UIImage { Self.menuDots[self]! }

    private static let menuDots: [HeatmapPalette: UIImage] = {
        Dictionary(uniqueKeysWithValues: allCases.map { palette in
            let image = UIGraphicsImageRenderer(size: CGSize(width: 16, height: 16)).image { context in
                context.cgContext.setFillColor(UIColor(palette.tint).cgColor)
                context.cgContext.fillEllipse(in: CGRect(x: 1, y: 1, width: 14, height: 14))
            }
            .withRenderingMode(.alwaysOriginal)
            return (palette, image)
        })
    }()

    // MARK: - Functions
    // Fixed thresholds keep intensity comparable across months and years.
    func color(for count: Int) -> Color {
        switch count {
        case ...0: tint.opacity(0.10)
        case 1...2: tint.opacity(0.23)
        case 3...5: tint.opacity(0.43)
        case 6...9: tint.opacity(0.68)
        default: tint
        }
    }
}

// MARK: - Model

private struct HeatmapDay: Identifiable {
    let date: Date
    let count: Int
    var id: Date { date }
}

// MARK: - Year Heatmap

struct YearHeatmap: View {

    // MARK: - Variables
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var days: [HeatmapDay] = []
    @State private var leadingDays = 0
    @State private var selected: HeatmapDay?

    let year: Int
    let palette: HeatmapPalette
    let countForDate: (Date) -> Int

    private let cellSize: CGFloat = 13
    private let weekdaySymbols = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let monthSymbols = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    private var weeks: Int { (leadingDays + days.count + 6) / 7 }

    // MARK: - Views
    @ViewBuilder
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            // Weekday labels stay pinned while the grid scrolls horizontally.
            VStack(spacing: 4) {
                Color.clear
                    .frame(width: 26, height: 18)
                ForEach(0..<7, id: \.self) { row in
                    Text(weekdaySymbols[row])
                        .font(.system(size: 9, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .frame(width: 26, height: cellSize, alignment: .leading)
                }
            }
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 4) {
                    ForEach(0..<weeks, id: \.self) { week in
                        VStack(spacing: 4) {
                            Text(monthLabel(for: week))
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .fixedSize()
                                .frame(width: cellSize, height: 18, alignment: .leading)
                            ForEach(0..<7, id: \.self) { weekday in
                                let index = week * 7 + weekday - leadingDays
                                if days.indices.contains(index) {
                                    let day = days[index]
                                    Button { selected = day } label: {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(palette.color(for: day.count))
                                            .overlay {
                                                if selected?.date == day.date {
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .strokeBorder(.primary, lineWidth: 1.5)
                                                }
                                            }
                                            .frame(width: cellSize, height: cellSize)
                                    }
                                    .buttonStyle(.plain)
                                    .onHover { hovering in if hovering { selected = day } }
                                    .accessibilityLabel("\(day.date.formatted(date: .complete, time: .omitted)), \(day.count) contributions")
                                } else {
                                    Color.clear
                                        .frame(width: cellSize, height: cellSize)
                                }
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .defaultScrollAnchor(.leading)
            .id(year)
        }
        .fixedSize(horizontal: false, vertical: true)
        .onChange(of: year, initial: true) { _, _ in rebuild() }
    }

    // MARK: - Functions
    private func rebuild() {
        let calendar = HeatmapDates.calendar
        guard let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1, hour: 12)),
              let end = calendar.date(byAdding: .year, value: 1, to: start) else { return }
        var result: [HeatmapDay] = []
        result.reserveCapacity(366)
        var date = start
        while date < end {
            result.append(HeatmapDay(date: date, count: max(0, countForDate(date))))
            guard let next = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = next
        }
        selected = nil
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.3)) {
            leadingDays = (calendar.component(.weekday, from: start) + 5) % 7
            days = result
        }
    }

    // MARK: - Helpers
    private func monthLabel(for week: Int) -> String {
        let start = max(0, week * 7 - leadingDays)
        let end = min(days.count, (week + 1) * 7 - leadingDays)
        guard start < end,
              let first = days[start..<end].first(where: { HeatmapDates.calendar.component(.day, from: $0.date) == 1 }) else { return "" }
        let month = HeatmapDates.calendar.component(.month, from: first.date)
        return monthSymbols[month - 1]
    }
}

// MARK: - Dates

enum HeatmapDates {

    // MARK: - Variables
    // Built once: month labels and demo counts query it for every day on each render.
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar
    }()

    // MARK: - Functions
    // Deterministic demo data: the same date always has the same count.
    // Nothing random is generated while SwiftUI renders a cell.
    static func demoCount(_ date: Date) -> Int {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        var seed = UInt64((c.year ?? 1) * 10000 + (c.month ?? 1) * 100 + (c.day ?? 1))
        seed = (seed ^ (seed >> 30)) &* 0xbf58476d1ce4e5b9
        seed = (seed ^ (seed >> 27)) &* 0x94d049bb133111eb
        seed ^= seed >> 31
        return seed % 5 == 0 ? 0 : Int(seed % 15)
    }
}

#Preview {
    NavigationStack {
        ColorfulHeatmapsView()
    }
}
