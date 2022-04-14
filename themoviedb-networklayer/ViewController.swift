//
//  ViewController.swift
//  themoviedb-networklayer
//
//  Created by Fabio Nisci on 14/04/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let session = URLSession(configuration: .default, delegate: SSLPinningManager(), delegateQueue: nil)
        let vm = PopularMovieListDefaultViewModel(networkService: DefaultNetworkService(session: session))
        vm.onFetchMovieSucceed = {
            print(vm.movies)

//            let firstMovie = vm.movies.first!
//            let imageRequest = ImageRequest(url: firstMovie.posterPath!)
//            DefaultNetworkService().request(imageRequest) { [weak self] result in
//                guard let _ = self else {return}
//                switch result{
//                case .success(let image):
//                    debugPrint(String(describing: image))
//                case .failure(let error):
//                    debugPrint(String(describing: error))
//                    break
//                }
//            }

        }
        vm.onFetchMovieFailure = { error in
            print("\(error)")
        }
        vm.fetchMovie()
        
        
    }


}

