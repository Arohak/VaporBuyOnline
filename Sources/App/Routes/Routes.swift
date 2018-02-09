import Vapor
import PostgreSQLProvider

extension Droplet {
    
    func setupRoutes() throws {
        
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
        
        try resource("posts", PostController.self)
        
        try resource("categories", CategoryController.self)
    }
}
