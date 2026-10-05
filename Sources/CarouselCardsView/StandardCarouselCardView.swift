import SwiftUI

struct StandardCarouselCardView: View {
    let title: String
    let value: String
    let detail: String?
    let backgroundColors: [Color]
    let foregroundColor: Color?
    let presentation: CarouselCard.Presentation
    let accessories: [CarouselCardAccessory]
    let isSelected: Bool
    let style: CarouselCardStyle

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: backgroundColors.isEmpty
                            ? style.defaultBackgroundColors
                            : backgroundColors,
                        startPoint: style.gradientStartPoint,
                        endPoint: style.gradientEndPoint
                    )
                )

            CarouselCardContent(
                title: title,
                value: value,
                detail: detail,
                presentation: presentation,
                accessories: accessories,
                style: style
            )
            .padding(style.contentInsets)
        }
        .foregroundStyle(foregroundColor ?? style.foregroundColor)
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
        .opacity(isSelected ? style.selectedOpacity : style.unselectedOpacity)
        .accessibilityElement(children: .combine)
    }
}

private struct CarouselCardContent: View {
    let title: String
    let value: String
    let detail: String?
    let presentation: CarouselCard.Presentation
    let accessories: [CarouselCardAccessory]
    let style: CarouselCardStyle

    var body: some View {
        VStack(alignment: .leading, spacing: style.contentSpacing) {
            Text(title)
                .font(style.titleFont)
                .lineLimit(style.titleLineLimit)

            Text(value)
                .font(presentation == .multilineValue ? style.multilineValueFont : style.valueFont)
                .lineLimit(presentation == .multilineValue ? style.multilineValueLineLimit : 1)
                .minimumScaleFactor(style.minimumScaleFactor)

            if presentation == .standard, let detail, !detail.isEmpty {
                Text(detail)
                    .font(style.detailFont)
                    .italic()
                    .lineLimit(style.detailLineLimit)
            }

            if !accessories.isEmpty {
                Spacer(minLength: 0)
                CarouselCardAccessories(accessories: accessories, style: style)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

private struct CarouselCardAccessories: View {
    let accessories: [CarouselCardAccessory]
    let style: CarouselCardStyle

    var body: some View {
        HStack(spacing: style.accessorySpacing) {
            ForEach(accessories) { accessory in
                accessory.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: accessory.imageSize.width, height: accessory.imageSize.height)

                if let value = accessory.value {
                    Text(value)
                        .font(style.accessoryFont)
                }
            }
        }
    }
}
