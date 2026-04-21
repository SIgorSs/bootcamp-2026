#!/bin/bash

# 🚀 Setup Git Bootcamp 2026 - Automático

echo "╔═════════════════════════════════════════════════════════════════════════╗"
echo "║        🚀 BOOTCAMP 2026 - SETUP GIT AUTOMÁTICO 🚀                      ║"
echo "║                                                                         ║"
echo "║  Este script vai:                                                       ║"
echo "║  1. Criar symlinks para Magento e AEM                                  ║"
echo "║  2. Configurar .gitignore                                              ║"
echo "║  3. Criar estrutura de referências                                     ║"
echo "║  4. Inicializar repositório Git                                        ║"
echo "║  5. Fazer primeiro commit                                              ║"
echo "║                                                                         ║"
echo "╚═════════════════════════════════════════════════════════════════════════╝"
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

cd /home/igors/projects/bootcamp-2026

# 1️⃣ CRIAR SYMLINKS
echo -e "${BLUE}1️⃣  Criando symlinks...${NC}"

if [ -L magento2 ]; then
    echo -e "${YELLOW}⚠️  Symlink magento2 já existe${NC}"
else
    ln -s ../magento2 ./magento2
    echo -e "${GREEN}✅ Symlink magento2 criado${NC}"
fi

if [ -L aem ]; then
    echo -e "${YELLOW}⚠️  Symlink aem já existe${NC}"
else
    ln -s ../aem ./aem
    echo -e "${GREEN}✅ Symlink aem criado${NC}"
fi

echo ""

# 2️⃣ ATUALIZAR .GITIGNORE
echo -e "${BLUE}2️⃣  Configurando .gitignore...${NC}"

# Backup
cp .gitignore .gitignore.backup

# Adicionar symlinks se não estiverem lá
if ! grep -q "magento2" .gitignore; then
    cat >> .gitignore << 'EOF'

# ═══════════════════════════════════════════════════════════════════════
# Symlinks para repositórios externos
# ═══════════════════════════════════════════════════════════════════════
magento2/
aem/

EOF
    echo -e "${GREEN}✅ Symlinks adicionados ao .gitignore${NC}"
else
    echo -e "${YELLOW}⚠️  Symlinks já estão no .gitignore${NC}"
fi

# Adicionar ignorables comuns
if ! grep -q "node_modules" .gitignore; then
    cat >> .gitignore << 'EOF'

# ═══════════════════════════════════════════════════════════════════════
# Dependencies
# ═══════════════════════════════════════════════════════════════════════
node_modules/
vendor/
composer.lock
package-lock.json

# ═══════════════════════════════════════════════════════════════════════
# Environment
# ═══════════════════════════════════════════════════════════════════════
.env
.env.local
.env.*.local
.DS_Store
*.log

# ═══════════════════════════════════════════════════════════════════════
# IDE
# ═══════════════════════════════════════════════════════════════════════
.vscode/
.idea/
*.swp
*.swo
*~

EOF
    echo -e "${GREEN}✅ Regras de ignore padrão adicionadas${NC}"
else
    echo -e "${YELLOW}⚠️  Regras padrão já estão no .gitignore${NC}"
fi

echo ""

# 3️⃣ CRIAR ESTRUTURA DE REFERÊNCIAS
echo -e "${BLUE}3️⃣  Criando estrutura de referências...${NC}"

mkdir -p referencias/magento-modules
mkdir -p referencias/shopify-theme
mkdir -p referencias/shopify-hydrogen
mkdir -p referencias/aem-config

