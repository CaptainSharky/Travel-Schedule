import SwiftUI

private struct CheckboxSquareView: View {
    let isSelected: Bool

    var body: some View {
        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
            .font(.system(size: 20))
            .foregroundStyle(.ypBlackDay)
    }
}

private struct CheckboxCircleView: View {
    let isSelected: Bool

    var body: some View {
        Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
            .font(.system(size: 20))
            .foregroundStyle(.ypBlackDay)
    }
}

struct CarriersFilterView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedDepartureRanges: Set<DepartureTimeRange>
    @State private var transfersSelection: TransfersFilter?

    let onApply: (Set<DepartureTimeRange>, TransfersFilter?) -> Void

    init(
        initialRanges: Set<DepartureTimeRange> = [],
        initialTransfers: TransfersFilter? = nil,
        onApply: @escaping (Set<DepartureTimeRange>, TransfersFilter?) -> Void
    ) {
        _selectedDepartureRanges = State(initialValue: initialRanges)
        _transfersSelection = State(initialValue: initialTransfers)
        self.onApply = onApply
    }

    var body: some View {
        ZStack {
            Color(.ypWhiteDay)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 35) {

                VStack(alignment: .leading, spacing: 38) {
                    Text("Время отправления")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.ypBlackDay)

                    ForEach(DepartureTimeRange.allCases) { range in
                        HStack {
                            Text(range.title)
                                .font(.system(size: 17))
                                .foregroundStyle(.ypBlackDay)

                            Spacer()

                            CheckboxSquareView(
                                isSelected: selectedDepartureRanges.contains(range)
                            )
                            .onTapGesture {
                                toggleRange(range)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 38) {
                    Text("Показывать варианты с пересадками")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.ypBlackDay)

                    HStack {
                        Text("Да")
                            .font(.system(size: 17))
                            .foregroundStyle(.ypBlackDay)

                        Spacer()

                        CheckboxCircleView(
                            isSelected: transfersSelection == .yes
                        )
                        .onTapGesture {
                            transfersSelection = .yes
                        }
                    }

                    HStack {
                        Text("Нет")
                            .font(.system(size: 17))
                            .foregroundStyle(.ypBlackDay)

                        Spacer()

                        CheckboxCircleView(
                            isSelected: transfersSelection == .no
                        )
                        .onTapGesture {
                            transfersSelection = .no
                        }
                    }
                }
                Spacer(minLength: 120)
            }
            .padding(16)

            VStack {
                Spacer()

                Button {
                    onApply(selectedDepartureRanges, transfersSelection)
                    dismiss()
                } label: {
                    Text("Применить")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.ypBlue))
                        .foregroundStyle(Color(.ypWhite))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(.ypBlackDay)
                }
            }
        }
        .tint(.ypBlackDay)
    }

    private func toggleRange(_ range: DepartureTimeRange) {
        if selectedDepartureRanges.contains(range) {
            selectedDepartureRanges.remove(range)
        } else {
            selectedDepartureRanges.insert(range)
        }
    }
}

#Preview {
    NavigationStack {
        CarriersFilterView { _, _ in }
    }
}
