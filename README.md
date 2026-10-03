# 🕌 Rafeeq

> **Your Islamic Companion.**

Rafeeq is a free Islamic companion app built to help Muslims stay connected to the **Qur'an, Salah, Adhkar, and their deen** in their everyday lives.

Built by a Muslim, **for the Ummah.** 🤍

---

## ✨ About Rafeeq

Rafeeq started with a simple idea:

> **What if there was one simple app to help a Muslim stay closer to Allah throughout the day?**

From Qur'an goals and Salah reminders to Adhkar, Qibla, and Islamic resources, Rafeeq brings together tools designed to make practicing and staying connected to Islam easier.

The project began with a focus on Muslim students navigating university life, but it has grown into something for **the wider Ummah**.

**Rafeeq means "companion"** — and that's exactly what the app aims to be.

---

## 🌙 Features

* 📖 **Qur'an**

  * Read the Qur'an
  * Set daily Qur'an goals
  * Track your progress
  * Listen to Qur'an recitations

* 🕋 **Salah**

  * Accurate prayer times
  * Salah reminders
  * Location-based prayer calculations
  * Multiple calculation methods

* 🤲 **Adhkar**

  * Daily adhkar
  * Morning & evening remembrance
  * Browse authentic Islamic supplications

* 🧭 **Qibla**

  * Find the direction of the Ka'bah
  * Built-in Qibla compass

* 📻 **Islamic Audio**

  * Qur'an recitations
  * Islamic audio content
  * Background playback

* 🕋 **Haramain Live**

  * Listen to live broadcasts from the Haramain

* 💚 **Asmaul Husna**

  * Learn the 99 Names of Allah
  * Names available in multiple languages

* 🔔 **Reminders & Notifications**

  * Salah notifications
  * Qur'an goal reminders
  * Islamic reminders

---

## 🛠️ Tech Stack

Rafeeq is built with Flutter and a modern cross-platform stack.

| Technology          | Purpose                                |
| ------------------- | -------------------------------------- |
| **Flutter**         | Cross-platform UI                      |
| **Dart**            | Application language                   |
| **Riverpod**        | State management                       |
| **Hive**            | Local storage & caching                |
| **Supabase**        | Backend services                       |
| **Firebase**        | Analytics, Crashlytics & notifications |
| **AlAdhan API**     | Prayer times                           |
| **Hisn Muslim API** | Adhkar                                 |
| **Flutter Compass** | Qibla direction                        |
| **Audio Service**   | Background audio                       |

---

## 🏗️ Architecture

Rafeeq follows a lightweight **Clean Architecture** approach designed to keep the codebase maintainable without over-engineering it.

```text
UI
 │
 ▼
Riverpod Providers
 │
 ▼
Use Cases
 │
 ▼
Repositories
 │
 ▼
Data Sources
 │
 ├── Remote APIs
 └── Local Storage
```

The goal is simple:

**Keep things modular, testable, and easy to understand.**

---

## 🚀 Getting Started

### Prerequisites

Make sure you have:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* An Android/iOS development environment

### Clone the repository

```bash
git clone https://github.com/DevMohaa/rafeeq.git

cd rafeeq
```

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

---

## 🔐 Configuration

Some services used by Rafeeq require configuration through environment variables or project-specific credentials.

Create the required configuration files/variables before running the project.

**Never commit private API keys, service credentials, or signing keys to the repository.**

---

## 🤝 Contributing

Contributions are welcome!

Whether you're a Flutter developer, designer, tester, Islamic scholar, or simply someone with a good idea for improving Rafeeq — your contribution can help.

### Before contributing

1. Fork the repository
2. Create a feature branch

```bash
git checkout -b feature/my-feature
```

3. Make your changes
4. Test your changes

```bash
flutter analyze
flutter test
```

5. Commit your changes

```bash
git commit -m "feat: add my feature"
```

6. Push your branch

```bash
git push origin feature/my-feature
```

7. Open a Pull Request

---

## 💡 Project Philosophy

Rafeeq isn't being built just to be another Islamic app.

The goal is to build something that is:

* **Simple** — Islam doesn't need unnecessary complexity.
* **Useful** — Every feature should provide real benefit.
* **Accessible** — Islamic tools should be available to everyone.
* **Respectful** — Islamic content should be handled with care.
* **Free** — The intention is for Rafeeq to remain free for Muslims.

> **A small tool that helps someone pray on time, read one more page of Qur'an, or remember Allah is worth building.**

---

## 🗺️ Roadmap

Rafeeq is actively being developed.

Some areas we're exploring include:

* [ ] More Qur'an features
* [ ] Improved Salah experience
* [ ] More languages
* [ ] More Islamic content
* [ ] Better personalization
* [ ] Community-driven improvements
* [ ] iOS support improvements
* [ ] More accessibility features

The roadmap will evolve as Rafeeq grows and as we learn from the people using it.

---

## 📱 Download Rafeeq

Rafeeq is available on Android.

**Google Play:**
https://play.google.com/store/apps/details?id=com.mohaa.rafeeq

> **Free forever, in shaa Allah.** 🤍

---

## 🧑‍💻 Built by

**Mohaa — Mohammed Hassan**

Rafeeq is currently developed independently with the intention of building something beneficial for the Ummah.

Built with **Flutter, lots of coffee, and plenty of du'a.** ☕️🤲

---

## 📜 License

This project is currently distributed under the license included in this repository.

Please review the license before using, modifying, or redistributing the code.

---

## 🤲 Make Du'a

If you've found Rafeeq useful, make du'a that Allah accepts it, puts barakah in it, and allows it to benefit Muslims around the world.

**وَقُلْ رَبِّ زِدْنِي عِلْمًا**

*"And say: My Lord, increase me in knowledge."*
— Qur'an 20:114

---

**Rafeeq — Your Islamic Companion.** 🕌
