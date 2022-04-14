//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Fabio Nisci on 05/04/22.
//

import Foundation

enum NetworkError: Error {
    case networkError
    case malformedURL
    case malformedData
}

protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, NetworkError>) -> Void)
}

final class DefaultNetworkService: NetworkService {
    
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, NetworkError>) -> Void) {
        
        guard let urlRequest = request.urlRequest else {
            return completion(.failure(.malformedURL))
        }

        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                return completion(.failure(.networkError))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(.networkError))
            }
            
            guard let data = data else {
                return completion(.failure(.malformedData))
            }
            
            do {
                let decoded = try request.decode(data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.malformedData))
            }
        }
        task.resume()
    }
}



