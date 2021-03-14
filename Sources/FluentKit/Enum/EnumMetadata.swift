public final class EnumMetadata: Model, Fields {
    public static let schema = "_fluent_enums"

    static var migration: Migration {
        return EnumMetadataMigration()
    }

    //@ID(key: .id)
    @IDProperty<EnumMetadata, UUID>(key:.id)
    public var id: UUID?

    @Field(key: "name")
    //@FieldProperty<EnumMetadata, String>(key: "name")
    public var name: String

    //@Field(key: "case")
    @FieldProperty<EnumMetadata, String>(key: "case")
    var `case`: String

    @Cap
    public var greeting: String = "hello"

    public init() { }

    init(id: IDValue? = nil, name: String, `case`: String) {
        self.id = id
        self.name = name
        self.case = `case`
    }
}


public final class Voicemail {
    @Cap
    public var greeting: String = "hello"
}

let a = \Voicemail.$greeting

let b = \EnumMetadata.$greeting

let c = \EnumMetadata.$name

let d = \EnumMetadata.$case



public typealias Cap = Capitalized

@propertyWrapper public final class Capitalized {
    public var wrappedValue: String {
        didSet { wrappedValue = wrappedValue.capitalized }
    }

    public var projectedValue: Bool {
        return true
    }

    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
}

private struct EnumMetadataMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("_fluent_enums")
            .field(.id, .uuid, .identifier(auto: false))
            .field("name", .string, .required)
            .field("case", .string, .required)
            .unique(on: "name", "case")
            .ignoreExisting()
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("_fluent_enums").delete()
    }
}
