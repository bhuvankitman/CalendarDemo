import SwiftUI
import Combine

struct DayView: View {

  @State var viewModel: DayCellViewModel
  let action = PassthroughSubject<Event, Never>()

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        weekdayAndDate
        events
        Spacer()
      }
    }
  }

  var weekdayAndDate: some View {
    VStack {
      VStack {
        Text(viewModel.date.weekdayString)
          .font(.footnote)
        Text(viewModel.date.dayString)
          .font(.title)
      }
      .frame(width: 60, height: 60)
      .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
      Spacer()
    }
  }

  var events: some View {
    VStack {
      ForEach(viewModel.events) { event in        
        EventView(title: event.title,
                  subtitle: "11:30 - 12:30 (60 mins)",
                  backgroundColor: Color(uiColor: .random()))
        .onTapGesture {
          action.send(event)
        }
      }
    }
  }
}

struct DayView_Previews: PreviewProvider {
  static var previews: some View {
    DayView(viewModel: .init(date: .now, events: [.init(title: "Team briefing", date: .now)]))
  }
}
