import SwiftUI
import Testing
@testable import CarouselCardsView

@Suite("Carousel layout and selection")
struct CarouselCardsViewTests {
    private struct Item: Identifiable {
        let id: Int
    }

    @Test("A single card remains centered")
    func singleCardIsCentered() {
        let geometry = CarouselGeometry(
            itemCount: 1,
            selectedIndex: 0,
            containerWidth: 400,
            layout: .standard
        )

        #expect(geometry.position(for: 0) == 0)
        #expect(geometry.alignmentShift == 0)
    }

    @Test("Cards retain the original selected and collapsed spacing")
    func cardPositions() {
        let geometry = CarouselGeometry(
            itemCount: 5,
            selectedIndex: 2,
            containerWidth: 320,
            layout: .standard
        )

        #expect(geometry.position(for: 0) == -340)
        #expect(geometry.position(for: 1) == -225)
        #expect(geometry.position(for: 2) == 0)
        #expect(geometry.position(for: 3) == 225)
        #expect(geometry.position(for: 4) == 340)
    }

    @Test("The first and last cards align to container edges")
    func edgeAlignment() {
        let firstGeometry = CarouselGeometry(
            itemCount: 3,
            selectedIndex: 0,
            containerWidth: 320,
            layout: .standard
        )
        let lastGeometry = CarouselGeometry(
            itemCount: 3,
            selectedIndex: 2,
            containerWidth: 320,
            layout: .standard
        )

        #expect(firstGeometry.alignmentShift == -40)
        #expect(lastGeometry.alignmentShift == 40)
    }

    @Test("Selection boundaries are safe for empty and populated collections")
    func selectionBoundaries() {
        #expect(CarouselSelection.clampedIndex(0, itemCount: 0) == nil)
        #expect(CarouselSelection.clampedIndex(-2, itemCount: 3) == 0)
        #expect(CarouselSelection.clampedIndex(7, itemCount: 3) == 2)
    }

    @Test("Selection follows stable IDs when items reorder")
    func stableSelectionAcrossReordering() {
        let reordered = [Item(id: 3), Item(id: 1), Item(id: 2)]

        #expect(CarouselSelection.index(for: 2, in: reordered) == 2)
        #expect(CarouselSelection.normalizedID(2, in: reordered) == 2)
    }

    @Test("Missing selections normalize to the first item")
    func invalidSelectionNormalization() {
        let items = [Item(id: 4), Item(id: 5)]

        #expect(CarouselSelection.normalizedID(nil, in: items) == 4)
        #expect(CarouselSelection.normalizedID(99, in: items) == 4)
        #expect(CarouselSelection.normalizedID(4, in: [Item]()) == nil)
    }

    @Test("Public defaults preserve the existing card look")
    func standardDefaults() {
        let layout = CarouselLayout.standard
        let style = CarouselCardStyle.standard

        #expect(layout.selectedCardWidth == 220)
        #expect(layout.unselectedCardWidth == 110)
        #expect(layout.cardHeight == 180)
        #expect(layout.collapsedStride == 115)
        #expect(style.cornerRadius == 25)
    }

    @Test("The ready-made model supports multiline content and accessories")
    func cardModel() {
        let card = CarouselCard(
            title: "Priority",
            value: "A longer value",
            presentation: .multilineValue,
            accessories: [
                CarouselCardAccessory(image: Image(systemName: "star"), value: "3")
            ]
        )

        #expect(card.presentation == .multilineValue)
        #expect(card.accessories.count == 1)
        #expect(card.accessories[0].value == "3")
    }
}
