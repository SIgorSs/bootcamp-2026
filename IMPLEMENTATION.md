# 📋 IMPLEMENTATION GUIDE - Bootcamp 2026

Guia prático passo a passo para implementar o projeto completo.

---

## ✅ O QUE JÁ FOI FEITO

### Adobe Commerce
- ✅ Módulo `Bootcamp_CatalogApi` criado
- ✅ Módulo `Bootcamp_AemContent` criado  
- ✅ Arquivos de configuração (di.xml, webapi.xml, module.xml)
- ✅ Interfaces e Models prontos

### AEM WKND
- ✅ Componente `ProductShowcase` criado
- ✅ Sling Models (Interface + Implementation)
- ✅ Dialog e HTL template
- ✅ pom.xml configurado

### Shopify Hydrogen
- ✅ Rotas criadas (_index.jsx, about.jsx)
- ✅ Componente ProductCard
- ✅ Estilos CSS (bootcamp.css)
- ✅ .env.example criado

### Documentação
- ✅ endpoints.md com referência completa
- ✅ arquitetura.md com diagramas
- ✅ README.md atualizado

---

## 🔧 O QUE FALTA FAZER

### Fase 1: Adobe Commerce (Admin UI - Manual)
1. **Criar Atributos** → Admin → Stores > Attributes
   - `bootcamp_highlight` (Yes/No)
   - `tech_stack` (Dropdown)

2. **Criar Categorias** → Admin → Catalog > Categories
   - Vestuário > Camisetas
   - Acessórios > Canecas / Mochilas
   - Papelaria > Adesivos
   - Digital > Cursos

3. **Criar 5 Produtos** → Admin → Catalog > Products
   - BOOT-CAM-001: Camiseta
   - BOOT-CAN-002: Caneca
   - BOOT-MOC-003: Mochila
   - BOOT-KIT-004: Kit Adesivos
   - BOOT-CUR-005: Curso Online

### Fase 2: AEM (Admin UI - Manual)
1. **Content Fragment Model** → Tools > Assets > Content Fragment Models
   - Título: "Produto Destaque"
   - Campos: titulo, descricao, preco, imagem, categoria, stackTecnologico, destaque, linkExterno

2. **Upload Imagens** → Assets > Files > WKND > Bootcamp > Produtos

3. **Criar Content Fragments** (5)
   - Preencher todos os campos
   - Publicar cada um

### Fase 4: Shopify (Admin UI - Manual)
1. **Metafield Definitions** → Settings > Custom Data
   - custom.tech_stack
   - custom.highlight_badge
   - custom.bootcamp_year

2. **Criar 5 Produtos** com variantes e metafields

3. **Criar 4 Coleções**
   - Destaques
   - Vestuário
   - Acessórios
   - Digital

### Fase 5: Shopify Hydrogen (Local - Automatizado)
```bash
cd shopify-hydrogen

# Setup
cp .env.example .env
# Editar .env com credenciais

# Install
npm install

# Start
npm run dev

# Acessar: http://localhost:3000
```

---

## 🚀 PASSO A PASSO DE EXECUÇÃO

### PASSO 1: Ativar Módulos do Commerce

```bash
cd /home/igors/magento2

# Ativar módulos
php bin/magento module:enable Bootcamp_CatalogApi Bootcamp_AemContent

# Setup
php bin/magento setup:upgrade

# Cache
php bin/magento cache:flush

# Verificar
php bin/magento module:status | grep Bootcamp
# Esperado: Bootcamp_CatalogApi, Bootcamp_AemContent (both enabled)
```

**Status:** ⏳ Aguarda configuração no Admin (Fase 1)

---

### PASSO 2: Deploy do AEM Component

```bash
cd /home/igors/projects/bootcamp-2026/aem-wknd

# Build completo
mvn clean install -PautoInstallSinglePackage

# Ou deploy individual
mvn clean install -pl ui.apps     # Frontend component
mvn clean install -pl core        # Sling Models

# Verificar em AEM
# Acessar: http://localhost:4502/crx/packmgr
# Procurar por "WKND" e "ProductShowcase"
```

**Status:** ⏳ Aguarda criação de Content Fragments (Fase 2)

---

### PASSO 3: Configurar Shopify Hydrogen

```bash
# Setup local
cd /home/igors/projects/bootcamp-2026/shopify-hydrogen

# Copiar template
cp .env.example .env

# Editar com credenciais Shopify
cat > .env << 'EOF'
PUBLIC_STOREFRONT_API_TOKEN=seu_token_aqui
PUBLIC_STORE_DOMAIN=sua-loja.myshopify.com
SESSION_SECRET=bootcamp-secret-key-2026
PRIVATE_AEM_AUTHOR_URL=http://localhost:4502
PRIVATE_AEM_USERNAME=admin
PRIVATE_AEM_PASSWORD=admin
PRIVATE_COMMERCE_API_URL=https://app.magento2.test/rest/V1
ENV=development
EOF

# Install dependencies
npm install

# Start development server
npm run dev

# Acessar
open http://localhost:3000
```

