//
//  PopularMoviesURLProtocol.swift
//  NetworkLayerTests
//
//  Created by Fabio Nisci on 06/04/22.
//

import Foundation
@testable import themoviedb_networklayer

class PopularMoviesURLProtocol: URLProtocol {
    // this maps URLs to test data
    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = Self.loadingHandler else {
            self.client?.urlProtocol(self, didFailWithError: NSError(domain: "PopularMoviesURLProtocol", code: 400))
            return
        }
        
        let (response, data, _) = handler(request)
        if let data = data {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        }
        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
