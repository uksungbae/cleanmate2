//
//  cleanmateServer.swift
//  cleanmate
//
//  Created by 배성욱mac on 2023/11/27.
//

import UIKit

class ServerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 서버 URL
        guard let url = URL(string: "http://localhost:3000/api/endpoint") else {
            return
        }

        // HTTP 요청 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"  // 또는 "POST" 등

        // URLSession을 사용하여 요청 보내기
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 에러 처리
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // 응답 처리
            if let data = data {
                // 데이터를 원하는 형식으로 파싱 또는 처리
                print("Response: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }

        // 요청 보내기
        task.resume()
    }
}

