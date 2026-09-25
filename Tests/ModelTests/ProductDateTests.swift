import Foundation
import Testing
import Model

private func utc(_ string: String) throws -> Date {
    try #require(ISO8601DateFormatter().date(from: string))
}

private func makeProduct(date: Date) -> FoodProduct {
    FoodProduct(id: "1", name: "Томаты черри 250г", quantity: 1, quantityType: .packed, type: .tomato, date: date)
}

private let isoEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}()

private let isoDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}()

struct FoodProductDateTests {
    @Test func initTruncatesDateToUTCDayStart() throws {
        let product = makeProduct(date: try utc("2026-07-12T10:30:45Z").addingTimeInterval(0.123))
        let expected = try utc("2026-07-12T00:00:00Z")
        #expect(product.date == expected)
    }

    @Test func dayIsCountedInUTCNotLocalTime() throws {
        // 02:30 12 июля в UTC+6 — по UTC это ещё 11 июля.
        let product = makeProduct(date: try utc("2026-07-12T02:30:00+06:00"))
        let expected = try utc("2026-07-11T00:00:00Z")
        #expect(product.date == expected)
    }

    @Test func sameDayProductsAreEqual() throws {
        let morning = makeProduct(date: try utc("2026-07-12T00:00:01Z"))
        let evening = makeProduct(date: try utc("2026-07-12T23:59:59Z"))
        #expect(morning == evening)
        #expect(Set([morning, evening]).count == 1)
    }

    @Test func differentDayProductsAreNotEqual() throws {
        let lateEvening = makeProduct(date: try utc("2026-07-12T23:59:59Z"))
        let nextMidnight = makeProduct(date: try utc("2026-07-13T00:00:00Z"))
        #expect(lateEvening != nextMidnight)
    }

    @Test func copyTruncatesDate() throws {
        let product = makeProduct(date: try utc("2026-07-12T10:00:00Z"))
        let copy = product.copy(date: try utc("2026-07-13T15:45:00Z"))
        let expected = try utc("2026-07-13T00:00:00Z")
        #expect(copy.date == expected)
    }

    @Test func decodingTruncatesDate() throws {
        let json = """
        {"id": "1", "name": "Молоко", "quantity": 1, "quantityType": 4, "type": "Milk", "date": "2026-07-12T10:00:00Z"}
        """
        let product = try isoDecoder.decode(FoodProduct.self, from: Data(json.utf8))
        let expected = try utc("2026-07-12T00:00:00Z")
        #expect(product.date == expected)
    }

    @Test func jsonRoundTripKeepsProductEqual() throws {
        let product = makeProduct(date: try utc("2026-07-12T10:30:45Z").addingTimeInterval(0.123))
        let data = try isoEncoder.encode(product)
        #expect(try isoDecoder.decode(FoodProduct.self, from: data) == product)
        #expect(String(decoding: data, as: UTF8.self).contains(#""date":"2026-07-12T00:00:00Z""#))
    }
}

struct TableProductDateTests {
    @Test func initAndCopyTruncateDateToUTCDayStart() throws {
        let product = TableProduct(
            id: "1", name: "Молоко", quantity: 1, quantityType: .liquid, type: .milk,
            date: try utc("2026-07-12T10:30:45Z"), selected: false
        )
        let copy = product.copy(date: try utc("2026-07-13T15:45:00Z"))
        let expectedDay = try utc("2026-07-12T00:00:00Z")
        let expectedCopyDay = try utc("2026-07-13T00:00:00Z")
        #expect(product.date == expectedDay)
        #expect(copy.date == expectedCopyDay)
    }

    @Test func decodingTruncatesDate() throws {
        let json = """
        {"id": "1", "name": "Молоко", "quantity": 1, "quantityType": 4, "type": "Milk", "date": "2026-07-12T10:00:00Z", "selected": true}
        """
        let product = try isoDecoder.decode(TableProduct.self, from: Data(json.utf8))
        let expected = try utc("2026-07-12T00:00:00Z")
        #expect(product.date == expected)
        #expect(product.selected)
    }

    @Test func conversionKeepsDay() throws {
        let product = makeProduct(date: try utc("2026-07-12T10:30:45Z"))
        #expect(product.toTableProduct().date == product.date)
        #expect(product.toTableProduct().toProduct() == product)
    }
}
