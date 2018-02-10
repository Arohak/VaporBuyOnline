import Vapor
import PostgreSQLProvider

extension Droplet {
    
    func setupRoutes() throws {
        
//        let query = request.query?["hello"]  // String? // limit=%@&offset=%@
        get("test") { req in
            guard let limit = req.query?["limit"]?.int, let offset = req.query?["offset"]?.int else { return "" }
            return "requested limit:#\(limit), offset:#\(offset)"
        }

//        http://localhost:8080/test1/1
        get("test1", Int.parameter) { req in
            let userId = try req.parameters.next(Int.self)
            return "requested #\(userId)"
        }
        
//        http://localhost:8080/test2/1
        get("test2", ":id") { req in
            guard let userId = req.parameters["id"]?.int else {
                throw Abort.badRequest
            }
            
            return "requested #\(userId)"
        }
        
//        http://localhost:8080/test3/nickname/1
        get("test3", "nickname", Int.parameter) { req in
            let userId = try req.parameters.next(Int.self)
            return "requested #\(userId)"
        }
        
        get("version") { req in
            let postgresqlDriver = try self.postgresql()
            let version = try postgresqlDriver.raw("SELECT version()")
            return JSON(node: version)
        }
        
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        get("plaintext") { req in
            return "Hello, world!"
        }
        
        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }
        
        get("description") { req in return req.description }
        
        try resource("subcategories", SubcategoryController.self)
        
        let categoryController = CategoryController()
        categoryController.addRoutes(drop: self)
//        try resource("categories", CategoryController.self)
    }
}
