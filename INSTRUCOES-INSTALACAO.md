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
