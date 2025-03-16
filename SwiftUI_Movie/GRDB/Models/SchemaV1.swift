import Dependencies
import Foundation
import GRDB
import IdentifiedCollections
import Tagged

/// Temporary record that represents a Movie prior to being inserted into the database. Saves us from having to play
/// games with the `Movie.id` attribute.
public struct PendingMovie: Codable, FetchableRecord, PersistableRecord {
    
    public let movie_id: String
    public let title: String
    public let en: String
    public let release_movie_time: String
    public let thumb: String
    
    public init(model: MovieListModel) {
        self.movie_id = model.id
        self.title = model.title
        self.en = model.en
        self.release_movie_time = model.release_movie_time
        self.thumb = model.thumb
    }
    
    public static let databaseTableName: String = "Movie"
}

public struct Movie: Codable, Identifiable, FetchableRecord, MutablePersistableRecord {
    
    public typealias ID = Tagged<Self, Int64>
    public let id: ID
    public let movie_id: String
    public let title: String
    public let en: String
    public var release_movie_time: String
    public var thumb: String
    
    public static let databaseTableName: String = PendingMovie.databaseTableName
}

extension Movie {
    
    public enum Columns {
        
        public static let id = Column(CodingKeys.id)
        public static let movie_id = Column(CodingKeys.movie_id)
        public static let title = Column(CodingKeys.title)
        public static let en = Column(CodingKeys.en)
        public static let release_movie_time = Column(CodingKeys.release_movie_time)
        public static let thumb = Column(CodingKeys.thumb)
    }
    
    static func createTable(in db: Database) throws {
        
        try db.create(table: Self.databaseTableName) { table in
            table.autoIncrementedPrimaryKey(Columns.id)
            table.column(Columns.movie_id, .text).notNull()
            table.column(Columns.title, .text).notNull()
            table.column(Columns.en, .text)
            table.column(Columns.release_movie_time, .text)
            table.column(Columns.thumb, .text).notNull()
        }
    }
}

extension Movie: Hashable, Sendable {}
public typealias MovieCollection = IdentifiedArrayOf<Movie>

extension Movie {
    
    public static func insert(in db: Database, entry: MovieListModel) throws -> Movie {
        let movie = try PendingMovie(model: entry).insertAndFetch(db, as: Movie.self)
        return movie
    }
}

/// Temporary record that represents a Movie prior to being inserted into the database. Saves us from having to play
/// games with the `Movie.id` attribute.
public struct PendingTheater: Codable, FetchableRecord, PersistableRecord {
    
    public let theater_id: String
    public let name: String
    public let adds: String
    public let tel: String
    
    public init(model: TheaterInfoModel) {
        self.theater_id = model.id
        self.name = model.name
        self.adds = model.adds
        self.tel = model.tel
    }
    
    public static let databaseTableName: String = "Theater"
}

public struct Theater: Codable, Identifiable, FetchableRecord, MutablePersistableRecord {
    
    public typealias ID = Tagged<Self, Int64>
    public let id: ID
    public let theater_id: String
    public let name: String
    public let adds: String
    public let tel: String
    
    public static let databaseTableName: String = PendingTheater.databaseTableName
}

extension Theater {
    
    public enum Columns {
        
        public static let id = Column(CodingKeys.id)
        public static let theater_id = Column(CodingKeys.theater_id)
        public static let name = Column(CodingKeys.name)
        public static let adds = Column(CodingKeys.adds)
        public static let tel = Column(CodingKeys.tel)
    }
    
    static func createTable(in db: Database) throws {
        
        try db.create(table: Self.databaseTableName) { table in
            table.autoIncrementedPrimaryKey(Columns.id)
            table.column(Columns.theater_id, .text).notNull()
            table.column(Columns.name, .text).notNull()
            table.column(Columns.adds, .text)
            table.column(Columns.tel, .text)
        }
    }
}

extension Theater: Hashable, Sendable {}
public typealias TheaterCollection = IdentifiedArrayOf<Theater>

extension Theater {
    
    public static func insert(in db: Database, entry: TheaterInfoModel) throws -> Theater {
        let theater = try PendingTheater(model: entry).insertAndFetch(db, as: Theater.self)
        return theater
    }
}

func migration(_ db: Database) throws {
    try Movie.createTable(in: db)
    try Theater.createTable(in: db)
}

extension DatabaseWriter {
    
    func migrate() throws {
        var migrator = DatabaseMigrator()
        
#if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
#endif
        
        migrator.registerMigration("SchemaV1") { db in
            try migration(db)
            
#if targetEnvironment(simulator)
            if !isTesting {
                try Movie.deleteAll(db)
                try Theater.deleteAll(db)
            }
#endif
        }
        
        try migrator.migrate(self)
    }
}

extension TableDefinition {
    
    @discardableResult
    func autoIncrementedPrimaryKey(_ column: Column) -> ColumnDefinition {
        autoIncrementedPrimaryKey(column.name)
    }
    
    @discardableResult
    func column(_ name: Column, _ kind: Database.ColumnType?) -> ColumnDefinition {
        column(name.name, kind)
    }
}

extension Tagged: @retroactive SQLExpressible
where RawValue: SQLExpressible {}

extension Tagged: @retroactive StatementBinding
where RawValue: StatementBinding {}

extension Tagged: @retroactive StatementColumnConvertible
where RawValue: StatementColumnConvertible {}

extension Tagged: @retroactive DatabaseValueConvertible
where RawValue: DatabaseValueConvertible {}
