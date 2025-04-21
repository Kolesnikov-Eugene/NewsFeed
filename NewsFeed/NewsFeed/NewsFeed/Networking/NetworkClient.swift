//
//  NetworkClient.swift
//  NewsFeed
//
//  Created by Eugene Kolesnikov on 18.04.2025.
//

import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
    case taskCreationFailed

}

protocol INetworkClient {
    func send(request: NetworkRequest) async throws -> Data
    func send<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> T
}

struct NetworkClient: INetworkClient {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func send(request: NetworkRequest) async throws -> Data {
        guard let urlRequest = create(request: request) else {
            throw NetworkClientError.taskCreationFailed
        }
        var (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw NetworkClientError.urlRequestError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkClientError.urlSessionError
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkClientError.httpStatusCode(httpResponse.statusCode)
        }
        
        return data
    }
    
    func send<T: Decodable>(request: NetworkRequest, type: T.Type) async throws -> T {
        let data = try await send(request: request)
        do {
            return try parse(data: data, type)
        } catch {
            throw NetworkClientError.parsingError
        }
    }
    
    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        return urlRequest
    }
    
    private func parse<T: Decodable>(data: Data, _ type: T.Type) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
