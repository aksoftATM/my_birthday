import WidgetKit
import SwiftUI

/// Должно совпадать с appGroupId в lib/core/widget/home_widget_service.dart
private let appGroupId = "group.com.aksoft.mybirthday.widget"

// MARK: - Entry

struct BirthdayEntry: TimelineEntry {
    let date: Date
    let hasProfile: Bool
    let daysUntilBirthday: Int
    let userName: String?
}

// MARK: - Provider

struct BirthdayProvider: TimelineProvider {
    func placeholder(in context: Context) -> BirthdayEntry {
        BirthdayEntry(date: Date(), hasProfile: true, daysUntilBirthday: 86, userName: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (BirthdayEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BirthdayEntry>) -> Void) {
        let entry = currentEntry()
        // Дни считаются на лету из даты рождения, поэтому достаточно
        // обновлять таймлайн раз в сутки, вскоре после полуночи.
        let calendar = Calendar.current
        let refreshDate = calendar.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 5),
            matchingPolicy: .nextTime
        ) ?? Date().addingTimeInterval(3600)
        completion(Timeline(entries: [entry], policy: .after(refreshDate)))
    }

    private func currentEntry() -> BirthdayEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let hasProfile = defaults?.bool(forKey: "has_profile") ?? false
        guard hasProfile else {
            return BirthdayEntry(date: Date(), hasProfile: false, daysUntilBirthday: 0, userName: nil)
        }
        let day = defaults?.integer(forKey: "birth_day") ?? 1
        let month = defaults?.integer(forKey: "birth_month") ?? 1
        let name = defaults?.string(forKey: "user_name")
        let days = Self.daysUntilNextBirthday(month: month, day: day)
        return BirthdayEntry(
            date: Date(),
            hasProfile: true,
            daysUntilBirthday: days,
            userName: (name?.isEmpty ?? true) ? nil : name
        )
    }

    private static func daysUntilNextBirthday(month: Int, day: Int) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var comps = calendar.dateComponents([.year], from: today)
        comps.month = month
        comps.day = day
        var next = calendar.date(from: comps) ?? today
        if next < today {
            next = calendar.date(byAdding: .year, value: 1, to: next) ?? next
        }
        if calendar.isDate(next, inSameDayAs: today) {
            return 0
        }
        return calendar.dateComponents([.day], from: today, to: next).day ?? 0
    }
}

// MARK: - View

private let bgGradient = LinearGradient(
    colors: [
        Color(red: 0.024, green: 0.024, blue: 0.06),
        Color(red: 0.11, green: 0.06, blue: 0.16),
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)

struct BirthdayWidgetEntryView: View {
    var entry: BirthdayProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            if !entry.hasProfile {
                emptyView
            } else if family == .systemSmall {
                smallView
            } else {
                mediumView
            }
        }
        .containerBackground(for: .widget) { bgGradient }
    }

    private var emptyView: some View {
        VStack(spacing: 6) {
            Image(systemName: "gift.fill")
                .font(.title2)
                .foregroundStyle(Color(red: 0.66, green: 0.35, blue: 0.97))
            Text("Открой BirthDay OS")
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var smallView: some View {
        VStack(spacing: 4) {
            Text("ДО ДР")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(red: 0.66, green: 0.35, blue: 0.97))
                .tracking(1.2)
            Text("\(entry.daysUntilBirthday)")
                .font(.system(size: 42, weight: .bold, design: .serif))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(daysWord(entry.daysUntilBirthday))
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.55))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var mediumView: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("ДО ДНЯ РОЖДЕНИЯ")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color(red: 0.66, green: 0.35, blue: 0.97))
                    .tracking(1.2)
                if let name = entry.userName {
                    Text(name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
                Spacer()
                Text(daysWord(entry.daysUntilBirthday))
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
            Text("\(entry.daysUntilBirthday)")
                .font(.system(size: 48, weight: .bold, design: .serif))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func daysWord(_ n: Int) -> String {
        let mod10 = n % 10
        let mod100 = n % 100
        if (11...14).contains(mod100) { return "дней" }
        switch mod10 {
        case 1: return "день"
        case 2, 3, 4: return "дня"
        default: return "дней"
        }
    }
}

// MARK: - Widget

struct BirthdayWidget: Widget {
    let kind: String = "BirthdayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BirthdayProvider()) { entry in
            BirthdayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("До дня рождения")
        .description("Обратный отсчёт до твоего следующего дня рождения.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
