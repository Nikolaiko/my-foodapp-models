import Foundation

public struct TableProduct: Equatable, Hashable {
    public let id: String
    public let name: String
    public let quantity: Int
    public let quantityType: FoodQuantityType
    public let type: FoodProductType
    public let date: Date
    public let selected: Bool

    public init(
        id: String,
        name: String,
        quantity: Int,
        quantityType: FoodQuantityType,
        type: FoodProductType,
        date: Date, selected: Bool
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.quantityType = quantityType
        self.type = type
        self.date = date
        self.selected = selected
    }

    public func copy(id: String? = nil,
              name: String? = nil,
              quantity: Int? = nil,
              quantityType: FoodQuantityType? = nil,
              type: FoodProductType? = nil,
              date: Date? = nil,
              selected: Bool? = nil
    ) -> TableProduct {
        TableProduct(
            id: id ?? self.id,
            name: name ?? self.name,
            quantity: quantity ?? self.quantity,
            quantityType: quantityType ?? self.quantityType,
            type: type ?? self.type,
            date: date ?? self.date,
            selected: selected ?? self.selected
        )
    }
}
