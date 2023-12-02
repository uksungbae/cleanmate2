//
//  GreenTabView.swift
//  cleanmate
//
//  Created by 김선규 on 11/20/23.
//

import SwiftUI
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cleaningCategories = ["거실", "부엌", "화장실", "침실"]
    var completedCategories: Set<String> = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // TableView 설정
        tableView.delegate = self
        tableView.dataSource = self
    }

    // TableView DataSource 메서드 구현
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cleaningCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cleaningCell", for: indexPath)
        let category = cleaningCategories[indexPath.row]

        cell.textLabel?.text = category

        // 체크박스 설정
        if completedCategories.contains(category) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    // TableView Delegate 메서드 구현
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedCategory = cleaningCategories[indexPath.row]

        // 완료 여부 토글
        if completedCategories.contains(selectedCategory) {
            completedCategories.remove(selectedCategory)
        } else {
            completedCategories.insert(selectedCategory)
        }

        // TableView 갱신
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // 청소 완료 버튼 액션
    @IBAction func completeCleaning(_ sender: UIButton) {
        // 완료된 청소 카테고리 출력 또는 다른 작업 수행
        print("완료된 청소 카테고리: \(completedCategories)")
    }
}

struct ChallengeTabView: View {
    
    @State private var cleaningCategories = ["거실", "부엌", "화장실", "침실"]
       @State private var completedCategories: Set<String> = []
       @State private var isGraphVisible = true // 항상 표시되도록 변경
    
    
    var body: some View {
            NavigationView {
                VStack {
                    // 원형 그래프 항상 표시
                    PieChart(data: completedCategories.count)
                        .frame(width: 200, height: 200)
                        .padding()

                    List {
                        ForEach(cleaningCategories, id: \.self) { category in
                            HStack {
                                Text(category)
                                Spacer()
                                if completedCategories.contains(category) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.green) // 녹색으로 표시
                                }
                            }
                            .onTapGesture {
                                self.toggleCompletion(category)
                            }
                        }
                    }

                    // 추가한 부분: 완료 버튼
                    Button("완료") {
                        self.completeCleaning()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .navigationTitle("CleanMate")
            }
        }

        private func toggleCompletion(_ category: String) {
            if completedCategories.contains(category) {
                completedCategories.remove(category)
            } else {
                completedCategories.insert(category)
            }
        }

        // 추가한 부분: 서버로 데이터 전송
        private func completeCleaning() {
            let serverURL = URL(string: "http://localhost:3000/completeCleaning")!

            let requestData: [String: Any] = ["completedCategories": Array(completedCategories)]

            var request = URLRequest(url: serverURL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
            } catch {
                print("Error serializing JSON:", error)
                return
            }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // 서버 응답 처리
                if let error = error {
                    print("Error sending data to server:", error)
                } else if let data = data {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Server response:", jsonResponse)
                    } catch {
                        print("Error parsing server response:", error)
                    }
                }
            }

            task.resume()
        }
    }

    // 추가한 부분: PieChart 뷰
    struct PieChart: View {
        var data: Int

        var body: some View {
            ZStack {
                // 녹색 부분 (완료된 카테고리에 따라 조절)
                Circle()
                    .trim(from: 0, to: CGFloat(data) / 4) // 4로 나누어 1/4까지만 표시하도록 설정
                    .stroke(Color.green, lineWidth: 30)

                // 회색 부분
                Circle()
                    .trim(from: CGFloat(data) / 4, to: 1) // 나머지 3/4를 회색으로 표시
                    .stroke(Color.gray, lineWidth: 30)
            }
            .rotationEffect(.degrees(-90)) // 12시 방향에서 시작되도록 회전
        }
    }
