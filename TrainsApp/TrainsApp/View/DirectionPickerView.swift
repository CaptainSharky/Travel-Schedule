import SwiftUI

struct DirectionPickerView: View {
    @Bindable var viewModel: DirectionPickerViewModel

    let onTapFrom: () -> Void
    let onTapTo: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 20) {
                tappableRow(
                    text: viewModel.fromText,
                    placeholder: "Откуда",
                    action: onTapFrom
                )
                tappableRow(
                    text: viewModel.toText,
                    placeholder: "Куда",
                    action: onTapTo
                )
            }
            .font(.system(size: 17))
            .padding(14)
            .background(Color(.ypWhite))
            .cornerRadius(20)

            Button(action: { viewModel.swap() }) {
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

#Preview {
    DirectionPickerView(
        viewModel: DirectionPickerViewModel(
            fromText: "Москва (Курский вокзал)",
            toText: nil
        ),
        onTapFrom: { },
        onTapTo: { }
    )
}
