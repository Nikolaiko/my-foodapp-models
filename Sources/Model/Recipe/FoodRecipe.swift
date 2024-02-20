import Foundation

public struct FoodRecipe {
    public let id: String
    public let name: String
    public let shortDescription: String
    public let description: String
    public let products: [FoodRecipeProductEntry]
    public let tags: [Int]

    public init(id: String,
         name: String,
         shortDescription: String,
         description: String,
         products: [FoodRecipeProductEntry],
         tags: [Int]
    ) {
        self.id = id
        self.name = name
        self.shortDescription = shortDescription
        self.description = description
        self.products = products
        self.tags = tags
    }
}
