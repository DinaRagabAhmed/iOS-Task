//
//  URLSessionProvider.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//


import Foundation

final class URLSessionProvider: ProviderProtocol {
    
    static let shared = URLSessionProvider()

    private var session: URLSessionProtocol
    
    private init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (NetworkResponse<T>) -> ()) where T: Decodable {
        print("network")
        let request = URLRequest(service: service)
        
        let task = session.dataTask(request: request, completionHandler: { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
    
            self?.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        })
        task.resume()
    }
    
    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (NetworkResponse<T>) -> ()) {
        guard error == nil else { return completion(.failure(.generalError)) }
        guard let response = response else { return completion(.failure(.generalError)) }
        
        switch response.statusCode {
        case 200...299:
            guard let data = data, let model = try? JSONDecoder().decode(T.self, from: data) else { return completion(.failure(.generalError)) }
            completion(.success(model))
        case 500...504:
            completion(.failure(.serverError))
        default:
            completion(.failure(.generalError))
        }
    }
    
    func cancelAllRequests() {
        session.cancelAllRequests()
    }
}

