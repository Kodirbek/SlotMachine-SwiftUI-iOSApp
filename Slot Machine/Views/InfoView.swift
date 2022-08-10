//
//  InfoView.swift
//  Slot Machine
//
//  Created by Abduqodir's MacPro on 2022/07/19.
//

import SwiftUI

struct InfoView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      LogoView()
      
      Spacer()
      
      Form {
        Section {
          FormRowView(firstItem: "Application", secondItem: "Slot Machine")
          FormRowView(firstItem: "Compatibility", secondItem: "iPhone, iPad & Mac")
          FormRowView(firstItem: "Developer", secondItem: "Kodirbek Khamzaev")
          FormRowView(firstItem: "Designer", secondItem: "Robert Petras")
          FormRowView(firstItem: "Version", secondItem: "1.0.0")
        } header: {
          Text("Slot Machine")
        } //: Section
      } //: Form
      .font(.system(.body, design: .rounded))
    } //: VStack
    .padding(.top, 40)
    .overlay(
      Button(action: {
        audioPlayer?.stop()
        presentationMode.wrappedValue.dismiss()
      }, label: {
        Image(systemName: "xmark.circle")
          .font(.title)
      })
      .padding(.top, 30)
      .padding(.trailing, 20)
      .tint(.secondary)
      , alignment: .topTrailing
    )
    .onAppear {
      playSound(sound: "background-music", type: "mp3")
    }
  }
}

struct FormRowView: View {
  var firstItem: String
  var secondItem: String
  var body: some View {
    HStack {
      Text(firstItem)
        .foregroundColor(.gray)
      Spacer()
      Text(secondItem)
    } //: HStack
  }
}

struct InfoView_Previews: PreviewProvider {
  static var previews: some View {
    InfoView()
  }
}

