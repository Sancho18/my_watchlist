# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), e este projeto adere ao [Versionamento Semântico](https://semver.org/spec/v2.0.0.html).

## [0.3.1] - 2025-10-13

### Corrigido

- Resolvido bug de loading infinito na tela inicial
- Melhorada a lógica de inicialização do Hive e gerenciamento de estado do loading
- Adicionados logs detalhados para facilitar o diagnóstico de problemas
- Otimizado o fluxo de carregamento de dados priorizando a API antes do cache

## [0.3.0] - 2025-09-25

Esta versão introduziu grandes melhorias de arquitetura e performance, focando em cache de dados e experiência do usuário.

### Adicionado

- Implementado cache de dados com o banco de dados local **Hive** para a lista de filmes populares. O app agora carrega a lista instantaneamente em aberturas subsequentes.
- Adicionada funcionalidade "Puxar para Atualizar" (`Pull-to-Refresh`) na tela inicial para forçar a busca de novos dados da API.

### Alterado

- Refatorada a arquitetura de dados com a introdução do **Padrão de Repositório** (`MovieRepository`), que agora gerencia a decisão de buscar dados do cache local ou da API.
- O `HomeController` foi atualizado para consumir dados do `MovieRepository`, desacoplando a UI da fonte de dados direta.
- **Ícone do aplicativo alterado**: O ícone padrão do Flutter foi substituído por um ícone personalizado usando o pacote `flutter_launcher_icons`.

## [0.2.0] - 2025-09-25

Foco em interatividade do usuário, persistência de dados e novas funcionalidades de descoberta.

### Adicionado

- Criado sistema completo de **Favoritos** para permitir que os usuários salvem seus filmes preferidos.
- Adicionado o pacote `get_storage` para persistência local da lista de IDs de filmes favoritos.
- Implementado um `FavoritesController` global e permanente (`Get.put(..., permanent: true)`) para gerenciar o estado dos favoritos em tempo real através de todo o aplicativo.
- Adicionados botões reativos (`Obx`) para favoritar/desfavoritar filmes nas telas de Home e Detalhes.
- Criada a nova tela de **Favoritos**, que exibe a lista de filmes salvos pelo usuário.
- Implementada a funcionalidade de **Busca de Filmes** em uma nova tela dedicada.
- Utilizada a técnica de **debounce** na barra de busca para otimizar as chamadas à API, evitando requisições a cada letra digitada.
- A tela de busca agora gerencia múltiplos estados de UI (inicial, carregando, sucesso, lista vazia e erro) para uma melhor experiência do usuário.

## [0.1.0] - 2025-09-25

Versão inicial do aplicativo, estabelecendo a base da arquitetura e as funcionalidades principais.

### Adicionado

- Estrutura inicial do projeto utilizando o framework **GetX** para gerenciamento de estado, rotas e injeção de dependências.
- Implementada a **Tela Principal (Home)** que exibe uma lista de filmes populares consumindo a API pública do The Movie Database (TMDb).
- Criada a **Tela de Detalhes**, que exibe informações aprofundadas sobre um filme específico.
- Implementada a navegação entre a tela Home e a de Detalhes, passando o ID do filme como argumento.
- Criados os modelos de dados (`Movie`, `Genre`) para converter as respostas JSON da API em objetos Dart de forma segura.
- Arquitetura organizada em módulos (features), separando `Providers` (camada de dados), `Controllers` (lógica de negócio) e `Views` (UI).