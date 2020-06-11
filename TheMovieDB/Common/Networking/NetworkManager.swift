//
//  NetworkManager.swift
//  TheMovieDB
//
//  Created by Abdul Basit on 12/1/19.
//  Copyright © 2019 Abdul Basit. All rights reserved.
//

import Alamofire
struct DefaultAPIRequest: APIRequest {
    let request: DataRequest
    func cancel() {
        request.cancel()
    }
}

class NetworkManager: Networking {

    public init() { }

    func get<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest {

        return execute(url: request.path.url,
                       method: .get,
                       parameters: request.parameters,
                       encoder: URLEncodedFormParameterEncoder.default,
                       headers: request.headers,
                       completion: completion)

    }

    func post<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest {

        return execute(url: request.path.url,
                       method: .post,
                       parameters: request.parameters,
                       encoder: URLEncodedFormParameterEncoder.default,
                       headers: request.headers,
                       completion: completion)
    }

    func put<T: Decodable, R: Encodable>(request: RequestBuilder<R>, completion: @escaping Completion<T>) -> APIRequest {

        return execute(url: request.path.url,
                       method: .put,
                       parameters: request.parameters,
                       encoder: URLEncodedFormParameterEncoder.default,
                       headers: request.headers,
                       completion: completion)
    }

    func execute<T: Decodable, R: Encodable>(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: R?,
        encoder: ParameterEncoder,
        headers: [String: String]?,
        completion: @escaping Completion<T>) -> APIRequest {

        let headers: HTTPHeaders? = headers.map({ HTTPHeaders($0) })

        let dataRequest = AF.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoder: encoder,
                                     headers: headers)
            .validate()
            .responseDecodable { (response: DataResponse<T,AFError>) in
                completion(APIResponse(result: response.result))
        }

        return DefaultAPIRequest(request: dataRequest)
    }

}
