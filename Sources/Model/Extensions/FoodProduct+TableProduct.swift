import Foundation

extension FoodProduct {
    public func toTableProduct() -> TableProduct {
        TableProduct(
            id: self.id,
            name: name,
            quantity: quantity,
            quantityType: quantityType,
            type: type,
            date: date,
            selected: false
        )
    }
}

extension TableProduct {
    public func toProduct() -> FoodProduct {
        FoodProduct(
            id: self.id,
            name: name,
            quantity: quantity,
            quantityType: quantityType,
            type: type,
            date: date
        )
    }
}
