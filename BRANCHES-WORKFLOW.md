# 🌳 Git Branches - Bootcamp 2026

## ✅ Você escolheu: OPÇÃO 3 - Usar Branches!

Vamos usar **Git Flow** com branches isoladas:

```
main (produção)
  ↓
develop (staging)
  ↓
feature/* (desenvolvimento)
```

---

## 🏗️ Estrutura de Branches

### Branch Principal: `main`
```bash
# Código pronto para produção
# Merge apenas quando tudo está testado
# Tag com versões
```

### Branch Staging: `develop`
```bash
# Integração de múltiplas features
# Sempre deve estar "working"
# Base para novos features
```

### Branches de Feature: `feature/*`
```bash
# Um branch por feature
# Isolado de tudo
# Fácil fazer rollback
```

---

## 🚀 Como Usar

### 1️⃣ Começar uma Nova Feature

```bash
cd /home/igors/projects/bootcamp-2026

# Atualizar develop
git checkout develop
git pull

# Criar novo branch
git checkout -b feature/catalogo-api

# Ou com padrão melhorado
git checkout -b feature/magento-catalogo-api-2026
```

### 2️⃣ Editar com Segurança (Em seu branch)

```bash
# Editar com symlink (está seguro no seu branch)
vi magento2/app/code/Bootcamp/CatalogApi/Model/ProductList.php

# Limpar cache para testar
docker exec magento php bin/magento cache:flush

# Testar em navegador
# https://app.magento2.test/rest/V1/bootcamp/products
```

### 3️⃣ Fazer Commits

```bash
# Ver o que mudou
git status

# Adicionar arquivos
git add magento2/

# Commit descritivo
git commit -m "✨ Feature: Melhorar CatalogApi com paginação

- Adicionar paginação com limit/offset
- Filtro por SKU pattern
- Caching de 1 hora
- Testes adicionados"
```

### 4️⃣ Fazer Push do Branch

```bash
# Primeiro push
git push -u origin feature/catalogo-api

# Próximos pushs
git push
```

### 5️⃣ Criar Pull Request (GitHub/GitLab)

1. Abra o repositório no GitHub/GitLab
2. Clique em "New Pull Request" ou "Merge Request"
3. De: `feature/catalogo-api` → Para: `develop`
4. Adicione descrição
5. Abra o PR
6. Converse com time se houver review

### 6️⃣ Fazer Merge em Develop

```bash
# Opção A: Pelo GitHub/GitLab (Recomendado)
# Clique em "Merge Pull Request"

# Opção B: Pelo Terminal
git checkout develop
git pull
git merge feature/catalogo-api
git push
```

### 7️⃣ Fazer Merge em Main (Produção)

```bash
# Quando pronto para liberar
git checkout main
git pull
git merge develop
git tag -a v1.0.0 -m "Release Bootcamp 2026 v1.0.0"
git push
git push --tags
```

---

## 📊 Exemplo Prático Completo

```bash
# 1. Criar branch
git checkout develop
git pull
git checkout -b feature/magento-modulo-catalogo

# 2. Editar
vi magento2/app/code/Bootcamp/CatalogApi/Model/ProductList.php
docker exec magento php bin/magento cache:flush

# 3. Testar
curl https://app.magento2.test/rest/V1/bootcamp/products | jq

# 4. Commit
git add magento2/
git commit -m "🔧 Refatorar CatalogApi para melhor performance"

# 5. Push
git push -u origin feature/magento-modulo-catalogo

# 6. Abrir PR no GitHub
# (automático se você tiver GH CLI: gh pr create)

# 7. Merge em develop (via GitHub)
git checkout develop
git pull
git log --oneline | head -3  # Ver novo commit

# 8. Limpar branch local
git branch -d feature/magento-modulo-catalogo

# 9. Quando liberar para produção
git checkout main
git merge develop
git push
```

---

## 🎯 Convenção de Nomes de Branches

```
feature/  → Nova funcionalidade
  feature/magento-catalogo-api
  feature/aem-content-fragments
  feature/shopify-metafields

bugfix/   → Correção de bug
  bugfix/magento-cache-issue
  bugfix/aem-graphql-timeout

hotfix/   → Correção urgente em produção
  hotfix/magento-critical-error

release/  → Preparação de release
  release/v1.0.0

chore/    → Tarefas sem código
  chore/update-dependencies
  chore/update-documentation
```

---

## 📋 Workflow Completo (Todos os Dias)

```
1. MANHÃ: git checkout develop && git pull
2. DIA: Trabalhar em feature/sua-feature
3. ANTES DE SAIR: git push
4. SEMANAL: Fazer PR e merge em develop
5. MENSAL: Release para main
```

---

## 🔒 Proteções Recomendadas (GitHub)

