//
//  MateTapView.swift
//  cleanmate
//
//  Created by 김선규 on 11/27/23.
//

import SwiftUI

struct MateTabView: View {
        //요청대기 모달
        @State private var showRequestModal = false
        //걍 모달
        @State private var showModal = false
        // 경고 메시지
        @State private var alertMessage: String?
        // 입력한 아이디
        @State private var enteredID: String = ""
        // 친구 목록
        @State private var friendList: [String] = ["김선규"]
        // 대기 중인 요청 목록
        @State private var waitingRequests: [String] = ["심유정"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("요청대기"){
                    self.showRequestModal = true
                }
                .offset(x: -10)
                .sheet(isPresented: $showRequestModal) {
                                   RequestWaitingView(waitingRequests: $waitingRequests, friendList: $friendList)
                                       .offset(y: -300)
                               }
            }
            
            Text("친구 찾기")
                .padding()
            
            HStack{
                
                    TextField("아이디를 입력해주세요",  text: $enteredID)
                        .padding(.horizontal, 16)
                        .offset(x:20)
                
                Button("검색") {
                    searchButtonTapped()
                }
                .offset(x:-20)
                
            }
            
            
            List {
                Text("친구목록")
                ForEach(friendList, id: \.self) { friend in
                    HStack {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 40, height: 40)
                        
                        Text(friend)
                        
                        Spacer()
                        
                        Button("챌린지 보기") {
                            // 챌린지 보기 버튼 동작 추가
                            
                        }
                    }
                }
                
                
            }
        }
        .alert(isPresented: $showModal) {
            Alert(
                title: Text("알림"),
                message: Text(alertMessage ?? ""),
                primaryButton: .default(Text("확인")),
                secondaryButton: alertMessage == "일치하는 아이디가 있습니다"
                    ? .default(Text("친구 요청 보내기"), action: {
                        // 여기에 친구 요청 보내기 동작 추가
                    })
                : .cancel()
            )
        }

    }
    func searchButtonTapped() {
            // 데이터베이스에서 아이디 검색 로직 추가
            // 아래는 예시로, 실제 로직은 데이터베이스와 연동하여 구현해야 합니다.
            let isIDMatched = checkIfIDExists(enteredID)

            // 결과에 따라 모달 메시지 설정
            alertMessage = isIDMatched ? "일치하는 아이디가 있습니다" : "일치하는 아이디가 없습니다"
            showModal = true
        }


        // 예시로 사용하기 위한 함수
        func checkIfIDExists(_ id: String) -> Bool {
            // 실제로는 여기서 데이터베이스와 연동하여 아이디를 확인해야 합니다.
            // 이 함수는 단순히 예시로 사용되는 것이므로 데이터베이스 연동이 필요합니다.

            return id.lowercased() == "test"
        }
}

struct RequestWaitingView: View {
    @Environment(\.presentationMode) var presentation
    @Binding var waitingRequests: [String]
    @Binding var friendList: [String]
    
    var body: some View {
        VStack {
            HStack {
                Button("X") {
                    presentation.wrappedValue.dismiss()
                }
                .offset(x: -90)
                
                Text("대기중인 요청")
                    .font(.system(size: 28))
            }
            
            Divider()
            
            ForEach(waitingRequests, id: \.self) { request in
                HStack {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                        
                        Circle()
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: 40, height: 40)
                    }
                    Text(request)
                    
                    Button("수락") {
                        acceptRequest(request)
                    }
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color(UIColor(red: 0.22, green: 0.63, blue: 0.86, alpha: 1)))
                    .cornerRadius(8)
                    
                    Button("거절") {
                        declineRequest(request)
                    }
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color(UIColor(red: 0.83, green: 0.04, blue: 0.04, alpha: 1)))
                    .cornerRadius(8)
                }
                .padding(10)
                Divider()
                    .background(Color.blue)
            }
        }
    }

    func acceptRequest(_ friend: String) {
        friendList.append(friend)
        waitingRequests.removeAll { $0 == friend }
    }

    func declineRequest(_ friend: String) {
        waitingRequests.removeAll { $0 == friend }
    }
}

//
struct MateTabView_Previews: PreviewProvider {
    static var previews: some View {
        MateTabView()
    }
}
