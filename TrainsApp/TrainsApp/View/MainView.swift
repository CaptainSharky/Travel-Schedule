import SwiftUI

struct MainView: View {
    @State private var from: String? = "Москва (Курский вокзал)"
    @State private var to: String? = "Санкт Петербург (Балтийский вокзал)"

    var body: some View {
        DirectionPickerView(
            fromText: $from,
            toText: $to,
            onTapFrom: {

            },
            onTapTo: {

            },
            onSwap: {
                swap(&from, &to)
            }
        )
        .padding()
    }
}

struct DirectionPickerView: View {
    @Binding var fromText: String?
    @Binding var toText: String?

    let onTapFrom: () -> Void
    let onTapTo: () -> Void
    let onSwap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 20) {
                tappableRow(
                    text: fromText,
                    placeholder: "Откуда",
                    action: onTapFrom
                )
                tappableRow(
                    text: toText,
                    placeholder: "Куда",
                    action: onTapTo
                )
            }
            .font(.system(size: 17))
            .padding(.vertical, 14)
            .padding(.horizontal, 14)
            .background(Color(.ypWhite))
            .cornerRadius(20)

            Button(action: onSwap) {
                Image(.change)
                    .foregroundStyle(Color(.ypBlue))
                    .frame(width: 36, height: 36)
                    .background(Color(.ypWhite))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(.ypBlue))
        .cornerRadius(20)
    }

    private func tappableRow(
        text: String?,
        placeholder: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(text ?? placeholder)
                    .foregroundColor(text == nil
                                     ? Color(.ypGray)
                                     : Color(.ypBlack))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainView()
}
