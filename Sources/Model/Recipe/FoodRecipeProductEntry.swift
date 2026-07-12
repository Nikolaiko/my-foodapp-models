import Foundation

public struct FoodRecipeProductEntry: Codable {
    public let id: String
    public let productType: FoodProductType
    public let count: Float
    public let quantityMeasure: FoodQuantityType

    public init(id: String,
                productType: FoodProductType,
                count: Float,
                quantityMeasure: FoodQuantityType
    ) {
        self.id = id
        self.productType = productType
        self.count = count
        self.quantityMeasure = quantityMeasure
    }
}
