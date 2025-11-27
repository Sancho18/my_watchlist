# 🎬 My Watchlist

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-purple?style=for-the-badge&logo=flutter&logoColor=white)

> **App de catálogo de filmes desenvolvido com Flutter.** > O objetivo deste projeto é demonstrar a aplicação de conceitos avançados de arquitetura, consumo de API REST e persistência de dados local.

---

## 📱 Screenshots

| Home (Carrossel) | Detalhes do Filme | Busca (Debounce) | Favoritos (Offline) |
|:---:|:---:|:---:|:---:|
| <img src="screenshots/home.png" width="200"> | <img src="screenshots/details.png" width="200"> | <img src="screenshots/search.png" width="200"> | <img src="screenshots/favorites.png" width="200"> |

*(Nota: Substitua os caminhos acima pelos seus prints ou remova esta tabela se não tiver imagens ainda)*

---

## ✨ Funcionalidades

-   **Feed de Filmes:** -   Carrossel interativo com filmes Populares (Auto-scroll).
    -   Listagem de filmes Melhores Avaliados (Top Rated).
    -   "Pull to Refresh" para atualização de dados.
-   **Detalhes:** Informações completas, sinopse, nota e pôster em alta resolução.
-   **Busca Inteligente:** Pesquisa de filmes com **Debounce** para otimizar chamadas à API.
-   **Favoritos Offline:** Persistência local utilizando **Hive** e **GetStorage**, permitindo acesso à lista mesmo sem internet.
-   **Cache de Dados:** O app salva as listas da API localmente para carregamento instantâneo (Offline-first approach).

---

## 🛠️ Tecnologias e Arquitetura

O projeto foi estruturado utilizando o padrão de módulos (baseado no GetX Pattern), visando desacoplamento e escalabilidade.

-   **Linguagem:** Dart
-   **Framework:** Flutter
-   **Gerência de Estado & Rotas:** [GetX](https://pub.dev/packages/get)
-   **Cliente HTTP:** [Dio](https://pub.dev/packages/dio)
-   **Banco de Dados Local (NoSQL):** [Hive](https://pub.dev/packages/hive)
-   **Persistência Leve:** [GetStorage](https://pub.dev/packages/get_storage)
-   **API:** [The Movie DB (TMDb)](https://www.themoviedb.org/documentation/api)

### Estrutura de Pastas (Resumo)