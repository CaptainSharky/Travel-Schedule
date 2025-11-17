import SwiftUI

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
        HStack {
            Text(text ?? placeholder)
                .foregroundStyle(text == nil ? Color(.ypGray) : Color(.ypBlack))
                .lineLimit(1)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}
