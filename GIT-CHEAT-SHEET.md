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
