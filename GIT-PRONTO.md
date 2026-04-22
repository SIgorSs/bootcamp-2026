
# 🎉 Git Setup Completo - Próximas Ações

## ✅ O que foi feito

```
✅ Symlinks criados (magento2 → ../magento2, aem → ../aem)
✅ .gitignore configurado
✅ Referências copiadas (módulos, seções, rotas)
✅ Git inicializado
✅ Primeiro commit feito (57 arquivos)
✅ Estrutura pronta
```

---

## 🚀 Próximas Ações

### 1️⃣ Adicionar Remoto (GitHub ou GitLab)

**GitHub:**
```bash
cd /home/igors/projects/bootcamp-2026

# Criar repositório em https://github.com/seu-usuario/bootcamp-2026
# Depois rodar:

git remote add origin https://github.com/seu-usuario/bootcamp-2026.git
git branch -M main
git push -u origin main
```

**GitLab:**
```bash
git remote add origin https://gitlab.com/seu-usuario/bootcamp-2026.git
git branch -M main
git push -u origin main
```

**Gitea (Auto-hospedado):**
```bash
git remote add origin https://seu-gitea.com/usuario/bootcamp-2026.git
git branch -M main
git push -u origin main
```

---

### 2️⃣ Verificar o Repositório

```bash
cd /home/igors/projects/bootcamp-2026

# Ver symlinks
ls -la | grep "magento2\|aem"

# Ver status Git
git status

# Ver commits
git log --oneline

# Ver remote
git remote -v

# Ver estrutura
tree -L 2 -I 'node_modules|vendor|.git'
```

---

### 3️⃣ Estrutura Final do Git

```
bootcamp-2026/ (REPOSITÓRIO GIT)
│
├─ .git/ ............................ Repositório Git
│
├─ 📚 DOCUMENTAÇÃO (NO GIT)
│  ├─ README.md
│  ├─ SETUP.md
│  ├─ ESTRUTURA-GIT.md
│  ├─ INSTRUCOES-INSTALACAO.md
│  ├─ COMECE-AQUI.md
│  └─ docs/ (endpoints, arquitetura, checklist)
│
├─ 🔧 CÓDIGO BOOTCAMP (NO GIT)
│  ├─ adobe-commerce/
│  │  └─ app/code/Bootcamp/
│  │     ├─ CatalogApi/
│  │     └─ AemContent/
│  │
│  ├─ shopify-theme/
│  │  ├─ sections/bootcamp-products.liquid
│  │  └─ assets/bootcamp-products.css
│  │
│  └─ shopify-hydrogen/
│     ├─ index.jsx.example
│     ├─ about.jsx.example
│     └─ ProductCard.jsx.example
│
├─ 📦 REFERÊNCIAS (NO GIT)
│  └─ referencias/
│     ├─ magento-modules/
│     ├─ shopify-theme/
│     ├─ shopify-hydrogen/
│     └─ aem-config/
│
├─ 🔗 SYMLINKS (NÃO NO GIT)
│  ├─ magento2 → /home/igors/projects/magento2
│  └─ aem → /home/igors/projects/aem
│
└─ 📋 CONFIGURAÇÃO
   ├─ .gitignore (com symlinks ignorados)
   └─ setup-git.sh (script de setup)
```

---

## 📊 Resumo do Git

| Item | Localização | Status |
|------|-------------|--------|
| **Documentação** | Root | ✅ No Git |
| **Módulos Magento** | adobe-commerce/ | ✅ No Git |
| **Seção Shopify** | shopify-theme/ | ✅ No Git |
| **Rotas Hydrogen** | shopify-hydrogen/ | ✅ No Git |
| **Referências** | referencias/ | ✅ No Git |
| **Magento Completo** | magento2 (symlink) | ❌ NÃO no Git |
| **AEM Completo** | aem (symlink) | ❌ NÃO no Git |

---

## 🎯 Como Clonar Depois

Quando outro dev clonar o projeto:

```bash
# Clone
git clone https://seu-repo/bootcamp-2026.git
cd bootcamp-2026

# Os symlinks estarão "quebrados" (apontam para paths locais)
# Isso é normal! Cada dev tem seus próprios Magento/AEM

# Para usar, cada dev precisa:
# 1. Ter Magento em ../magento2
# 2. Ter AEM em ../aem
# OU
# 3. Reconectar os symlinks

# Reconectar symlinks (exemplos):
rm magento2 aem
ln -s /meu/caminho/magento2 ./magento2
ln -s /meu/caminho/aem ./aem
```

---

## 🌳 Estrutura de Branches (Recomendado)

```bash
# Criar branches para desenvolvimento
git branch develop
git branch feature/magento-customization
git branch feature/aem-components
git branch feature/shopify-integration

# Ou apenas trabalhar em main/master
# (mais simples para bootcamp)
```

---

## 📤 Fazer Commits Depois

```bash
# Após modificar algo
git status

# Adicionar arquivos
git add .

# Ou adicionar específicos
git add README.md
git add adobe-commerce/

# Commit
git commit -m "📝 Descrição do que mudou"

# Push
git push origin main
```

---

## 🔒 Ignorando Magento e AEM no Git

Os symlinks estão no `.gitignore`, então não serão commitados.

Isso significa:
- ✅ Mudanças em Magento (fora do Git)
- ✅ Mudanças em AEM (fora do Git)
- ✅ Apenas código do Bootcamp será versionado

---

## 🚨 Importante: Mudanças em Módulos

Se você modificar os módulos Magento, **copie para referências/**:

```bash
# Após modificar CatalogApi
cp -r /home/igors/projects/magento2/app/code/Bootcamp/CatalogApi \
      ./referencias/magento-modules/

# Depois commit
git add referencias/
git commit -m "🔧 Atualizar módulo CatalogApi"
```

---

## ✨ Exemplo Completo: GitHub

```bash
# 1. Criar repositório em GitHub (botão "New" em github.com)
# Nome: bootcamp-2026
# Descrição: "Integração Adobe Commerce + AEM + Shopify Hydrogen"

# 2. Ir para o projeto local
cd /home/igors/projects/bootcamp-2026

# 3. Adicionar remote
git remote add origin https://github.com/seu-usuario/bootcamp-2026.git

# 4. Renomear branch
git branch -M main

# 5. Fazer push
git push -u origin main

# 6. Verificar em https://github.com/seu-usuario/bootcamp-2026 ✅

# 7. Próximos commits
git add .
git commit -m "descrição"
git push
```

---

## 🎯 Checklist Final

- [ ] Escolher GitHub, GitLab ou outro
- [ ] Criar repositório remoto
- [ ] Rodar `git remote add origin`
- [ ] Rodar `git branch -M main`
- [ ] Rodar `git push -u origin main`
- [ ] Verificar repositório remoto
- [ ] Compartilhar URL com time

---

## 📞 Próximos Passos

1. **Fazer push** (ver exemplos acima)
2. **Começar Fase 1** → Abra [SETUP.md](SETUP.md)
3. **Rastrear** → Use [docs/checklist.md](docs/checklist.md)
4. **Testar** → Use [docs/endpoints.md](docs/endpoints.md)

---

**Tudo pronto! Escolha um remoto e faça push agora! 🚀**

