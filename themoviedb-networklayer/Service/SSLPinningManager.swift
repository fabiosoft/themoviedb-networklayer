//
//  SSLPinningManager.swift
//  NetworkLayer
//
//  Created by Fabio Nisci on 12/04/22.
//

import Foundation

class SSLPinningManager: NSObject{

}

extension SSLPinningManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil);
            return
        }
        
        //Get Certificate
        let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) // For Leaf 0, For Intermediate 1, For Root 2
        
        // SSL Policies for domain name check
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
        
        //Evaluate server certifiacte
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
        
        //Local and Remote certificates Data
        let remoteCertificateData:NSData =  SecCertificateCopyData(certificate!)
        let pathToCertificate = Bundle.main.path(forResource: "themoviedb.org", ofType: "cer")
        let localCertificateData:NSData = NSData(contentsOfFile: pathToCertificate!)!
        
        //Compare certificates
        if(isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)){
            let credential:URLCredential =  URLCredential(trust:serverTrust)
            debugPrint("SSL Pinnig with Certificate is successfully completed")
            completionHandler(.useCredential,credential)
        }
        else {
            debugPrint("SSL Pinnig with Certificate is failed")
            completionHandler(.cancelAuthenticationChallenge,nil)
        }
    }
}
