import FluentProvider
import PostgreSQLProvider

extension Config {
    
    public func setup() throws {
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }
    
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(PostgreSQLProvider.Provider.self)
    }
    
    private func setupPreparations() throws {
        preparations.append(Post.self)
        preparations.append(Category.self)
        preparations.append(Subcategory.self)
    }
}
