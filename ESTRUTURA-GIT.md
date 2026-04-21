# 📂 Estrutura do Projeto + Git

## 🎯 Problema

- **Magento 2:** Instalado em `/home/igors/projects/magento2` (WSL)
- **AEM:** Instalado em `/home/igors/projects/aem` (Docker)
- **Bootcamp:** Novo projeto em `/home/igors/projects/bootcamp-2026`

Você quer **1 repositório Git único** que englobe tudo.

---

## ✅ Solução: Git Submódulos + Estrutura Local

### Opção 1: Usar Git Submódulos (RECOMENDADO)

```
bootcamp-2026/ (REPOSITÓRIO PRINCIPAL)
├─ .gitmodules
├─ 📚 Documentação (local)
├─ 🔧 código-bootcamp/ (local)
├─ 🔗 magento2/ → /home/igors/projects/magento2 (SUBMÓDULO)
└─ 🔗 aem/ → /home/igors/projects/aem (SUBMÓDULO)
```

**Vantagens:**
- ✅ Magento e AEM têm seus próprios repositórios
- ✅ Bootcamp rastreia versões específicas
- ✅ Fácil fazer deploy
- ✅ Git clean

**Como setup:**

```bash
cd /home/igors/projects/bootcamp-2026

# Inicializar Git
git init

# Adicionar submódulos
git submodule add ../magento2 ./magento2
git submodule add ../aem ./aem

# Clonar depois
git clone --recursive https://seu-repo/bootcamp-2026
```

---

### Opção 2: Symlinks + Um Repositório (MAIS SIMPLES)

```
bootcamp-2026/ (REPOSITÓRIO)
├─ .git/
├─ 📚 Documentação
├─ 🔧 Código Bootcamp
├─ magento2 → /home/igors/projects/magento2 (SYMLINK)
└─ aem → /home/igors/projects/aem (SYMLINK)
```

**Como criar:**

```bash
cd /home/igors/projects/bootcamp-2026

# Criar symlinks
ln -s ../magento2 ./magento2
ln -s ../aem ./aem

# Adicionar ao .gitignore
echo "magento2" >> .gitignore
echo "aem" >> .gitignore
```

---

### Opção 3: Cópia Local + Monorepo (MAIS FLEXÍVEL)

```
bootcamp-2026/ (REPOSITÓRIO - TUDO LOCAL)
├─ .git/
├─ 📚 docs/ ........................... Documentação
├─ 🔧 código-bootcamp/ ............... Código local
├─ 📦 magento/
│  ├─ app/code/Bootcamp/ ........... CÓPIA dos módulos
│  ├─ SETUP-magento.md ............ Instruções
│  └─ .env.magento.example
├─ 🏗️ aem/
│  ├─ wknd-bootcamp/ ............... Código AEM
│  ├─ SETUP-aem.md ................ Instruções
│  └─ pom.xml.example
└─ 🛍️ shopify/
   ├─ theme/ ...................... Liquid
   └─ hydrogen/ ................... React
```

---

## 🚀 MINHA RECOMENDAÇÃO

Use **Opção 2 (Symlinks)** porque:

1. ✅ Simples de setup
2. ✅ Um repositório Git único
3. ✅ Referencia projetos reais (Magento + AEM)
4. ✅ Fácil de fazer push
5. ✅ Magento e AEM mantêm seus próprios .git

---

## 📋 Setup Passo a Passo (OPÇÃO 2)

### 1️⃣ Criar Symlinks

```bash
cd /home/igors/projects/bootcamp-2026

# Criar symlinks
ln -s ../magento2 ./magento2
ln -s ../aem ./aem

# Verificar
ls -la | grep magento
ls -la | grep aem
```

### 2️⃣ Atualizar .gitignore

```bash
# Adicionar ao .gitignore existente
cat >> .gitignore << 'EOF'

# Symlinks (não rastrear repositórios externos)
magento2
aem

# Node
shopify-hydrogen/node_modules/
shopify-hydrogen/.env

# Composer
vendor/
composer.lock

# AEM
aem/node_modules/
aem/target/
aem/.DS_Store

# Magento
magento2/var/
magento2/pub/media/
magento2/.env
EOF
```

### 3️⃣ Estruturar Código Bootcamp Localmente

```bash
# Criar diretórios para código do bootcamp
mkdir -p codigo-bootcamp/php
mkdir -p codigo-bootcamp/liquid
mkdir -p codigo-bootcamp/react

# Copiar módulos Magento (referência)
mkdir -p referencias/magento-modules
cp -r adobe-commerce/app/code/Bootcamp/* referencias/magento-modules/

# Copiar Shopify
mkdir -p referencias/shopify-theme
cp -r shopify-theme/* referencias/shopify-theme/

# Copiar Hydrogen
mkdir -p referencias/hydrogen
cp -r shopify-hydrogen/* referencias/hydrogen/
```

### 4️⃣ Criar README com Instruções de Instalação

