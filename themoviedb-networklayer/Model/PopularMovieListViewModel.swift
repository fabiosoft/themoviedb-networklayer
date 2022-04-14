//
//  PopularMovieListViewModel.swift
//  NetworkLayer
//
//  Created by Fabio Nisci on 05/04/22.
//

import Foundation

protocol PopularMovieListViewModel: AnyObject {
    var movies: [Movie] { set get }
    var onFetchMovieSucceed: (() -> Void)? { set get }
    var onFetchMovieFailure: ((Error) -> Void)? { set get }
    func fetchMovie()
}

final class PopularMovieListDefaultViewModel: PopularMovieListViewModel {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    var movies: [Movie] = []
    var onFetchMovieSucceed: (() -> Void)?
    var onFetchMovieFailure: ((Error) -> Void)?
    
    func fetchMovie() {
        let request = PopularMovieRequest()
        networkService.request(request) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.onFetchMovieSucceed?()
            case .failure(let error):
                self?.onFetchMovieFailure?(error)
            }
        }
    }
}
