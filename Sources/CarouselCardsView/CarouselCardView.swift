import SwiftUI

/// A snapping carousel that renders caller-provided content for identifiable items.
public struct CarouselView<Item: Identifiable, ItemView: View>: View {
    @Binding private var selection: Item.ID?
    @GestureState private var dragTranslation: CGFloat = 0

    private let items: [Item]
    private let layout: CarouselLayout
    private let onCardTap: ((Item) -> Void)?
    private let viewForItem: (Item, Bool) -> ItemView

    public init(
        items: [Item],
        selection: Binding<Item.ID?>,
        layout: CarouselLayout = .standard,
        onCardTap: ((Item) -> Void)? = nil,
        @ViewBuilder content: @escaping (Item, Bool) -> ItemView
    ) {
        self.items = items
        self._selection = selection
        self.layout = layout
        self.onCardTap = onCardTap
        self.viewForItem = content
    }

    public var body: some View {
        GeometryReader { geometry in
            let selectedIndex = CarouselSelection.index(
                for: selection,
                in: items
            ) ?? 0
            let geometryModel = CarouselGeometry(
                itemCount: items.count,
                selectedIndex: selectedIndex,
                containerWidth: geometry.size.width,
                layout: layout
            )

            ZStack {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    let isSelected = index == selectedIndex

                    Button {
                        handleTap(on: item, at: index, isSelected: isSelected)
                    } label: {
                        viewForItem(item, isSelected)
                            .frame(
                                width: isSelected
                                    ? layout.selectedCardWidth
                                    : layout.unselectedCardWidth,
                                height: layout.cardHeight
                            )
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .offset(
                        x: geometryModel.position(for: index)
                            + geometryModel.alignmentShift
                            + dragTranslation
                    )
                    .zIndex(isSelected ? 1 : -Double(abs(index - selectedIndex)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .highPriorityGesture(dragGesture)
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    select(index: selectedIndex + 1)
                case .decrement:
                    select(index: selectedIndex - 1)
                @unknown default:
                    break
                }
            }
        }
        .frame(minHeight: layout.cardHeight)
        .onChange(of: items.map(\.id), initial: true) { _, _ in
            normalizeSelection()
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .updating($dragTranslation) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                let translation = value.predictedEndTranslation.width
                guard abs(translation) >= layout.swipeThreshold else { return }

                let currentIndex = CarouselSelection.index(for: selection, in: items) ?? 0
                select(index: translation < 0 ? currentIndex + 1 : currentIndex - 1)
            }
    }

    private func handleTap(on item: Item, at index: Int, isSelected: Bool) {
        if isSelected {
            onCardTap?(item)
        } else {
            select(index: index)
        }
    }

    private func select(index: Int) {
        guard let validIndex = CarouselSelection.clampedIndex(index, itemCount: items.count) else {
            return
        }

        withAnimation(layout.animation) {
            selection = items[validIndex].id
        }
    }

    private func normalizeSelection() {
        let normalized = CarouselSelection.normalizedID(selection, in: items)
        guard normalized != selection else { return }
        selection = normalized
    }
}

/// Compatibility wrapper for the original card-content API.
@available(*, deprecated, message: "Create card content directly in CarouselView's content closure.")
public struct CarouselCardView<Content: View>: View {
    public let cardIndex: Int
    public let currentIndex: Int
    public let card: () -> Content

    public init(cardIndex: Int, currentIndex: Int, card: @escaping () -> Content) {
        self.cardIndex = cardIndex
        self.currentIndex = currentIndex
        self.card = card
    }

    public init(
        cardIndex: Int,
        currentIndex: Int,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cardIndex = cardIndex
        self.currentIndex = currentIndex
        self.card = content
    }

    public var body: some View {
        card()
    }
}

/// Compatibility adapter for the original index-based carousel API.
@available(*, deprecated, message: "Use CarouselView with an item-ID selection binding.")
public struct SnapCarouselView<Item: Identifiable, ItemView: View>: View {
    @Binding public var nextIndex: Int

    public let cards: [Item]
    public let cardsOnScreen: CGFloat
    public let viewForItem: (Bool, Item) -> ItemView

    public init(
        nextIndex: Binding<Int>,
        cards: [Item],
        cardsOnScreen: CGFloat,
        @ViewBuilder viewForItem: @escaping (Bool, Item) -> ItemView
    ) {
        self._nextIndex = nextIndex
        self.cards = cards
        self.cardsOnScreen = cardsOnScreen
        self.viewForItem = viewForItem
    }

    public var body: some View {
        CarouselView(items: cards, selection: itemSelection) { item, isSelected in
            viewForItem(isSelected, item)
        }
    }

    private var itemSelection: Binding<Item.ID?> {
        Binding(
            get: {
                guard cards.indices.contains(nextIndex) else { return cards.first?.id }
                return cards[nextIndex].id
            },
            set: { selectedID in
                guard
                    let selectedID,
                    let index = cards.firstIndex(where: { $0.id == selectedID })
                else {
                    nextIndex = 0
                    return
                }
                nextIndex = index
            }
        )
    }
}
