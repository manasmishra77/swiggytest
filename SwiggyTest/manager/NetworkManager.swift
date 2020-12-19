//
//  NetworkManager.swift
//  SwiggyTest
//
//  Created by Manas1 Mishra on 28/10/20.
//

import UIKit

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    struct SearchMoviePage {
        var searchKey: String
        var totalPage: Int
    }
    
    var searchMoviePage: SearchMoviePage!
    
    var apiKey: String {
        return "283e9e4f"
    }
    
    typealias Completion = (_ code: Int, _ model: Any?, _ error: Error?) -> ()
    
    struct NetworkError: Error {
        var code: Int
        var msg: String
    }
    
    enum EndPoint: String {
         
        case getMovieList = "?apikey=283e9e4f&s="
        case getMovieDetails = "?apikey=283e9e4f&i="
        
        var baseDomain: String {
            return "http://www.omdbapi.com/"
        }
        
        func getMovieListFullPath(searchKey: String, pageNo: Int) -> URL? {
            return URL(string: (baseDomain + self.rawValue + searchKey + "&page=\(pageNo)"))
            
        }
        
        func getMovieDetailsFullPath(id: String) -> URL? {
            return URL(string: (baseDomain + self.rawValue + id))
        }
    }
    
    func getMovieDetail(id: String, completion: @escaping Completion) {
        guard let url = EndPoint.getMovieDetails.getMovieDetailsFullPath(id: id) else {
            completion(451, nil, NetworkError(code: 451, msg: "url making failed") )
            return
        }
        doNetworkCall(url: url) { (code, data, error) in
            if let error = error {
                completion(code, nil, NetworkError(code: code, msg: error.localizedDescription) )
                return
            }
            let resModel = self.parseData(data as? Data, modelType: Movie.self)
            if let error = resModel.1 {
                completion(460, nil, NetworkError(code: code, msg: error.localizedDescription))
                return
            }
            if let model = resModel.0 {
                completion(code, model, nil)
            } else {
                completion(code, nil, nil)
            }
        }
    }
    
    
    
    func getMovieList(searchKey: String, pageNo: Int, completion: @escaping Completion) {
        if searchMoviePage == nil || (searchMoviePage.searchKey != searchKey) {
            searchMoviePage = nil
            doNetworkCallForMovieList(searchKey: searchKey, pageNo: pageNo, completion: completion)
            return
        } else {
            if pageNo > self.searchMoviePage.totalPage {
                completion(452, nil, NetworkError(code: 452, msg: "pageno is greater than total page") )
                return
            }
            doNetworkCallForMovieList(searchKey: searchKey, pageNo: pageNo, completion: completion)
            return
        }
        
    }
    
    func doNetworkCallForMovieList(searchKey: String, pageNo: Int, completion: @escaping Completion) {
        guard let url = EndPoint.getMovieList.getMovieListFullPath(searchKey: searchKey, pageNo: pageNo) else {
            completion(451, nil, NetworkError(code: 451, msg: "url making failed") )
            return
        }
        doNetworkCall(url: url) { (code, data, error) in
            if let error = error {
                completion(code, nil, NetworkError(code: code, msg: error.localizedDescription) )
                return
            }
            let resModel = self.parseData(data as? Data, modelType: MovieListResponse.self)
            if let error = resModel.e {
                completion(460, nil, NetworkError(code: code, msg: error.localizedDescription))
                return
            }
            if let model = resModel.m, let results = model.search {
                self.searchMoviePage = SearchMoviePage(searchKey: searchKey, totalPage: model.totalPages)
                completion(code, results, nil)
            } else {
                completion(code, nil, nil)
            }
        }
    }
    
    
    func doNetworkCall(url: URL, completion: @escaping Completion) {

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if let res = response as? HTTPURLResponse {
                if let err = error {
                    completion(res.statusCode, nil, err)
                    return
                }
                completion(res.statusCode, data, nil)
            } else {
                completion(500, nil, NetworkError(code: 500, msg: "No response"))
            }
        })

        task.resume()
    }
    
    func parseData<T: Codable>(_ data: Data?, modelType: T.Type) -> (m: T?, e: Error?) {
        guard let data = data else {
            return (nil, NetworkError(code: 450, msg: "No data"))
        }
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return (model, nil)
        } catch {
            return (nil, error)
        }
    }
    
    
}


