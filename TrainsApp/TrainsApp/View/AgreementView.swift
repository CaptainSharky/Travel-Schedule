import SwiftUI

struct AgreementView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.ypWhiteDay)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text(nameText)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.ypBlackDay)
                    Text(infoText)
                        .font(.system(size: 17, weight: .regular))
                    Text("1. ТЕРМИНЫ")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.vertical, 24)
                    Text(agreementText)
                        .font(.system(size: 17, weight: .regular))
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Пользовательское соглашение")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.ypBlackDay)
            }

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
    }

    // Mock текст
    let nameText = "Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум  для физических лиц"
    let infoText = "Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer\n \nРоссийская Федерация, город Москва"
    let agreementText = """
        Понятия, используемые в Оферте, означают следующее:
        
        Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.
        
        Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе. В процессе обучения в рамках Вводного курса Студенту предоставляется возможность ознакомления с работой Сервиса и определения возможности Студента продолжить обучение в рамках Полного курса по выбранной Студентом Программе обучения. Точное количество часов обучения в рамках Вводного курса зависит от выбранной Студентом Профессии или Курса и определяется в Программе обучения, размещенной на Сервисе. Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
        """
}

#Preview {
    NavigationStack {
        AgreementView()
    }
}
