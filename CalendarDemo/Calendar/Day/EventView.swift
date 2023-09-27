//
//  EventView.swift
//  CalendarDemo
//
//  Created by Bhuvan Bhatt on 26/09/2023.
//

import SwiftUI

struct EventView: View {
  @State var title: String
  @State var subtitle: String
  @State var backgroundColor: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text(title)
          .font(.headline)
        Spacer()
      }
      HStack {
        Text(subtitle)
        Spacer()
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(backgroundColor)
    .cornerRadius(6)
  }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
      EventView(title: "Event Title",
                subtitle: "11:30 - 12:30 (60 mins)",
                backgroundColor: Color(uiColor: .random()))
    }
}
