import Foundation

public struct FoodRecipe {
    public let id: String
    public let name: String
    public let shortDescription: String
    public let description: String
    public let products: [FoodRecipeProductEntry]
    public let tags: [Int]
}
