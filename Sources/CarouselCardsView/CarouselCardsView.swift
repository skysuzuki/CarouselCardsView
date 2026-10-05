import SwiftUI

/// A model-driven carousel using the package's standard card presentation.
public struct CarouselCardsView: View {
    @Binding private var selection: CarouselCard.ID?

    private let cards: [CarouselCard]
    private let layout: CarouselLayout
    private let cardStyle: CarouselCardStyle
    private let onCardTap: ((CarouselCard) -> Void)?

    public init(
        cards: [CarouselCard],
        selection: Binding<CarouselCard.ID?>,
        layout: CarouselLayout = .standard,
        cardStyle: CarouselCardStyle = .standard,
        onCardTap: ((CarouselCard) -> Void)? = nil
    ) {
        self.cards = cards
        self._selection = selection
        self.layout = layout
        self.cardStyle = cardStyle
        self.onCardTap = onCardTap
    }

    public var body: some View {
        CarouselView(
            items: cards,
            selection: $selection,
            layout: layout,
            onCardTap: onCardTap
        ) { card, isSelected in
            StandardCarouselCardView(
                title: card.title,
                value: card.value,
                detail: card.detail,
                backgroundColors: card.backgroundColors,
                foregroundColor: card.foregroundColor,
                presentation: card.presentation,
                accessories: card.accessories,
                isSelected: isSelected,
                style: cardStyle
            )
        }
    }
}

#Preview {
    @Previewable @State var selection: CarouselCard.ID?

    let cards = [
        CarouselCard(
            title: "VISITS",
            value: "24",
            detail: "6 upcoming",
            backgroundColors: [.blue, .cyan],
            accessories: [
                CarouselCardAccessory(image: Image(systemName: "figure.walk"), value: "18"),
                CarouselCardAccessory(image: Image(systemName: "phone.fill"), value: "6"),
            ]
        ),
        CarouselCard(
            title: "DEALS",
            value: "10",
            detail: "$4,250 total",
            backgroundColors: [.green, .mint]
        ),
        CarouselCard(title: "NOTES", value: "8", backgroundColors: [.orange, .yellow]),
        CarouselCard(title: "NOTES", value: "8", backgroundColors: [.orange, .yellow])
    ]

    CarouselCardsView(cards: cards, selection: $selection)
        .frame(height: 180)
        .padding()
}
