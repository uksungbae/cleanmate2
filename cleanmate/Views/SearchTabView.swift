//
//  BlueTabView.swift
//  cleanmate
//
//  Created by 김선규 on 11/20/23.
//

import SwiftUI

struct CleaningInfo: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let youtubeLink: String? // 유튜브 링크 추가
    let category: String // 카테고리를 위한 새로운 속성

}

let cleaningInfoData = [
    CleaningInfo(title: "bathroom", description: "욕실 청소하는 방법과 팁", youtubeLink: "https://www.youtube.com/watch?v=ig6NU9oyb54", category: "bathroom"),
    CleaningInfo(title: "kitchen", description: "부엌을 청소하는 방법과 팁", youtubeLink: "https://www.youtube.com/watch?v=your_youtube_video_id", category: "kitchen"),
    // 나머지 청소 정보들...
]

struct Search: View {
    @State private var searchText = ""
    @State private var searchResults: [CleaningInfo] = []

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearchButtonClicked: search)
                    .padding()

                List(searchResults) { result in
                    NavigationLink(destination: CleaningInfoDetailView(info: result)) {
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.headline)
                            Text(result.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            // 유튜브 버튼 추가
                            if let youtubeLink = result.youtubeLink {
                                Button(action: {
                                    openYoutubeLink(youtubeLink)
                                }) {
                                    Text("유튜브로 보기")
                                        .foregroundColor(.blue)
                                        .font(.footnote)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("검색 결과")
            }
        }
    }

    private func search() {
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchResults = cleaningInfoData.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // 유튜브 링크를 여는 함수
    private func openYoutubeLink(_ link: String) {
        if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct SearchTabView: View {
    
    @State private var searchText = ""
        @State private var searchResults: [CleaningInfo] = []
    
    
    var body: some View {
            NavigationView {
                VStack {
                    SearchBar(text: $searchText, onSearchButtonClicked: search)
                        .padding()

                    List(searchResults) { result in
                        NavigationLink(destination: CleaningInfoDetailView(info: result)) {
                            VStack(alignment: .leading) {
                                Text(result.title)
                                    .font(.headline)
                                Text(result.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .navigationTitle("검색 ")
                }
            }
        }

        private func search() {
            if searchText.isEmpty {
                searchResults = []
            } else {
                searchResults = cleaningInfoData.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }
            }
        }
    }

    struct SearchBar: View {
        @Binding var text: String
        var onSearchButtonClicked: () -> Void

        var body: some View {
            HStack {
                TextField("검색어를 입력하세요", text: $text)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Button(action: {
                    self.onSearchButtonClicked()
                }) {
                    Text("검색")
                        .foregroundColor(.blue)
                }
            }
        }
    }

    struct CleaningInfoDetailView: View {
        let info: CleaningInfo

        var body: some View {
            VStack {
                Text(info.title)
                    .font(.largeTitle)
                Text(info.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
            }
            .navigationTitle(info.title)
        }
    }
