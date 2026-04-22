#!/bin/bash

# 🌳 Git Flow Setup - Configurar Branches Automaticamente

set -e

PROJECT_DIR="/home/igors/projects/bootcamp-2026"

echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                        ║"
echo "║          🌳 GIT FLOW SETUP - CONFIGURAR BRANCHES 🌳                   ║"
echo "║                                                                        ║"
echo "║  Este script vai:                                                     ║"
echo "║  1. Criar branch develop                                              ║"
echo "║  2. Criar branch templates                                            ║"
echo "║  3. Configurar Git hooks                                              ║"
echo "║  4. Criar guia de branches                                            ║"
echo "║                                                                        ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

cd "$PROJECT_DIR"

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 1️⃣ CRIAR BRANCH DEVELOP
echo -e "${BLUE}1️⃣  Criando branch develop...${NC}"

if git rev-parse --verify develop >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Branch develop já existe${NC}"
    git checkout develop
else
    git checkout -b develop
    echo -e "${GREEN}✅ Branch develop criado${NC}"
fi

git push -u origin develop 2>/dev/null || true

echo ""

# 2️⃣ CRIAR TEMPLATE DE COMMIT
echo -e "${BLUE}2️⃣  Criando template de commit...${NC}"

mkdir -p .git/hooks .githooks

cat > .githooks/commit-msg-template << 'TEMPLATE'
# ═══════════════════════════════════════════════════════════════════
# Titulo com até 50 caracteres (use emoji!)
# ═══════════════════════════════════════════════════════════════════
# Exemplo:
# ✨ Feat: Adicionar paginação em CatalogApi
# 🐛 Fix: Corrigir cache timeout
# 📝 Docs: Atualizar README
# ♻️ Refactor: Simplificar ProductList

# ═══════════════════════════════════════════════════════════════════
# Descrição detalhada (limite de 72 caracteres por linha)
# ═══════════════════════════════════════════════════════════════════

# ═══════════════════════════════════════════════════════════════════
# EMOJIS RECOMENDADOS:
# ═══════════════════════════════════════════════════════════════════
# ✨ Feat:        nova funcionalidade
# 🐛 Fix:         correção de bug
# 📝 Docs:        documentação
# 🎨 Style:       formatação
# ♻️ Refactor:    refatoração
# ⚡ Perf:        performance
# ✅ Test:        testes
# 🔧 Chore:       tarefas admin
# 🚀 Deploy:      deploy/release
# ⚠️ WIP:         work in progress
# 🔒 Security:    segurança

# ═══════════════════════════════════════════════════════════════════
# REFERÊNCIAS (opcional):
# ═══════════════════════════════════════════════════════════════════
# Issue: #123
# Closes: #456
# Refs: #789

# ═══════════════════════════════════════════════════════════════════
# BRANCH:
# ═══════════════════════════════════════════════════════════════════
# feature/* → nova funcionalidade
# bugfix/*  → correção de bug
# hotfix/*  → urgente em produção
# release/* → preparação de release

TEMPLATE

git config commit.template .githooks/commit-msg-template
echo -e "${GREEN}✅ Template de commit configurado${NC}"

echo ""

# 3️⃣ CRIAR PRE-COMMIT HOOK
echo -e "${BLUE}3️⃣  Criando pre-commit hook...${NC}"

cat > .git/hooks/pre-commit << 'HOOK'
#!/bin/bash

# Verificar se está tentando fazer commit em main
BRANCH=$(git symbolic-ref --short HEAD)

if [ "$BRANCH" = "main" ]; then
  echo ""
  echo "❌ ERRO: Você está tentando fazer commit em MAIN!"
  echo ""
  echo "Fluxo correto:"
  echo "  1. git checkout develop"
  echo "  2. git checkout -b feature/sua-feature"
  echo "  3. Fazer mudanças"
  echo "  4. git commit (em feature branch)"
  echo ""
  exit 1
fi

if [ "$BRANCH" = "develop" ]; then
  echo ""
  echo "⚠️  AVISO: Você está em DEVELOP"
  echo "Melhor fazer em feature branch!"
  echo ""
  read -p "Tem certeza? [s/n]: " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    exit 1
  fi
fi

exit 0
HOOK

chmod +x .git/hooks/pre-commit
echo -e "${GREEN}✅ Pre-commit hook criado${NC}"

echo ""

# 4️⃣ CRIAR ARQUIVO GITFLOW-QUICK-REFERENCE
echo -e "${BLUE}4️⃣  Criando guia rápido de branches...${NC}"

cat > BRANCHES-QUICK.md << 'QUICK'
# 🌳 Git Branches - Referência Rápida

## 🚀 Começar Nova Feature (TODO DIA!)

```bash
# Atualizar develop
git checkout develop && git pull

# Criar feature branch
git checkout -b feature/sua-feature-aqui

# Trabalhar, editar, testar...

# Commit
git add .
git commit -m "✨ Feat: Descrição clara"

# Push
git push -u origin feature/sua-feature-aqui
```

## 📊 Branches Disponíveis

```bash
# Ver todos
git branch -a

# Mudar de branch
git checkout nome-do-branch

# Criar e mudar
git checkout -b novo-branch
```

## 🔄 Fazer Merge (GitHub é Melhor!)

```bash
# Via Terminal
git checkout develop
git pull
git merge feature/sua-feature
git push

# Via GitHub/GitLab
1. Abra repositório
2. New Pull Request
3. feature/sua-feature → develop
4. Create Pull Request
5. Merge quando pronto
```

