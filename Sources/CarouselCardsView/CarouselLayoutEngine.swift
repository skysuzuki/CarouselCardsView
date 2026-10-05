import CoreGraphics

struct CarouselGeometry {
    let itemCount: Int
    let selectedIndex: Int
    let containerWidth: CGFloat
    let layout: CarouselLayout

    func position(for index: Int) -> CGFloat {
        let distance = index - selectedIndex
        guard distance != 0 else { return 0 }

        let direction: CGFloat = distance > 0 ? 1 : -1
        let remainingCards = max(abs(distance) - 1, 0)
        return direction * (
            layout.selectedCardWidth + 5
                + CGFloat(remainingCards) * layout.collapsedStride
        )
    }

    var alignmentShift: CGFloat {
        guard itemCount > 0 else { return 0 }

        let firstPosition = position(for: 0)
        let lastPosition = position(for: itemCount - 1)
        let firstWidth = selectedIndex == 0
            ? layout.selectedCardWidth
            : layout.unselectedCardWidth
        let lastWidth = selectedIndex == itemCount - 1
            ? layout.selectedCardWidth
            : layout.unselectedCardWidth
        let minimumX = firstPosition - firstWidth / 2
        let maximumX = lastPosition + lastWidth / 2
        let contentWidth = maximumX - minimumX
        let availableWidth = max(containerWidth - 2 * layout.edgeInset, 0)

        if contentWidth <= availableWidth {
            return -(minimumX + maximumX) / 2
        }

        let leftEdge = -containerWidth / 2 + layout.edgeInset
        let rightEdge = containerWidth / 2 - layout.edgeInset

        if selectedIndex == 0 {
            return leftEdge - minimumX
        }
        if selectedIndex == itemCount - 1 {
            return rightEdge - maximumX
        }
        return 0
    }
}

enum CarouselSelection {
    static func index<Item: Identifiable>(for id: Item.ID?, in items: [Item]) -> Int? {
        guard let id else { return nil }
        return items.firstIndex { $0.id == id }
    }

    static func clampedIndex(_ index: Int, itemCount: Int) -> Int? {
        guard itemCount > 0 else { return nil }
        return min(max(index, 0), itemCount - 1)
    }

    static func normalizedID<Item: Identifiable>(_ id: Item.ID?, in items: [Item]) -> Item.ID? {
        guard !items.isEmpty else { return nil }
        guard let id, items.contains(where: { $0.id == id }) else {
            return items[0].id
        }
        return id
    }
}
