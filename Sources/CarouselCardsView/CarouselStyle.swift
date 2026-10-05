import SwiftUI

/// Geometry and interaction settings for a carousel.
public struct CarouselLayout {
    public var selectedCardWidth: CGFloat
    public var unselectedCardWidth: CGFloat
    public var cardHeight: CGFloat
    public var collapsedStride: CGFloat
    public var edgeInset: CGFloat
    public var swipeThreshold: CGFloat
    public var animation: Animation

    public init(
        selectedCardWidth: CGFloat = 220,
        unselectedCardWidth: CGFloat = 110,
        cardHeight: CGFloat = 180,
        collapsedStride: CGFloat = 115,
        edgeInset: CGFloat = 10,
        swipeThreshold: CGFloat = 44,
        animation: Animation = .spring(response: 0.4, dampingFraction: 0.82)
    ) {
        self.selectedCardWidth = selectedCardWidth
        self.unselectedCardWidth = unselectedCardWidth
        self.cardHeight = cardHeight
        self.collapsedStride = collapsedStride
        self.edgeInset = edgeInset
        self.swipeThreshold = swipeThreshold
        self.animation = animation
    }

    public static var standard: CarouselLayout { CarouselLayout() }
}

/// Typography, colors, and shape settings for `CarouselCardsView`.
public struct CarouselCardStyle {
    public var titleFont: Font
    public var valueFont: Font
    public var multilineValueFont: Font
    public var detailFont: Font
    public var accessoryFont: Font
    public var foregroundColor: Color
    public var defaultBackgroundColors: [Color]
    public var gradientStartPoint: UnitPoint
    public var gradientEndPoint: UnitPoint
    public var cornerRadius: CGFloat
    public var contentInsets: EdgeInsets
    public var contentSpacing: CGFloat
    public var accessorySpacing: CGFloat
    public var titleLineLimit: Int
    public var detailLineLimit: Int
    public var multilineValueLineLimit: Int
    public var minimumScaleFactor: CGFloat
    public var selectedOpacity: Double
    public var unselectedOpacity: Double

    public init(
        titleFont: Font = .system(size: 18),
        valueFont: Font = .system(size: 32, weight: .bold),
        multilineValueFont: Font = .system(size: 20),
        detailFont: Font = .system(size: 16, weight: .light),
        accessoryFont: Font = .system(size: 13),
        foregroundColor: Color = .white,
        defaultBackgroundColors: [Color] = [.accentColor, .blue],
        gradientStartPoint: UnitPoint = .topLeading,
        gradientEndPoint: UnitPoint = .bottomTrailing,
        cornerRadius: CGFloat = 25,
        contentInsets: EdgeInsets = EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20),
        contentSpacing: CGFloat = 8,
        accessorySpacing: CGFloat = 6,
        titleLineLimit: Int = 1,
        detailLineLimit: Int = 2,
        multilineValueLineLimit: Int = 3,
        minimumScaleFactor: CGFloat = 0.75,
        selectedOpacity: Double = 1,
        unselectedOpacity: Double = 1
    ) {
        self.titleFont = titleFont
        self.valueFont = valueFont
        self.multilineValueFont = multilineValueFont
        self.detailFont = detailFont
        self.accessoryFont = accessoryFont
        self.foregroundColor = foregroundColor
        self.defaultBackgroundColors = defaultBackgroundColors
        self.gradientStartPoint = gradientStartPoint
        self.gradientEndPoint = gradientEndPoint
        self.cornerRadius = cornerRadius
        self.contentInsets = contentInsets
        self.contentSpacing = contentSpacing
        self.accessorySpacing = accessorySpacing
        self.titleLineLimit = titleLineLimit
        self.detailLineLimit = detailLineLimit
        self.multilineValueLineLimit = multilineValueLineLimit
        self.minimumScaleFactor = minimumScaleFactor
        self.selectedOpacity = selectedOpacity
        self.unselectedOpacity = unselectedOpacity
    }

    public static var standard: CarouselCardStyle { CarouselCardStyle() }
}
