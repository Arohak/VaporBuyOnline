//
//  CategoryController.swift
//  VaporBuyOnlinePackageDescription
//
//  Created by Ara Hakobyan on 09/02/2018.
//

import Vapor
import HTTP

final class CategoryController: ResourceRepresentable {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Category.all().makeJSON()
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.category()
        try category.save()
        return category
    }
    
    func show(_ req: Request, category: Category) throws -> ResponseRepresentable {
        return category
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
