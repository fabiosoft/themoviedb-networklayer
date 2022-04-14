//
//  PopularMovieRequest.swift
//  NetworkLayer
//
//  Created by Fabio Nisci on 05/04/22.
//

import UIKit

struct PopularMovieRequest: DataRequest {
    
    private let baseURL: String = "https://api.themoviedb.org/3"
    private let apiKey: String = "xxxxxx" //https://www.themoviedb.org/settings/api

    var url: URL? {
        let path: String = "/movie/popular" // "/movie/popular"
        return URL(string: baseURL)?.appendingPathComponent(path)
    }
    
    var queryItems: [String : String] {
        [
            "api_key": apiKey
        ]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> [Movie] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        do{
            let response = try decoder.decode(MoviesResponse.self, from: data)
            return response.results ?? []
        }catch let error{
            fatalError(String(describing: error))
        }
        
    }
    
}

extension PopularMovieRequest : Equatable {
    
}

struct ImageRequest: DataRequest {
    private let baseURL: String = "https://image.tmdb.org/t/p/w500/"
    private var _urlPath: URL?
    
    init(url: String){
        self.url = URL(string: url)
    }
    
    var url: URL? {
        set{
            _urlPath = newValue
        }
        get{
            guard let path = _urlPath?.absoluteString else {
                return nil
            }
            return URL(string: baseURL)?.appendingPathComponent(path)
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> UIImage? {
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}
