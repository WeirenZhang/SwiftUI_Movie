import Foundation
import GRDB
import IdentifiedCollections

public struct AllMoviesQuery: FetchKeyRequest {
    public let ordering: SortOrder?
    public let searchText: String?
    
    public init(ordering: SortOrder? = .forward, searchText: String? = nil) {
        self.ordering = ordering
        self.searchText = searchText
    }
    
    public func fetch(_ db: Database) throws -> MovieCollection {
        let rows = try Movie.all().order(ordering?.by(Movie.Columns.id)).fetchAll(db)
        
        if let searchText, !searchText.isEmpty {
            return .init(
                uncheckedUniqueElements: rows.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            )
        }
        return .init(uncheckedUniqueElements: rows)
    }
}

public struct AllTheatersQuery: FetchKeyRequest {
    public let ordering: SortOrder?
    public let searchText: String?
    
    public init(ordering: SortOrder? = .forward, searchText: String? = nil) {
        self.ordering = ordering
        self.searchText = searchText
    }
    
    public func fetch(_ db: Database) throws -> TheaterCollection {
        let rows = try Theater.all().order(ordering?.by(Theater.Columns.id)).fetchAll(db)
        
        if let searchText, !searchText.isEmpty {
            return .init(
                uncheckedUniqueElements: rows.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            )
        }
        return .init(uncheckedUniqueElements: rows)
    }
}

public struct MovieQuery: FetchKeyRequest {
    let movie_id: String
    
    public init(movie_id: String) {
        self.movie_id = movie_id
    }
    
    public func fetch(_ db: Database) throws -> Movie? {
        try Movie.filter(Column("movie_id") == movie_id).fetchOne(db)
    }
}

public struct TheaterQuery: FetchKeyRequest {
    let theater_id: String
    
    public init(theater_id: String) {
        self.theater_id = theater_id
    }
    
    public func fetch(_ db: Database) throws -> Theater? {
        try Theater.filter(Column("theater_id") == theater_id).fetchOne(db)
    }
}

extension FetchRequest where RowDecoder: FetchableRecord & Identifiable {
    public func fetchIdentifiedArray(_ db: Database) throws -> IdentifiedArrayOf<RowDecoder> {
        try IdentifiedArray(fetchCursor(db))
    }
}

extension DatabaseReader {
    
    public func movies(ordering: SortOrder? = .forward) -> MovieCollection {
        (try? read { try AllMoviesQuery(ordering: ordering).fetch($0) }) ?? []
    }
    
    public func theaters(ordering: SortOrder? = .forward) -> TheaterCollection {
        (try? read { try AllTheatersQuery(ordering: ordering).fetch($0) }) ?? []
    }
    
    public func movie(movie_id: String) -> Movie? {
        try! read { try MovieQuery(movie_id: movie_id).fetch($0) }
    }
    
    public func theater(theater_id: String) -> Theater? {
        try! read { try TheaterQuery(theater_id: theater_id).fetch($0) }
    }
}

public extension IdentifiedArray where Element == Theater {
    var csv: String { self.map(\.name).joined(separator: ", ") }
}

public extension IdentifiedArray where Element == Movie {
    var csv: String { self.map(\.title).joined(separator: ", ") }
}
