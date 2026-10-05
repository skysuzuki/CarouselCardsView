# CarouselCardsView

`CarouselCardsView` is a reusable SwiftUI package for building animated, snapping card carousels. It includes both a ready-made gradient card design and a generic carousel container for completely custom card content.

## Requirements

- iOS 17 or later
- macOS 14 or later
- Swift 6.4 or later

## Installation

### Xcode

1. Choose **File > Add Package Dependencies**.
2. Enter this repository's URL after it has been hosted in a Git repository.
3. Add the `CarouselCardsView` library to your app target.

For local development, choose **Add Local...** from the package dependency dialog and select this package's directory.

### Package.swift

Add the hosted repository as a dependency, then add `CarouselCardsView` to your target:

```swift
dependencies: [
    .package(url: "https://github.com/your-account/CarouselCardsView.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["CarouselCardsView"]
    )
]
```

Replace the example URL with the package's published repository URL.

## Ready-made cards

Use `CarouselCardsView` when the built-in title, value, detail, gradient, and accessory layout fits your app.

```swift
import CarouselCardsView
import SwiftUI

struct DashboardView: View {
    @State private var selectedCardID: CarouselCard.ID?
    @State private var cards = [
        CarouselCard(
            title: "VISITS",
            value: "24",
            detail: "6 upcoming",
            backgroundColors: [.blue, .cyan],
            accessories: [
                CarouselCardAccessory(
                    image: Image(systemName: "figure.walk"),
                    value: "18"
                ),
                CarouselCardAccessory(
                    image: Image(systemName: "phone.fill"),
                    value: "6"
                ),
            ]
        ),
        CarouselCard(
            title: "DEALS",
            value: "10",
            detail: "$4,250 total",
            backgroundColors: [.green, .mint]
        ),
    ]

    var body: some View {
        CarouselCardsView(
            cards: cards,
            selection: $selectedCardID
        ) { selectedCard in
            open(selectedCard)
        }
        .frame(height: 180)
    }

    private func open(_ card: CarouselCard) {
        // Present app-owned details or navigation here.
    }
}
```

The selection binding contains the selected card's stable `UUID`. When selection is `nil`, the carousel selects the first available card. If the selected card is removed, selection also normalizes to the first remaining card.

Tapping an unselected card selects it. Tapping the currently selected card calls `onCardTap`.

### Multiline values

Use the multiline presentation for cards whose main value needs more than one line:

```swift
CarouselCard(
    title: "PRIORITY",
    value: "Follow up with the regional account team",
    backgroundColors: [.indigo, .purple],
    presentation: .multilineValue
)
```

## Custom styling

`CarouselLayout` controls sizing and interaction, while `CarouselCardStyle` controls the built-in card's appearance.

```swift
let layout = CarouselLayout(
    selectedCardWidth: 260,
    unselectedCardWidth: 120,
    cardHeight: 200,
    collapsedStride: 126,
    edgeInset: 16,
    swipeThreshold: 50,
    animation: .snappy
)

let style = CarouselCardStyle(
    titleFont: .headline,
    valueFont: .largeTitle.bold(),
    detailFont: .subheadline,
    foregroundColor: .white,
    defaultBackgroundColors: [.indigo, .purple],
    cornerRadius: 20,
    contentInsets: EdgeInsets(
        top: 20,
        leading: 20,
        bottom: 16,
        trailing: 20
    ),
    unselectedOpacity: 0.8
)

CarouselCardsView(
    cards: cards,
    selection: $selectedCardID,
    layout: layout,
    cardStyle: style
)
.frame(height: layout.cardHeight)
```

An individual `CarouselCard` can override the style's default background gradient and foreground color.

## Fully custom cards

Use `CarouselView` when your data or card design doesn't match the built-in model. Items must conform to `Identifiable`, and their IDs must remain stable when items are inserted, removed, or reordered.

```swift
import CarouselCardsView
import SwiftUI

struct Destination: Identifiable {
    let id: Int
    let name: String
    let systemImage: String
}

struct DestinationCarousel: View {
    @State private var selection: Destination.ID?

    private let destinations = [
        Destination(id: 1, name: "Mountains", systemImage: "mountain.2.fill"),
        Destination(id: 2, name: "Coast", systemImage: "water.waves"),
        Destination(id: 3, name: "City", systemImage: "building.2.fill"),
    ]

    var body: some View {
        CarouselView(
            items: destinations,
            selection: $selection,
            onCardTap: { destination in
                open(destination)
            }
        ) { destination, isSelected in
            VStack(spacing: 12) {
                Image(systemName: destination.systemImage)
                    .font(.largeTitle)
                Text(destination.name)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(isSelected ? Color.indigo : Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .frame(height: 180)
    }

    private func open(_ destination: Destination) {
        // Handle the selected item in the containing app.
    }
}
```

The content closure receives the item followed by a Boolean indicating whether that item is currently selected.

## Accessibility and interaction

The carousel supports:

- Horizontal drag gestures and animated snapping
- Tap or click selection
- Activation of the selected card through its button action
- VoiceOver adjustable actions for moving forward and backward
- Stable selection across item reordering
- Safe handling of empty collections and removed selections

## Legacy API

`SnapCarouselView` and `CarouselCardView` remain available as deprecated compatibility adapters. New integrations should use `CarouselView` with an item-ID selection binding.

## Testing

Run the package tests from Xcode with **Product > Test**, or from the command line:

```sh
swift test
```
