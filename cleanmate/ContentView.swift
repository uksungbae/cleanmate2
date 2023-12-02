//
//  ContentView.swift
//  cleanmate
//
//  Created by 배성욱mac on 2023/11/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChallengeTabView()
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("챌린지")
                }
            CalendarTabView()
                .tabItem {
                    Label("캘린더", systemImage: "calendar")
                }
            
            SearchTabView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("검색")
                }
            
            MateTabView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("친구맺기")
                }
            
            MypageTabView()
                .tabItem {
                    Image(systemName: "book.pages.fill")
                    Text("마이페이지")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