## 🎯 Nomes de Branches

- `feature/magento-catalogo-api` → Nova feature
- `bugfix/cache-timeout` → Bug fix
- `hotfix/critical-error` → Urgente
- `chore/update-docs` → Tarefa

## ⚠️ Cuidados

```bash
# ❌ NUNCA editar main
git checkout main && vi arquivo.php  # NÃO!

# ❌ NUNCA force push em main
git push -f origin main  # NÃO!

# ✅ SEMPRE usar feature branch
git checkout -b feature/minha-tarefa  # SIM!

# ✅ SEMPRE fazer pull antes de começar
git checkout develop && git pull  # SIM!
```

## 🧹 Limpeza

```bash
# Remover branch local
git branch -d feature/pronta

# Remover branch remoto
git push origin --delete feature/pronta

# Ver branches deletadas
git branch -a | grep gone
```

---

**Mais detalhes:** `cat BRANCHES-WORKFLOW.md`
QUICK

echo -e "${GREEN}✅ Guia rápido criado${NC}"

echo ""

# 5️⃣ CRIAR .GITCONFIG LOCAL
echo -e "${BLUE}5️⃣  Criando configuração Git local...${NC}"

git config branch.autosetuprebase always
git config pull.rebase false
git config fetch.prune true

echo -e "${GREEN}✅ Configuração Git feita${NC}"

echo ""

# 6️⃣ CRIAR CHEAT SHEET
echo -e "${BLUE}6️⃣  Criando Git Cheat Sheet...${NC}"

cat > GIT-CHEAT-SHEET.md << 'CHEAT'
# 📋 Git Cheat Sheet - Bootcamp 2026

## Básico - TODOS OS DIAS

```bash
# Status
git status

# Ver mudanças
git diff

# Adicionar
git add .
git add arquivo.php

# Commit
git commit -m "✨ Feat: Descrição"

# Push
git push
```

## Branches

```bash
# Ver branches
git branch -a

# Criar branch
git checkout -b feature/nova

# Mudar branch
git checkout main

# Deletar branch local
git branch -d feature/pronta

# Deletar branch remoto
git push origin --delete feature/pronta
```

## Sincronizar

```bash
# Pull (fetch + merge)
git pull

# Fetch (trazer mudanças sem integrar)
git fetch

# Rebase (integrar develop em seu branch)
git fetch
git rebase origin/develop
```

## Desfazer

```bash
# Desfazer último commit (mantém mudanças)
git reset --soft HEAD~1

# Desfazer mudanças em arquivo
git checkout arquivo.php

# Desfazer tudo para último commit
git reset --hard HEAD

# Stash (guardar mudanças temporariamente)
git stash
git stash pop
```

## Histórico

```bash
# Ver commits
git log --oneline

# Ver commits com mudanças
git log -p

# Ver commits de um arquivo
git log arquivo.php

# Ver quem mexeu em linha
git blame arquivo.php
```

## Merge & Rebase

```bash
# Merge (combinar branches)
git merge feature/nova

# Abort merge se der erro
git merge --abort

# Rebase (reescrever histórico - cuidado!)
git rebase origin/develop

# Abort rebase se der erro
git rebase --abort
```

## Tags (para releases)

```bash
# Criar tag
git tag -a v1.0.0 -m "Release v1.0.0"

# Listar tags
git tag -l

# Push tags
git push --tags
```

## Configuração

```bash
# Ver configuração
git config --list

# Configurar usuário
git config user.name "Seu Nome"
git config user.email "seu@email.com"

# Template de commit
git config commit.template .githooks/commit-msg-template
```

---

**Precisa de mais ajuda?** `cat BRANCHES-WORKFLOW.md`
CHEAT

echo -e "${GREEN}✅ Cheat Sheet criado${NC}"

echo ""

# 7️⃣ RESUMO
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ GIT FLOW SETUP CONCLUÍDO!${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"

echo ""
echo -e "${BLUE}📊 O que foi configurado:${NC}"
echo "  ✅ Branch develop criado e pronto"
echo "  ✅ Template de commit com emojis"
echo "  ✅ Pre-commit hook (previne erros em main)"
echo "  ✅ Guia rápido de branches"
echo "  ✅ Cheat sheet de Git"
echo "  ✅ Configuração Git otimizada"

echo ""
echo -e "${BLUE}🚀 Próximos passos:${NC}"
echo ""
echo "1️⃣  Ver branches"
echo "    git branch -a"
echo ""
echo "2️⃣  Criar primeira feature"
echo "    git checkout -b feature/fase-1-setup"
echo ""
echo "3️⃣  Fazer mudanças e commit"
echo "    git add ."
echo "    git commit -m \"✨ Feat: Descrição\""
echo ""
echo "4️⃣  Push"
echo "    git push -u origin feature/fase-1-setup"
echo ""
echo "5️⃣  Merge em develop (via GitHub/GitLab)"
echo ""

echo ""
echo -e "${BLUE}📚 Consultar guias:${NC}"
echo "  • cat BRANCHES-WORKFLOW.md (completo)"
echo "  • cat BRANCHES-QUICK.md (rápido)"
echo "  • cat GIT-CHEAT-SHEET.md (referência)"

echo ""
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo ""

# Mostrar status
echo -e "${GREEN}✨ Status Final:${NC}"
echo ""
git branch -a
echo ""
git config --get commit.template | awk '{print "Template: " $1}'
echo ""
echo "Current branch: $(git symbolic-ref --short HEAD)"
echo ""

