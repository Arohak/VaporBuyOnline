import Vapor
import HTTP

final class CategoryController: ResourceRepresentable {
    
    func addRoutes(drop: Droplet) {
        let basic = drop.grouped("categories")
        basic.get(handler: index)
        basic.post(handler: store)
        basic.get(Category.parameter, "subcategories", handler: subcategories)
    }
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Category.all().makeJSON()
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.category()
        try category.save()
        return category
    }
    
    func show(_ req: Request, category: Category) throws -> ResponseRepresentable {
        return JSON([
            "category": try category.makeJSON(),
            "subcategories": try category.subcategories.all().makeJSON()
            ])
    }
    
    func delete(_ req: Request, category: Category) throws -> ResponseRepresentable {
        try category.delete()
        return Response(status: .ok)
    }
    
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Category.makeQuery().delete()
        return Response(status: .ok)
    }
    
    func update(_ req: Request, category: Category) throws -> ResponseRepresentable {
        try category.update(for: req)
        try category.save()
        return category
    }
    
    func replace(_ req: Request, category: Category) throws -> ResponseRepresentable {
        let new = try req.category()
        category.name = new.name
        try category.save()
        return category
    }
    
    func subcategories(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.parameters.next(Category.self)
        if let limit = req.query?["limit"]?.int, let offset = req.query?["offset"]?.int {
            let subcategories = try category.subcategories.limit(limit, offset: offset)
            return try subcategories.all().makeJSON()
        }
        return try category.subcategories.all().makeJSON()
    }
 
    func makeResource() -> Resource<Category> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func category() throws -> Category {
        guard let json = json else { throw Abort.badRequest }
        return try Category(json: json)
    }
}

extension CategoryController: EmptyInitializable { }
