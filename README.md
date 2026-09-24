# my-foodapp-models

![Swift](https://img.shields.io/badge/Swift-5.9+-orange?logo=swift)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)
![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20Linux-lightgrey)

Библиотека общих моделей данных приложения «Моё питание»: продукты,
рецепты, данные QR-кода чека. Это **общий контракт** между
[бэкендом](https://github.com/Nikolaiko/my-food-app-backend) и клиентами:
бэкенд отдаёт эти типы в JSON как есть.

Swift Package без внешних зависимостей. Пакет `FoodModel`, продукт (модуль) — **`Model`**.

## Подключение

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/Nikolaiko/my-foodapp-models.git", .upToNextMajor(from: "1.0.7")),
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "Model", package: "my-foodapp-models"),
    ]),
]
```

```swift
import Model
```

Платформы: iOS 13+, macOS 10.15+, tvOS 13+, watchOS 6+, Mac Catalyst 13+,
а также Linux (на нём собирается бэкенд).

## Состав

```
Sources/Model/
  Product/       FoodProduct, TableProduct, FoodProductType, FoodQuantityType
  Recipe/        FoodRecipe, FoodRecipeProductEntry
  Network/       QRCodeRawData
  Extensions/    FoodProduct ⇄ TableProduct, Color(hex:)
  Colors/        палитра приложения (только SwiftUI)
  Strings/       общие строки UI
  TypeAliases/   VoidCallback, DataCallback<T>
```

| Тип | Назначение |
|---|---|
| `FoodProduct` | Продукт из списка запасов: `id`, `name`, `quantity: Float`, `quantityType`, `type`, `date` |
| `TableProduct` | Тот же продукт + флаг `selected` — для списков с выделением в UI. Конвертация: `toTableProduct()` / `toProduct()` |
| `FoodProductType` | Вид продукта (`apple`, `milk`, `tomato`, `greenOnion`, …, `unknown`). Raw value — `String` |
| `FoodQuantityType` | Единица измерения: `unknown = 0`, `weight`, `packed`, `item`, `liquid`. Raw value — `Int` |
| `FoodRecipe` | Рецепт: `id`, `name`, `shortDescription`, `description`, `products`, `tags: [Int]` |
| `FoodRecipeProductEntry` | Ингредиент рецепта: `productType`, `count: Float`, `quantityMeasure` |
| `QRCodeRawData` | Тело запроса разбора чека: сырая строка QR (`qrRawString`) |
| `AppColors`, `Color(hex:)` | Цвета приложения и хелпер для HEX. Под `#if canImport(SwiftUI)` |
| `CommonButtonTitles`, `ProductEditStrings` | Общие строки кнопок и формы редактирования продукта |
| `VoidCallback`, `DataCallback<T>` | Типы колбэков |

Все модели — `struct` с `public init`, `Codable`; у продуктов есть
`copy(...)` для создания изменённой копии (поля `let`).

## JSON-представление

Модели сериализуются синтезированным `Codable`, поэтому имена полей в JSON
совпадают с именами свойств. На что обратить внимание:

- `FoodProductType` кодируется **строкой**: `"Apple"`, `"BellPepper"`, `"GreenOnion"`, `"Unknown"`.
- `FoodQuantityType` кодируется **числом**: `0` (unknown) … `4` (liquid).
- `quantity` / `count` — `Float` (с 1.0.6–1.0.7; раньше были целыми).
- Формат `Date` задаёт энкодер потребителя (в Vapor — ISO 8601).

```json
{
  "id": "59E038B3-629B-4749-88EB-F09234D87BBB",
  "name": "Томаты черри 250г",
  "quantity": 1,
  "quantityType": 0,
  "type": "Tomato",
  "date": "2026-07-12T10:00:00Z"
}
```

Этот формат зафиксирован в OpenAPI-спеке клиента
([`specs/backend_specs.yaml`](https://github.com/Nikolaiko/my-food-app-ai-project/blob/main/specs/backend_specs.yaml)).
Меняете модель — синхронно меняйте спеку.

## Особенности

- **Сравнение** (`==`/`hash`) синтезировано компилятором по всем полям, дата —
  с точностью до долей секунды. Поэтому продукт после round-trip через JSON
  (ISO 8601 без долей секунды) может быть не равен исходному — в тестах
  сравнивайте нужные поля или дату с допуском. Не переопределяйте `==`, не
  переопределив согласованно `hash(into:)`.
- **SwiftUI под условной компиляцией.** Всё, что импортирует SwiftUI (цвета,
  `Color(hex:)`), обёрнуто в `#if canImport(SwiftUI)`, иначе пакет не
  собирается на Linux. Новый UI-код в пакет добавляйте так же.
- **Sendable.** Типы не помечены `Sendable`; в Swift 6-проектах импортируйте
  через `@preconcurrency import Model` или добавляйте соответствие у себя
  (так сделано в бэкенде).

## Кто использует

| Потребитель | Как |
|---|---|
| [my-food-app-backend](https://github.com/Nikolaiko/my-food-app-backend) | Основной потребитель: отдаёт `FoodRecipe`/`FoodProduct` в API, `FoodProductType`/`FoodQuantityType` хранятся в БД. Добавляет к типам `Content` |
| [ReceiptApp](https://github.com/Nikolaiko/my-food-app-ai-project) (iOS) | Пакет объявлен в `Tuist/Package.swift`, но в таргеты не подключён: у клиента свои `CommonModels`, а сетевые типы генерируются из OpenAPI-спеки |

## Версионирование и релиз

Потребители подключают пакет по semver-тегу, поэтому **любое изменение
попадает к ним только через новый тег**.

- Добавили поле / case / тип без поломки → patch или minor (`1.0.7` → `1.0.8` / `1.1.0`).
- Переименовали или удалили публичное API, поменяли формат JSON → major (`2.0.0`)
  и синхронно обновить бэкенд и спеку.

```bash
git commit -am "Описание изменения"
git push origin main
git tag 1.0.8
git push origin 1.0.8
```

Затем в бэкенде:

```bash
swift package update my-foodapp-models
```

и закоммитить обновлённый `Package.resolved`.

Добавление нового вида продукта — это новый case в `FoodProductType` здесь +
ключевые слова в `SimpleProductsParser` бэкенда.

## История версий

| Тег | Изменения |
|---|---|
| `1.0.8` | `FoodProduct`: убран кастомный `==` (сравнение даты по дню нарушало контракт `Hashable`), сравнение синтезируется по всем полям |
| `1.0.7` | `TableProduct.quantity`: `Int` → `Float` |
| `1.0.6` | `FoodProduct.quantity` и `FoodRecipeProductEntry.count`: `Int` → `Float` |
| `1.0.5` | SwiftUI-код под `#if canImport(SwiftUI)` (сборка на Linux) |
| `1.0.4` | Соответствие `Codable` у моделей |
| `1.0.3` | Добавлен `QRCodeRawData` |
| `1.0.2` | Публичные инициализаторы |
| `1.0.1` | Рецепты (`FoodRecipe`, `FoodRecipeProductEntry`) |
| `1.0.0` | Первая версия |
