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
