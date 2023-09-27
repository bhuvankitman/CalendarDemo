import Foundation

struct Event: Identifiable {
  let id: String = UUID().uuidString
  let title: String
  let date: Date

  init(title: String, date: Date) {
    self.title = title
    self.date = date
  }
}

extension Collection where Element == Event {
  static var sampleEvents: [Event] {
    [.init(title: "Travel to Birmingham", date: .now),
     .init(title: "Away vs Aston Villa ", date: .now),
     .init(title: "Travel home", date: .now),
     .init(title: "Training session", date: .now),
     .init(title: "Barcelona vs Real Madrid", date: .now),
     .init(title: "Health screening", date: .now),
     .init(title: "Team briefing", date: .now)
    ]
  }
}
