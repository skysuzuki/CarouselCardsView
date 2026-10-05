import SwiftUI

/// Display data for the package-provided card design.
public struct CarouselCard: Identifiable {
    public enum Presentation: Equatable, Sendable {
        case standard
        case multilineValue
    }

    public let id: UUID
    public var title: String
    public var value: String
    public var detail: String?
    public var backgroundColors: [Color]
    public var foregroundColor: Color?
    public var presentation: Presentation
    public var accessories: [CarouselCardAccessory]

    public init(
        id: UUID = UUID(),
        title: String,
        value: String,
        detail: String? = nil,
        backgroundColors: [Color] = [],
        foregroundColor: Color? = nil,
        presentation: Presentation = .standard,
        accessories: [CarouselCardAccessory] = []
    ) {
        self.id = id
        self.title = title
        self.value = value
        self.detail = detail
        self.backgroundColors = backgroundColors
        self.foregroundColor = foregroundColor
        self.presentation = presentation
        self.accessories = accessories
    }
}

/// An icon and optional value shown along the bottom of a standard card.
public struct CarouselCardAccessory: Identifiable {
    public let id: UUID
    public var image: Image
    public var value: String?
    public var imageSize: CGSize

    public init(
        id: UUID = UUID(),
        image: Image,
        value: String? = nil,
        imageSize: CGSize = CGSize(width: 14, height: 14)
    ) {
        self.id = id
        self.image = image
        self.value = value
        self.imageSize = imageSize
    }
}
