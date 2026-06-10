# Roadmap para Expansão de Boas Práticas do Google

Este documento estabelece o plano de ação para integrar e alinhar o **Agent Starter Kit** com recursos adicionais de melhores práticas de engenharia, guias de estilo e padrões de desenvolvimento da Google.

---

## Objetivos
1. **Elevar a qualidade do código produzido**: Garantir que o Coder e o Reviewer usem padrões idênticos aos aplicados na engenharia de software da Google.
2. **Melhorar a documentação gerada pelos agentes**: Alinhar o tom, a estrutura e a clareza com o guia de escrita técnica da Google.
3. **Padronizar designs de APIs e testes**: Introduzir critérios objetivos para criação de interfaces de programação e testes automatizados robustos.

---

## Plano de Ação

### Fase 1: Diretrizes de Autor de Alterações (CL Author's Guide)
* **Objetivo**: Guiar o papel do desenvolvedor (`personas/coder.md`) nas práticas recomendadas para criar commits/alterações de código limpas e fáceis de revisar.
* **Ações**:
  * Atualizar o playbook do [coder.md](file:///c:/GitHub/g-agent-starter-kit/personas/coder.md) com regras para divisão de tarefas em alterações pequenas (Small CLs).
  * Reforçar no [skills/coder-self-review.md](file:///c:/GitHub/g-agent-starter-kit/skills/coder-self-review.md) a necessidade de detalhar o impacto e a motivação técnica nas mensagens de commit/entregas.
* **Referência**: [Google CL Author's Guide](https://google.github.io/eng-practices/review/developer/).

### Fase 2: Estilo de Documentação Técnica e Escrita
* **Objetivo**: Fazer com que as saídas textuais e documentações geradas pelos agentes adotem tom e clareza profissional.
* **Ações**:
  * Expandir o [rules/edicts/code-style-markdown.md](file:///c:/GitHub/g-agent-starter-kit/rules/edicts/code-style-markdown.md) com diretrizes de estilo de escrita (voz ativa, evitar jargões desnecessários, formatação de listas de forma clara, uso correto de termos técnicos).
* **Referência**: [Google Developer Documentation Style Guide](https://developers.google.com/style).

### Fase 3: Padrões de Design de APIs
* **Objetivo**: Padronizar as interfaces REST e estruturas de dados criadas pelos agentes.
* **Ações**:
  * Criar o edito `rules/edicts/api-design.md` contendo as regras de nomenclatura de rotas, métodos padrão (List, Get, Create, Update, Delete) e convenções de payloads JSON.
  * Atualizar o [personas/architect.md](file:///c:/GitHub/g-agent-starter-kit/personas/architect.md) para consultar este edito ao propor alterações em APIs.
* **Referência**: [Google API Design Guide](https://cloud.google.com/apis/design).

### Fase 4: Boas Práticas de Testes (Testing on the Toilet)
* **Objetivo**: Assegurar a criação de suítes de testes limpas, determinísticas e fáceis de manter.
* **Ações**:
  * Criar o edito `rules/edicts/testing-practices.md` detalhando:
    * Uso de testes herméticos (sem dependências externas/rede na categoria "Small").
    * Preferência por comportamento em detrimento de estrutura (evitar mock-heavy tests).
    * Diferença entre DRY e DAMP em testes.
* **Referência**: [Google Testing on the Toilet](https://testing.googleblog.com/).

### Fase 5: Resiliência e Produção (Padrões SRE)
* **Objetivo**: Integrar conceitos de estabilidade de produção nas revisões de código.
* **Ações**:
  * Atualizar o [rules/edicts/code-quality.md](file:///c:/GitHub/g-agent-starter-kit/rules/edicts/code-quality.md) para cobrir tratamento robusto de falhas (backoff exponencial com jitter em conexões externas e retries) e estruturação de logs (observabilidade).
* **Referência**: [Site Reliability Engineering (SRE) Books](https://sre.google/books/).

### Fase 6: Guias de Estilo Front-end e Web (HTML/CSS e JS/TS)
* **Objetivo**: Oferecer guias de estilo oficiais para quando o kit for utilizado em projetos web.
* **Ações**:
  * Criar `rules/edicts/code-style-typescript.md` baseado no guia do Google.
  * Criar `rules/edicts/code-style-html-css.md` para garantir formatação limpa e semântica nas marcações de tela.
* **Referências**: 
  * [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)
  * [Google HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html)

---

## Resumo e Prioridades

| Fase | Item | Impacto | Dificuldade | Prioridade |
| :--- | :--- | :--- | :--- | :--- |
| **Fase 1** | CL Author's Guide | Médio | Baixa | Alta |
| **Fase 2** | Developer Documentation Guide | Alto | Baixa | Alta |
| **Fase 3** | API Design Guide | Alto | Média | Média |
| **Fase 4** | Testing on the Toilet | Alto | Média | Alta |
| **Fase 5** | Princípios de SRE / Resiliência | Médio | Média | Média |
| **Fase 6** | HTML/CSS & TS Style Guides | Alto | Baixa | Baixa (sob demanda) |