# Copiar módulos Magento
if [ -d "adobe-commerce/app/code/Bootcamp" ]; then
    cp -r adobe-commerce/app/code/Bootcamp/* referencias/magento-modules/ 2>/dev/null
    echo -e "${GREEN}✅ Módulos Magento copiados${NC}"
else
    echo -e "${YELLOW}⚠️  Diretório adobe-commerce não encontrado${NC}"
fi

# Copiar Shopify
if [ -d "shopify-theme" ]; then
    cp -r shopify-theme/* referencias/shopify-theme/ 2>/dev/null
    echo -e "${GREEN}✅ Tema Shopify copiado${NC}"
else
    echo -e "${YELLOW}⚠️  Diretório shopify-theme não encontrado${NC}"
fi

# Copiar Hydrogen
if [ -d "shopify-hydrogen" ]; then
    cp -r shopify-hydrogen/* referencias/shopify-hydrogen/ 2>/dev/null
    echo -e "${GREEN}✅ Hydrogen copiado${NC}"
else
    echo -e "${YELLOW}⚠️  Diretório shopify-hydrogen não encontrado${NC}"
fi

echo ""

# 4️⃣ INICIALIZAR GIT
echo -e "${BLUE}4️⃣  Inicializando Git...${NC}"

if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Repositório Git já existe${NC}"
else
    git init
    echo -e "${GREEN}✅ Git inicializado${NC}"
fi

# Configurar user (opcional)
if [ -z "$(git config user.email)" ]; then
    echo -e "${YELLOW}ℹ️  Configurando Git user...${NC}"
    git config user.email "dev@bootcamp2026.local"
    git config user.name "Bootcamp 2026"
fi

echo ""

# 5️⃣ CRIAR INSTRUCOES DE INSTALAÇÃO
echo -e "${BLUE}5️⃣  Criando INSTRUCOES-INSTALACAO.md...${NC}"

cat > INSTRUCOES-INSTALACAO.md << 'EOF'
# 🚀 Como Instalar/Clonar o Bootcamp 2026

## 1️⃣ Clone o repositório

```bash
git clone https://seu-repo/bootcamp-2026.git
cd bootcamp-2026
```

## 2️⃣ Setup Magento (WSL)

Os symlinks `./magento2` já apontam para o Magento local.

```bash
cd magento2

# Primeira vez
composer install
php bin/magento setup:install

# Copiar módulos do bootcamp
cp -r ../referencias/magento-modules/Bootcamp app/code/

# Ativar módulos
php bin/magento module:enable Bootcamp_CatalogApi Bootcamp_AemContent
php bin/magento setup:upgrade
php bin/magento cache:flush
```

## 3️⃣ Setup AEM (Docker)

Os symlinks `./aem` já apontam para AEM local.

```bash
cd aem

# Se é primeira vez
docker-compose up -d

# Copiar arquivos de referência
cp -r ../referencias/aem-config/* .
```

## 4️⃣ Setup Shopify

A seção Liquid está em `referencias/shopify-theme/`

```bash
# Adicionar manualmente ao tema no Shopify Admin
# Ou usar Theme CLI: shopify theme pull
```

## 5️⃣ Setup Shopify Hydrogen

```bash
cd referencias/shopify-hydrogen

# Criar novo projeto
npx @shopify/create-hydrogen@latest bootcamp-hydrogen
cd bootcamp-hydrogen

# Ou copiar os arquivos do exemplo
cp ../*.example ./

npm install
npm run dev
```

## 📋 Verificação

```bash
# Ver symlinks
ls -la | grep "magento2\|aem"

# Ver Git status
git status

# Ver estrutura
tree -L 2 -I 'node_modules|vendor'
```

---

**Próximo passo:** Abra [SETUP.md](SETUP.md) e comece o bootcamp!
EOF

echo -e "${GREEN}✅ INSTRUCOES-INSTALACAO.md criado${NC}"

echo ""

# 6️⃣ ADICIONAR AO GIT
echo -e "${BLUE}6️⃣  Adicionando arquivos ao Git...${NC}"

git add .
git status --short | head -20

echo ""
echo -e "${YELLOW}ℹ️  Total de arquivos para commit:${NC}"
git status --short | wc -l

echo ""

# 7️⃣ CRIAR COMMIT
echo -e "${BLUE}7️⃣  Criando primeiro commit...${NC}"

git commit -m "🚀 Bootcamp 2026 - Setup Inicial com Git + Symlinks

ESTRUTURA:
- Documentação completa (README, SETUP, endpoints, arquitetura, checklist)
- 2 Módulos Magento prontos (CatalogApi, AemContent)
- Seção Shopify Liquid com metafields
- 3 Rotas Shopify Hydrogen + componente ProductCard
- Symlinks para Magento e AEM (referências locais)

GIT:
- Symlinks configurados para ../magento2 e ../aem
- .gitignore otimizado (node_modules, vendor, .env)
- Diretório 'referencias/' com cópias dos módulos

PRÓXIMOS PASSOS:
1. Abra SETUP.md para começar Fase 1
2. Faça \`git remote add origin https://seu-repo\`
3. Execute \`git push -u origin main\`

🚀 Pronto para desenvolvimento!"

echo -e "${GREEN}✅ Primeiro commit criado${NC}"

echo ""
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ SETUP GIT CONCLUÍDO!${NC}"
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"

echo ""
echo -e "${BLUE}📊 Status:${NC}"
echo "  ✅ Symlinks: $(ls -la | grep magento2 | awk '{print $NF}')"
echo "  ✅ Git: Inicializado"
echo "  ✅ Primeiro commit: $(git log --oneline | head -1)"
echo ""

echo -e "${BLUE}🚀 Próximas ações:${NC}"
echo ""
echo "1️⃣  Adicionar remote (GitHub/GitLab):"
echo "    git remote add origin https://seu-repo/bootcamp-2026.git"
echo ""
echo "2️⃣  Fazer push:"
echo "    git branch -M main"
echo "    git push -u origin main"
echo ""
echo "3️⃣  Começar bootcamp:"
echo "    cat SETUP.md"
echo ""
echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"

# Verificação final
echo ""
echo -e "${BLUE}📁 Estrutura criada:${NC}"
tree -L 2 -I 'node_modules|vendor|.git' 2>/dev/null || find . -maxdepth 2 -type d -not -path '*/\.*' | head -20

echo ""
echo -e "${GREEN}✨ Tudo pronto! Bom desenvolvimento! ✨${NC}"
