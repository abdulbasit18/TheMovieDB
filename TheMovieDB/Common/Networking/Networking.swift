//
//  Networking.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 12/1/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Foundation
import Alamofire
//1. Define entire app endpoints and environment
struct APIPathBuilder {
    let url: String

    init(baseURL: String , endPoint: String) {
        self.url = baseURL + endPoint
    }
}

//2. Request Builder
struct RequestBuilder<Parameter: Encodable> {
    let path: APIPathBuilder
    let parameters: Parameter
    let headers: [String: String]?

    init(path: APIPathBuilder, parameters: Parameter, headers: [String: String]? = nil){
        self.path = path
        self.parameters = parameters
        self.headers = headers
    }
}

//3. API Response
struct APIResponse<T> {
    public let result: Result<T, AFError>
}

//4. Cancelable Request
protocol APIRequest {
    func cancel()
}

//5. Perform API request using differnt restful methods
protocol Networking {
    typealias Completion<T> = (APIResponse<T>) -> Void

    @discardableResult
    func get<T: Decodable, R: Encodable>(
        request: RequestBuilder<R>,
        completion: @escaping Completion<T>) -> APIRequest

    func post<T: Decodable, R: Encodable>(
        request: RequestBuilder<R>,
        completion: @escaping Completion<T>) -> APIRequest

    func put<T: Decodable, R: Encodable>(
        request: RequestBuilder<R>,
        completion: @escaping Completion<T>) -> APIRequest
}