Se trabalha em time, adicionar proteções em `main`:

1. Abra `Settings` → `Branches`
2. Adicione regra para `main`
3. ✅ Require pull request reviews
4. ✅ Require status checks to pass
5. ✅ Require branches to be up to date

---

## 🚨 Cuidados com Branches

### ❌ NUNCA fazer isso:
```bash
# Nunca editar direto em main
git checkout main
vi arquivo.php  # ❌ NUNCA!

# Nunca fazer merge sem PR
git checkout main
git merge feature/...  # ❌ NUNCA!

# Nunca fazer force push em main
git push -f origin main  # ❌ NUNCA!
```

### ✅ SEMPRE fazer isso:
```bash
# Sempre usar feature branch
git checkout -b feature/nome

# Sempre fazer PR antes de merge
git push -u origin feature/nome
# Abrir PR no GitHub/GitLab

# Sempre fazer pull antes de trabalhar
git checkout develop
git pull

# Sempre ter mensagens de commit descritivas
git commit -m "🎯 Descrição clara da mudança"
```

---

## 🎨 Commits com Emoji (Recomendado)

Use emojis para deixar claro o tipo de mudança:

```bash
✨ Feat:        nova funcionalidade
🐛 Fix:         correção de bug
📝 Docs:        documentação
🎨 Style:       formatação de código
♻️ Refactor:    refatoração sem mudança funcional
⚡ Perf:        melhoria de performance
✅ Test:        testes
🔧 Chore:       tarefas administrativas
🚀 Deploy:      deploy/release
⚠️ WIP:         work in progress (não fazer merge ainda!)
🔒 Security:    correção de segurança
```

**Exemplos:**

```bash
git commit -m "✨ Feat: Adicionar paginação em CatalogApi"
git commit -m "🐛 Fix: Corrigir cache timeout em GraphQL"
git commit -m "📝 Docs: Atualizar README com instruções"
git commit -m "⚡ Perf: Otimizar query de produtos"
```

---

## 🔄 Sincronizar com Symlinks

Como você tem symlinks, o workflow é:

```bash
# 1. Está em feature branch
git checkout -b feature/magento-fix

# 2. Edita via symlink (seguro porque está em branch)
vi magento2/app/code/Bootcamp/...

# 3. Docker vê mudança em tempo real
docker exec magento php bin/magento cache:flush

# 4. Testa de verdade
# Se funcionar, você está certo

# 5. Commit
git add magento2/
git commit -m "🔧 Fix: Melhorar ProductList"

# 6. Push
git push

# 7. Merge em develop
# (Só depois que tiver certeza)
```

---

## 📚 Comandos Úteis

```bash
# Ver todos os branches
git branch -a

# Ver branches remotos
git branch -r

# Remover branch local
git branch -d feature/catalogo-api

# Remover branch remoto
git push origin --delete feature/catalogo-api

# Renomear branch local
git branch -m feature/old-name feature/new-name

# Rebase um branch (sincronizar com develop)
git rebase origin/develop

# Ver diferença entre branches
git diff main develop

# Ver commits do branch
git log origin/feature/catalogo-api

# Ver quem fez o que
git blame magento2/app/code/Bootcamp/CatalogApi/Model/ProductList.php
```

---

## 🎯 Seus Primeiros Steps

### HOJE:

```bash
cd /home/igors/projects/bootcamp-2026

# 1. Criar branch develop (se não tiver)
git checkout -b develop
git push -u origin develop

# 2. Voltar a develop
git checkout develop

# 3. Criar primeira feature
git checkout -b feature/fase-1-magento-setup

# 4. Fazer alguma mudança
echo "# Fase 1 Setup" >> docs/FASE-1.md

# 5. Commit
git add docs/
git commit -m "📝 Docs: Adicionar guia da Fase 1"

# 6. Push
git push -u origin feature/fase-1-magento-setup

# 7. Fazer merge em develop (quando pronto)
git checkout develop
git merge feature/fase-1-magento-setup
git push
```

---

## ✅ Checklist

- [ ] Entendi a estrutura main → develop → feature/*
- [ ] Vou criar feature branch para cada tarefa
- [ ] Vou limpar cache antes de testar
- [ ] Vou fazer commits descritivos
- [ ] Vou fazer PR antes de merge
- [ ] Vou usar symlink com segurança em branches
- [ ] Vou nunca editar main diretamente

---

## 🎉 Pronto!

Agora você tem:
✅ Symlinks para alterações ao vivo
✅ Branches para isolamento
✅ Workflow seguro para time
✅ Git Flow profissional

**Próximo passo:** Criar primeira feature branch!

```bash
cd /home/igors/projects/bootcamp-2026
git checkout develop
git pull
git checkout -b feature/fase-1-setup
```

**Bom desenvolvimento!** 🚀
