import Foundation

public struct FoodRecipeProductEntry {
    public let id: String
    public let productType: FoodProductType
    public let count: Int
    public let quantityMeasure: FoodQuantityType

    public init(id: String,
                productType: FoodProductType,
                count: Int,
                quantityMeasure: FoodQuantityType
    ) {
        self.id = id
        self.productType = productType
        self.count = count
        self.quantityMeasure = quantityMeasure
    }
}
