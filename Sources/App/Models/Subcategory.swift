import Vapor
import FluentProvider
import HTTP

final class Subcategory: Model {
    let storage = Storage()
    
    var name: String
    var src: String
    let categoryId: Identifier

    struct Keys {
        static let id = "id"
        static let name = "name"
        static let src = "src"
        static let categoryId = "category_id"
    }
    
    init(name: String, src: String, categoryId: Identifier) {
        self.name = name
        self.src = src
        self.categoryId = categoryId
    }

    init(row: Row) throws {
        name = try row.get(Subcategory.Keys.name)
        src = try row.get(Subcategory.Keys.src)
        categoryId = try row.get(Subcategory.Keys.categoryId)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Subcategory.Keys.name, name)
        try row.set(Subcategory.Keys.src, src)
        try row.set(Subcategory.Keys.categoryId, categoryId)
        return row
    }
}

extension Subcategory: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Subcategory.Keys.name)
            builder.string(Subcategory.Keys.src)
            builder.parent(Category.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Subcategory: JSONConvertible {
    
    convenience init(json: JSON) throws {
        self.init(
            name: try json.get(Subcategory.Keys.name),
            src: try json.get(Subcategory.Keys.src),
            categoryId: try json.get(Subcategory.Keys.categoryId)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Subcategory.Keys.id, id)
        try json.set(Subcategory.Keys.name, name)
        try json.set(Subcategory.Keys.src, src)
        try json.set(Subcategory.Keys.categoryId, categoryId)
        return json
    }
}

extension Subcategory: ResponseRepresentable { }

extension Subcategory: Updateable {
    
    public static var updateableKeys: [UpdateableKey<Subcategory>] {
        return [
            UpdateableKey(Subcategory.Keys.name, String.self, { subcategory, name in
                subcategory.name = name
            }),
            UpdateableKey(Subcategory.Keys.src, String.self, { subcategory, src in
                subcategory.src = src
            })
        ]
    }
}

extension Subcategory {
    
    var category: Parent<Subcategory, Category> {
        return parent(id: categoryId)
    }    
}