**Status:** ⏳ Aguarda configuração de Shopify e AEM

---

### PASSO 4: Testar Integrações

#### 4.1: Testar Commerce API

```bash
# Request
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq

# Expected Response
{
  "items": [
    {
      "sku": "BOOT-CAM-001",
      "name": "Camiseta Bootcamp 2026",
      "price": 89.90,
      "bootcamp_highlight": true,
      "tech_stack": "React"
    },
    ...
  ],
  "total_count": 5
}

# Status: ✅ Se 5 produtos retornam
# Status: ❌ Se módulo não está ativo (execute PASSO 1)
```

#### 4.2: Testar AEM GraphQL

```bash
# Request
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{"query": "{ produtoDestaqueList { items { titulo preco } } }"}'

# Expected Response
{
  "data": {
    "produtoDestaqueList": {
      "items": [
        {
          "titulo": "Camiseta...",
          "preco": 89.9
        },
        ...
      ]
    }
  }
}

# Status: ✅ Se Content Fragments existem
# Status: ⏳ Se lista vazia (crie Content Fragments via Admin)
```

#### 4.3: Testar Hydrogen

```bash
# Em http://localhost:3000

# Página 1: Home
# ✅ Deve exibir hero section e produtos em destaque

# Página 2: /about
# ✅ Deve exibir conteúdo do AEM ou fallback

# Se erros, verificar:
# - .env está preenchido?
# - AEM está online?
# - Content Fragments existem?
# - npm start rodando?
```

---

## 📊 MATRIZ DE DEPENDÊNCIAS

```
┌─────────────────────────────────────────────────────────────┐
│                  BOOTCAMP 2026 DEPENDENCIES                 │
└─────────────────────────────────────────────────────────────┘

AEM Content Fragments
    ├── Hydrogen /about.jsx ← GraphQL Query
    │   ├── REST call to AEM
    │   ├── Parse JSON
    │   └── Fallback if offline
    │
    └── Commerce AemBanner ← Experience Fragment
        ├── Curl GET master.json
        ├── Cache (1h TTL)
        └── Fallback if timeout

Commerce REST API
    ├── Hydrogen /_index.jsx ← GET /V1/bootcamp/products
    │   ├── Fetch all products
    │   ├── Map to ProductCard
    │   └── Display with badges
    │
    └── AEM ProductShowcase ← HTTP GET (Sling Model)
        ├── Parse products
        ├── Filter by highlight
        └── Render in HTL

Shopify Storefront API
    └── Hydrogen /products/$handle ← Storefront API Query
        ├── Fetch product + variants
        ├── Extract metafields
        └── Display with badges
```

---

## 🐛 TROUBLESHOOTING

### Problema: Commerce API retorna 404
**Solução:**
```bash
# Verificar módulo ativado
php bin/magento module:status | grep Bootcamp

# Se não aparecer, ativar
php bin/magento module:enable Bootcamp_CatalogApi

# Setup e cache
php bin/magento setup:upgrade
php bin/magento cache:flush

# Recarregar admin
```

### Problema: AEM GraphQL retorna erro
**Solução:**
```bash
# Verificar autorização
# Authorization header deve ser: Basic admin:admin (base64)

# Testar com curl
curl -u admin:admin http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -d '{"query": "{ produtoDestaqueList { items { titulo } } }"}'

# Se erro 401, trocar credenciais
# Se erro 500, verificar Content Fragment Model foi criado
```

### Problema: Hydrogen não conecta com AEM
**Solução:**
```bash
# Verificar .env
cat shopify-hydrogen/.env

# Deve ter:
PRIVATE_AEM_AUTHOR_URL=http://localhost:4502
PRIVATE_AEM_USERNAME=admin
PRIVATE_AEM_PASSWORD=admin

# Reinicar app
npm run dev

# Verificar logs para erros de conexão
```

---

## 📝 PRÓXIMOS PASSOS

1. **Fase 1**: Executar PASSO 1 (ativar módulos Commerce)
2. **Fase 2**: Usar Admin UI para criar atributos, categorias, produtos
3. **Fase 4**: Usar Admin UI do Shopify para metafields e produtos
4. **Fase 2**: Usar Admin AEM para Content Fragments
5. **Fase 5**: Executar PASSO 3 (Hydrogen local)
6. **Fase 4**: Executar PASSO 4 (testes)
7. **Commit**: `git add . && git commit -m "feat: Configuration and manual setup completed"`

---

## 📚 REFERÊNCIAS

- [docs/endpoints.md](docs/endpoints.md) — API Reference
- [docs/arquitetura.md](docs/arquitetura.md) — Architecture Diagrams
- [docs/checklist.md](docs/checklist.md) — Detailed Checklist
- [adobe-commerce/app/code/Bootcamp/CatalogApi/](adobe-commerce/app/code/Bootcamp/CatalogApi/) — Commerce Module
- [aem-wknd/core/](aem-wknd/core/) — AEM Sling Models
- [shopify-hydrogen/app/](shopify-hydrogen/app/) — Hydrogen Routes

**Status Geral:** 🟡 60% completo (código pronto, setup pendente)
