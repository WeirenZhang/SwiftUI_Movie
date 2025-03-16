//
//  PopularItemsRequest.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 2/12/26.
//

import Kanna
import Combine
import Foundation
import ComposableArchitecture

protocol Request {
    associatedtype Response

    var publisher: AnyPublisher<Response, AppError> { get }
}

extension Request {
    func response() async -> Result<Response, AppError> {
        await publisher.receive(on: DispatchQueue.main).async()
    }

    func mapAppError(error: Error) -> AppError {
        switch error {
        case is ParseError:
            return .parseFailed

        case is URLError:
            return .networkingFailed

        case is DecodingError:
            return .parseFailed

        default:
            return error as? AppError ?? .unknown
        }
    }
}

private extension Publisher {
    func genericRetry() -> Publishers.Retry<Self> {
        retry(3)
    }

    func async() async -> Result<Output, Failure> where Failure == AppError {
        await withCheckedContinuation { continuation in
            var cancellable: AnyCancellable?
            var finishedWithoutValue = true
            cancellable = first()
                .sink { result in
                    switch result {
                    case .finished:
                        if finishedWithoutValue {
                            continuation.resume(returning: .failure(.unknown))
                        }
                    case let .failure(error):
                        continuation.resume(returning: .failure(error))
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    finishedWithoutValue = false
                    continuation.resume(returning: .success(value))
                }
        }
    }
}

struct GetMovieListRequest: Request {
    let tab: String
    let page: Int

    var publisher: AnyPublisher<[MovieListModel], AppError> {
        URLSession.shared.dataTaskPublisher(for: URLUtil.getMovieList(page: String(page), tab: tab))
            .genericRetry()
            //.tryMap ({ try Kanna.HTML(html: $0.data, encoding: .utf8) })
            .tryMap() {return $0.data}
            .decode(type: [MovieListModel].self, decoder: JSONDecoder())
            //.tryMap { (Parser.parsePageNum(doc: $0), try Parser.parseGalleries(doc: $0)) }
            .mapError(mapAppError)
            .eraseToAnyPublisher()
    }
}

struct GetTheaterListRequest: Request {

    var publisher: AnyPublisher<[TheaterAreaModel], AppError> {
        URLSession.shared.dataTaskPublisher(for: URLUtil.getTheaterList())
            .genericRetry()
            //.tryMap ({ try Kanna.HTML(html: $0.data, encoding: .utf8) })
            .tryMap() {return $0.data}
            .decode(type: [TheaterAreaModel].self, decoder: JSONDecoder())
            //.tryMap { (Parser.parsePageNum(doc: $0), try Parser.parseGalleries(doc: $0)) }
            .mapError(mapAppError)
            .eraseToAnyPublisher()
    }
}

struct GetTheaterResultListRequest: Request {
    let cinema_id: String

    var publisher: AnyPublisher<[TheaterDateItemModel], AppError> {
        URLSession.shared.dataTaskPublisher(for: URLUtil.getTheaterResultList(cinema_id: cinema_id) )
            .genericRetry()
            //.tryMap ({ try Kanna.HTML(html: $0.data, encoding: .utf8) })
            .tryMap() {return $0.data}
            .decode(type: [TheaterDateItemModel].self, decoder: JSONDecoder())
            //.tryMap { (Parser.parsePageNum(doc: $0), try Parser.parseGalleries(doc: $0)) }
            .mapError(mapAppError)
            .eraseToAnyPublisher()
    }
}

struct GetMovieInfoRequest: Request {
    let movie_id: String

    var publisher: AnyPublisher<[MovieInfoModel], AppError> {
        URLSession.shared.dataTaskPublisher(for: URLUtil.getMovieInfo(movie_id: movie_id) )
            .genericRetry()
            //.tryMap ({ try Kanna.HTML(html: $0.data, encoding: .utf8) })
            .tryMap() {return $0.data}
            .decode(type: [MovieInfoModel].self, decoder: JSONDecoder())
            //.tryMap { (Parser.parsePageNum(doc: $0), try Parser.parseGalleries(doc: $0)) }
            .mapError(mapAppError)
            .eraseToAnyPublisher()
    }
}

struct GetStoreInfoRequest: Request {
    let movie_id: String

    var publisher: AnyPublisher<[StoreInfoModel], AppError> {
        URLSession.shared.dataTaskPublisher(for: URLUtil.getStoreInfo(movie_id: movie_id) )
            .genericRetry()
            //.tryMap ({ try Kanna.HTML(html: $0.data, encoding: .utf8) })
            .tryMap() {return $0.data}
            .decode(type: [StoreInfoModel].self, decoder: JSONDecoder())
            //.tryMap { (Parser.parsePageNum(doc: $0), try Parser.parseGalleries(doc: $0)) }
            .mapError(mapAppError)
            .eraseToAnyPublisher()
    }
}

struct GetMovieDateResultRequest: Request {
    let movie_id: String

    var publisher: AnyPublisher<[MovieDateTabItemModel], AppError> {
        URLSession.shared.dataTaskPublisher(for: URLUtil.getMovieDateResult(movie_id: movie_id) )
            .genericRetry()
            //.tryMap ({ try Kanna.HTML(html: $0.data, encoding: .utf8) })
            .tryMap() {return $0.data}
            .decode(type: [MovieDateTabItemModel].self, decoder: JSONDecoder())
            //.tryMap { (Parser.parsePageNum(doc: $0), try Parser.parseGalleries(doc: $0)) }
            .mapError(mapAppError)
            .eraseToAnyPublisher()
    }
}

struct GetVideoRequest: Request {
    let movie_id: String

    var publisher: AnyPublisher<[VideoModel], AppError> {
        URLSession.shared.dataTaskPublisher(for: URLUtil.getVideo(movie_id: movie_id) )
            .genericRetry()
            //.tryMap ({ try Kanna.HTML(html: $0.data, encoding: .utf8) })
            .tryMap() {return $0.data}
            .decode(type: [VideoModel].self, decoder: JSONDecoder())
            //.tryMap { (Parser.parsePageNum(doc: $0), try Parser.parseGalleries(doc: $0)) }
            .mapError(mapAppError)
            .eraseToAnyPublisher()
    }
}

