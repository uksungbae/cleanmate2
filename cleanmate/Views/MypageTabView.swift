//
//  MypageTabView.swift
//  cleanmate
//
//  Created by 김선규 on 11/27/23.
//

import SwiftUI

struct MypageTabView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ProfileManagementView()) {
                    VStack(alignment: .leading) {
                        Text("프로필 관리")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("사진 변경, 닉네임 변경, 비밀번호 변경 등")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                NavigationLink(destination: CleaningCategoryView()) {
                    VStack(alignment: .leading) {
                        Text("청소 카테고리")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("욕실 청소, 냉장고 청소, 에어컨 청소 등")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                NavigationLink(destination: LogoutView()) {
                    VStack(alignment: .leading) {
                        Text("로그아웃")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.red)
                    }
                    .padding()
                }
            }
            .navigationTitle("마이페이지")
        }
    }
}


//프로필 관리
struct ProfileManagementView: View {
    var body: some View {
        List {
            NavigationLink(destination: MyProfileView()) {
                VStack{
                    Text("내 프로필")

                }
               
                
            }
            NavigationLink(destination: ChangePasswordView()) {
                Text("비밀번호 변경")
            }
        }
        .navigationTitle("프로필 관리")
    }
}

// 내 프로필 페이지
struct MyProfileView: View {
    var body: some View {
        Text("내 프로필 페이지")
    }
}

// 비밀번호 변경 페이지
struct ChangePasswordView: View {
    var body: some View {
        Text("비밀번호 변경 페이지")
    }
}

// 청소 카테고리 페이지
struct CleaningCategoryView: View {
    struct CleaningItem: Identifiable {
        var id = UUID()
        var name: String
        var frequency: String
        var isSelected: Bool
    }

    @State private var cleaningItems = [
        CleaningItem(name: "욕실 청소", frequency: "7일", isSelected: false),
        CleaningItem(name: "냉장고 청소", frequency: "10일", isSelected: false),
        CleaningItem(name: "에어컨 청소", frequency: "7일", isSelected: false)
    ]
    
    @State private var newCategoryName = ""
    @State private var newCategoryFrequency = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(cleaningItems) { item in
                    HStack {
                        VStack{
                            Text(item.name)
                                .font(.system(size: 24))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(item.frequency)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                        Image(systemName: item.isSelected ? "checkmark.circle.fill" : "circle")
                            .onTapGesture {
                                toggleSelection(for: item)
                            }
                    }
                }
                .onDelete(perform: deleteCategory)

                Section {
                    TextField("청소 이름", text: $newCategoryName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("청소 주기", text: $newCategoryFrequency)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("추가", action: addCategory)
                }
                .padding(5)
            }
        }
        .navigationTitle("청소 카테고리 페이지")
    }

    func deleteCategory(at offsets: IndexSet) {
        cleaningItems.remove(atOffsets: offsets)
    }

    func addCategory() {
        guard !newCategoryName.isEmpty && !newCategoryFrequency.isEmpty else { return }
        let newItem = CleaningItem(name: newCategoryName, frequency: newCategoryFrequency, isSelected: false)
        cleaningItems.append(newItem)
        newCategoryName = ""
        newCategoryFrequency = ""
    }

    func toggleSelection(for item: CleaningItem) {
        if let index = cleaningItems.firstIndex(where: { $0.id == item.id }) {
            cleaningItems[index].isSelected.toggle()
        }
    }
}



// 로그아웃 페이지
struct LogoutView: View {
    var body: some View {
        Text("로그아웃 페이지")
    }
}

struct MypageTabView_Previews: PreviewProvider {
    static var previews: some View {
        MypageTabView()
    }
}
