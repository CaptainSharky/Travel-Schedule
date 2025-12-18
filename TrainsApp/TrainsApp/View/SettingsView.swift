import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false

    var body: some View {
        ZStack {
            Color(.ypWhiteDay)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Text("Темная тема")
                            .font(.system(size: 17))
                            .foregroundStyle(.ypBlackDay)

                        Spacer()

                        Toggle("", isOn: $isDarkThemeEnabled)
                            .labelsHidden()
                            .tint(.ypBlue)
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 16)

                    NavigationLink {
                        AgreementView()
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        HStack {
                            Text("Пользовательское соглашение")
                                .font(.system(size: 17))
                                .foregroundStyle(.ypBlackDay)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.ypBlackDay)
                        }
                        .frame(height: 60)
                        .padding(.horizontal, 16)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                VStack(spacing: 16) {
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.ypBlackDay)

                    Text("Версия 1.0 (beta)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.ypBlackDay)
                }
                .padding(.bottom, 16)
            }
            .padding(.top, 24)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
