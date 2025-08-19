# Crypto Rate

Приложение для просмотра курсов криптовалют и обмена туда-сюда с авторизацией.

**Демо:** [https://crypto-rate-timtikh.web.app](https://crypto-rate-timtikh.web.app)

Пожалуйста не абьюзьте апи-ключ!

---

## Основные технологии

- **Flutter** – UI и навигация
- **Riverpod** – управление состоянием
- **Dio** – HTTP запросы к API
- **Firebase** – аутентификация
- **Clean Architecture** – разделение слоев где имеет смысл:
    - **Presentation** – страницы и UI
    - **Domain** – абстрактные репозитории и бизнес-логика
    - **Data** – конкретные реализации репозиториев, API-клиенты

## Основные функции

- Авторизация пользователей
- Просмотр курсов криптовалют по CoinGate и CoinCap на выбор
- Автообновление курсов каждые 30 секунд и ручное обновление
- Страница конвертации с комиссией 3%
- Предотвращение конвертации одинаковых валют


## Как запустить у себя

1. Клонируйте репозиторий:

```bash
git clone https://github.com/timtikh/crypto_rate.git
cd crypto_rate
``` 
2. Настройте Firebase для проекта:
```bash
flutterfire configure
```
Убедитесь в FirebaseConsole, что аутентификация включена.

3. Создайте файл /lib/api_keys.dart с вашим CoinCap API ключом:

```bash
class ApiKeys {
  static String coinCapApiKey = 'ваш_ключ_от_CoinCap';
}
```




