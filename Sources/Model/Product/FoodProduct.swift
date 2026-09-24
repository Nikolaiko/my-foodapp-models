import Foundation

public struct FoodProduct: Equatable, Hashable, Codable {
    public let id: String
    public let name: String
    public let quantity: Float
    public let quantityType: FoodQuantityType
    public let type: FoodProductType
    public let date: Date

    public init(
        id: String,
        name: String,
        quantity: Float,
        quantityType: FoodQuantityType,
        type: FoodProductType,
        date: Date
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.quantityType = quantityType
        self.type = type
        self.date = date
    }

    public func copy(
        id: String? = nil,
        name: String? = nil,
        quantity: Float? = nil,
        quantityType: FoodQuantityType? = nil,
        type: FoodProductType? = nil,
        date: Date? = nil
    ) -> FoodProduct {
        FoodProduct(
            id: id ?? self.id,
            name: name ?? self.name,
            quantity: quantity ?? self.quantity,
            quantityType: quantityType ?? self.quantityType,
            type: type ?? self.type,
            date: date ?? self.date
        )
    }
}
