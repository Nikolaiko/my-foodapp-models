import Foundation

public struct FoodProduct: Equatable, Hashable {
    public let id: String
    public let name: String
    public let quantity: Int
    public let quantityType: FoodQuantityType
    public let type: FoodProductType
    public let date: Date

    public init(
        id: String,
        name: String,
        quantity: Int,
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
        quantity: Int? = nil,
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

    public static func ==(lhs: FoodProduct, rhs: FoodProduct) -> Bool {
        let calendar = Calendar.current
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.quantity == rhs.quantity &&
            lhs.quantityType == rhs.quantityType &&
            lhs.type == rhs.type &&
            calendar.compare(lhs.date, to: rhs.date, toGranularity: .day) == .orderedSame
    }
}