```bash
cat > INSTRUCOES-INSTALACAO.md << 'EOF'
# 🚀 Como Instalar/Clonar o Projeto

## Clone o repositório com symlinks

```bash
git clone https://seu-repo/bootcamp-2026
cd bootcamp-2026
```

## Setup Magento (no WSL)

```bash
# O symlink `./magento2` aponta para /home/igors/projects/magento2
cd magento2

# Se é primeira vez
composer install
php bin/magento setup:install

# Copiar módulos do bootcamp
cp -r ../referencias/magento-modules/Bootcamp app/code/

# Ativar
php bin/magento module:enable Bootcamp_CatalogApi Bootcamp_AemContent
php bin/magento setup:upgrade
```

## Setup AEM (Docker)

```bash
# O symlink `./aem` aponta para /home/igors/projects/aem
cd aem

# Se é primeira vez
docker-compose up -d

# Copiar estrutura WKND
cp -r ../referencias/aem/* .
```

## Setup Shopify

```bash
# Referência local (sem clone real)
cd referencias/shopify-theme
# Adicionar manualmente ao tema no Shopify admin
```

## Setup Hydrogen

```bash
cd referencias/hydrogen

# Ou criar novo projeto
npx @shopify/create-hydrogen@latest my-project
cd my-project
npm install
```
EOF
```

### 5️⃣ Inicializar Git

```bash
# Se ainda não é repositório
cd /home/igors/projects/bootcamp-2026
git init

# Adicionar todos os arquivos (exceto o .gitignore)
git add .
git status  # Verificar

# Primeiro commit
git commit -m "🚀 Bootcamp 2026 - Estrutura Inicial

- Documentação completa (README, SETUP, checklist)
- Módulos Magento (CatalogApi, AemContent)
- Seção Shopify Liquid + CSS
- Rotas Shopify Hydrogen + componentes
- Symlinks para Magento e AEM (referências)"
```

### 6️⃣ Adicionar Remote

```bash
# GitHub
git remote add origin https://github.com/seu-usuario/bootcamp-2026.git
git branch -M main
git push -u origin main

# GitLab
git remote add origin https://gitlab.com/seu-usuario/bootcamp-2026.git
```

---

## 📊 Estrutura Final

```
bootcamp-2026/ (GIT REPO)
│
├─ .git/ ........................... Repositório Git
├─ .gitignore ...................... Exclui node_modules, vendor, etc
│
├─ 📚 DOCUMENTAÇÃO
│  ├─ README.md
│  ├─ SETUP.md
│  ├─ INSTRUCOES-INSTALACAO.md ... ⭐ NOVO
│  ├─ ESTRUTURA-GIT.md ........... ⭐ ESTE ARQUIVO
│  └─ docs/ (endpoints, arquitetura, checklist)
│
├─ 🔧 CÓDIGO BOOTCAMP (LOCAL)
│  ├─ referencias/
│  │  ├─ magento-modules/ ........ Cópia dos módulos
│  │  ├─ shopify-theme/ .......... Seção Liquid
│  │  ├─ hydrogen/ .............. Rotas React
│  │  └─ aem/ ................... Configurações AEM
│  │
│  └─ codigo-bootcamp/
│     ├─ php/ .................... Código PHP customizado
│     ├─ liquid/ ................. Código Liquid
│     └─ react/ .................. Código React
│
├─ 🔗 SYMLINKS (NÃO RASTREADOS)
│  ├─ magento2 → /home/igors/projects/magento2
│  └─ aem → /home/igors/projects/aem
│
└─ 📦 ARQUIVOS DE CONFIGURAÇÃO
   ├─ .env.example
   ├─ .gitignore
   └─ START.sh
```

---

## ✅ Checklist de Setup Git

- [ ] Criar symlinks (`ln -s`)
- [ ] Atualizar .gitignore
- [ ] Copiar referências para `referencias/`
- [ ] Criar INSTRUCOES-INSTALACAO.md
- [ ] `git init`
- [ ] `git add .`
- [ ] `git commit`
- [ ] Criar repositório remoto (GitHub/GitLab)
- [ ] `git remote add origin`
- [ ] `git push -u origin main`

---

## 🎯 Próximas Ações

### Se quiser Opção 2 (Symlinks - RECOMENDADO):

1. Executar os comandos de symlink
2. Atualizar .gitignore
3. Rodar `git init`
4. Fazer primeiro commit
5. Fazer push

### Se quiser Opção 1 (Submódulos):

1. `git submodule add ../magento2 ./magento2`
2. `git submodule add ../aem ./aem`
3. Fazer commit
4. Fazer push

---

## 📞 Dúvidas Comuns

**P: E se Magento for em servidor? Não em WSL?**
R: Mude Opção para Monorepo (Opção 3) - copie os módulos localmente

**P: E se quiser múltiplos remotes (GitHub + GitLab)?**
R: `git remote add backup https://...` depois `git push backup main`

**P: Como fazer clone depois?**
R: `git clone https://seu-repo && cd bootcamp-2026`
Os symlinks estarão quebrados, mas será criado um README indicando o setup

**P: Posso usar isso em produção?**
R: Sim! A estrutura é modular e escalável

---

**Escolha uma opção acima e me diga qual deseja implementar!** 🚀
