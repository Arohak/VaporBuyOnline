import Vapor
import HTTP

final class SubcategoryController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Subcategory.all().makeJSON()
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let subcategory = try req.subcategory()
        try subcategory.save()
        return subcategory
    }
    
    func show(_ req: Request, subcategory: Subcategory) throws -> ResponseRepresentable {
        return subcategory
    }
    
    func delete(_ req: Request, subcategory: Subcategory) throws -> ResponseRepresentable {
        try subcategory.delete()
        return Response(status: .ok)
    }
    
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Subcategory.makeQuery().delete()
        return Response(status: .ok)
    }
    
    func update(_ req: Request, subcategory: Subcategory) throws -> ResponseRepresentable {
        try subcategory.update(for: req)
        try subcategory.save()
        return subcategory
    }
    
    func replace(_ req: Request, subcategory: Subcategory) throws -> ResponseRepresentable {
        let new = try req.subcategory()
        subcategory.name = new.name
        subcategory.src = new.src
        try subcategory.save()
        return subcategory
    }
 
    func makeResource() -> Resource<Subcategory> {
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
    func subcategory() throws -> Subcategory {
        guard let json = json else { throw Abort.badRequest }
        return try Subcategory(json: json)
    }
}

extension SubcategoryController: EmptyInitializable { }
