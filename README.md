# 🚀 Bootcamp 2026: Integração Adobe Commerce + AEM + Shopify

Documentação consolidada do projeto de integração de 3 plataformas: Adobe Commerce, AEM (Adobe Experience Manager) e Shopify com Hydrogen.

## 📋 Visão Geral

- **Adobe Commerce (Magento 2)** — Catálogo de produtos via REST API
- **AEM (Adobe Experience Manager)** — Gerenciamento de conteúdo via GraphQL
- **Shopify** — Loja headless com Hydrogen (React/Vite)

**O AEM é o "cérebro de conteúdo"** que alimenta Commerce e Shopify. Commerce gerencia catálogo e vendas. Shopify oferece uma experiência headless com Hydrogen.

---

## 🏗️ Arquitetura Completa

```
┌──────────────────────────────────────────────────────────────────┐
│                      BOOTCAMP 2026 ARCHITECTURE                  │
└──────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│                    🧠 AEM — CONTENT BRAIN                           │
│                 http://localhost:4502                               │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Content Fragments (Produtos Destaque)                       │   │
│  │ Experience Fragments (Banners + Promos)                    │   │
│  │ GraphQL Queries (Persisted + Dynamic)                      │   │
│  │ DAM Assets (Imagens dos Produtos)                          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  GraphQL Endpoints:                                                 │
│  ├─ POST /content/graphql/global  ← Queries diretas                │
│  └─ GET  /graphql/execute.json/wknd/bootcamp-products ← Persisted │
│                                                                     │
└──────────────┬──────────────────────────────┬───────────────────────┘
               │                              │
    ┌──────────▼──────────┐        ┌──────────▼──────────┐
    │   ADOBE COMMERCE    │        │    SHOPIFY STORE    │
    │  (Catálogo + Vendas)│        │ (Liquid + Metafields)
    │  https://app.       │        │ https://seu-store.  │
    │  magento2.test      │        │ myshopify.com       │
    │                     │        │                     │
    │ REST API            │        │ Storefront API      │
    │ /V1/bootcamp/       │        │ + Admin API         │
    │ products            │        │ (for Metafields)    │
    │                     │        │                     │
    │ Módulos:            │        │ Seções Liquid:      │
    │ • CatalogApi ✅     │        │ • bootcamp-products │
    │ • AemContent ✅     │        │ • Product cards     │
    │                     │        │                     │
    └──────────┬──────────┘        └──────────┬──────────┘
               │                              │
               └──────────────┬───────────────┘
                              │
                    ┌─────────▼─────────┐
                    │  SHOPIFY HYDROGEN │
                    │ (React/Vite App)  │
                    │  localhost:3000   │
                    │                   │
                    │ Routes:           │
                    │ • / (Homepage)    │
                    │ • /products/$h    │
                    │ • /about (AEM)    │
                    │                   │
                    └───────────────────┘
```

**Fluxos de Dados:**
1. **AEM → Commerce**: Experience Fragments alimentam banners da homepage
2. **AEM → Hydrogen**: Content Fragments com produtos em destaque
3. **Commerce → Hydrogen**: API REST fornece catálogo completo
4. **Shopify → Hydrogen**: Storefront API com metafields customizados

---

## 📅 Timeline (7 dias)

| Dia | Fase | O quê |
|-----|------|-------|
| 11-14 | **1** | Adobe Commerce: Atributos, Categorias, Produtos, Módulo CatalogApi |
| 12 | **2** | AEM: Content Fragment Model, Imagens, Queries GraphQL, Persisted Query |
| 13 | **4** | Shopify: Metafields, Produtos, Liquid Section customizada |
| 15 | **3** | AEM: Componente ProductShowcase integrado com Commerce |
| 16 | **5** | Shopify Hydrogen: Homepage, Product Page, Estilos |
| 17 | **6** | Integração completa: AEM em Hydrogen + Commerce em AEM |

---

## 🛠️ Pré-requisitos

### Instalado Localmente
- **Node.js 18+** — Para Shopify Hydrogen
- **Java 17+** — Para AEM
- **Maven 3.8+** — Build do AEM
- **Git** — Controle de versão

### Rodando Localmente
- **Adobe Commerce** — `https://app.magento2.test`
- **AEM Author** — `http://localhost:4502`
- **Shopify** — Conta de teste (necessário criar)

### Credenciais Padrão
```
Adobe Commerce: admin / admin
AEM Author: admin / admin
Shopify: Obter tokens na dashboard
```

---

## 📂 Estrutura do Projeto

```
bootcamp-2026/
├── 📄 README.md                       ← Documentação completa
│
├── 📁 adobe-commerce/
│   └── app/code/Bootcamp/
│       ├── CatalogApi/                ← REST API (✅ Pronto)
│       │   ├── registration.php
│       │   ├── etc/
│       │   │   ├── module.xml
│       │   │   ├── di.xml
│       │   │   └── webapi.xml
│       │   ├── Api/ProductListInterface.php
│       │   └── Model/ProductList.php
│       └── AemContent/                ← Banner integrado (✅ Pronto)
│           ├── registration.php
│           ├── etc/
│           │   ├── module.xml
│           │   └── di.xml
│           ├── Block/AemBanner.php
│           └── templates/aem-banner.phtml
│
├── 📁 aem-wknd/
│   ├── core/
│   │   └── src/main/java/com/adobe/wknd/core/models/
│   │       ├── ProductShowcase.java       ← Interface
│   │       └── ProductShowcaseImpl.java    ← Sling Model
│   ├── ui.apps/
│   │   └── src/main/content/jcr_root/apps/wknd/components/productshowcase/
│   │       ├── .content.xml              ← Metadados
│   │       ├── productshowcase.html      ← Template HTL
│   │       └── _cq_dialog/.content.xml   ← Dialog
│   └── pom.xml
│
├── 📁 shopify-theme/
│   ├── assets/bootcamp-products.css
│   └── sections/bootcamp-products.liquid
│
└── 📁 shopify-hydrogen/
    ├── app/
    │   ├── routes/
    │   │   ├── _index.jsx              ← Homepage
    │   │   ├── products.$handle.jsx    ← Product Page
    │   │   └── about.jsx               ← About (AEM)
    │   ├── components/ProductCard.jsx
    │   └── styles/bootcamp.css
    ├── .env.example
    └── package.json
```

---

## 🔌 APIs & Endpoints

### Adobe Commerce REST API

**Base URL:**
```
https://app.magento2.test/rest/V1/
```

**Endpoint: GET /bootcamp/products**

Retorna 5 produtos com atributos customizados.

```bash
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq
```

**Response (200 OK):**
```json
{
  "items": [
    {
      "id": 1,
      "sku": "BOOT-CAM-001",
      "name": "Camiseta Bootcamp 2026",
      "type": "configurable",
      "price": 89.90,
      "currency": "BRL",
      "bootcamp_highlight": true,
      "tech_stack": "React",
      "image_url": "https://app.magento2.test/media/catalog/product/b/o/boot-cam-001.jpg",
      "description": "Camiseta oficial do Bootcamp",
      "status": 1,
      "visibility": 4
    },
    {
      "id": 2,
      "sku": "BOOT-CAN-002",
      "name": "Caneca Developer",
      "type": "simple",
      "price": 45.00,
      "currency": "BRL",
      "bootcamp_highlight": true,
      "tech_stack": "JavaScript",
      "image_url": "https://app.magento2.test/media/catalog/product/b/o/boot-can-002.jpg"
    },
    {
      "id": 3,
      "sku": "BOOT-MOC-003",
      "name": "Mochila Tech",
      "type": "simple",
      "price": 199.90,
      "currency": "BRL",
      "bootcamp_highlight": false,
      "tech_stack": "Java",
      "image_url": "https://app.magento2.test/media/catalog/product/b/o/boot-moc-003.jpg"
    },
    {
      "id": 4,
      "sku": "BOOT-KIT-004",
      "name": "Kit Adesivos Dev",
      "type": "grouped",
      "price": 29.90,
      "currency": "BRL",
      "bootcamp_highlight": true,
      "tech_stack": "PHP",
      "image_url": "https://app.magento2.test/media/catalog/product/b/o/boot-kit-004.jpg"
    },
    {
      "id": 5,
      "sku": "BOOT-CUR-005",
      "name": "Curso Online Adobe Commerce",
      "type": "virtual",
      "price": null,
      "currency": "BRL",
      "bootcamp_highlight": true,
      "tech_stack": "Liquid",
      "image_url": "https://app.magento2.test/media/catalog/product/b/o/boot-cur-005.jpg"
    }
  ]
}
```

### AEM GraphQL API

**Base URL:**
```
http://localhost:4502/content/graphql/global
```

**Query: Listar todos os Produtos**
```graphql
{
  produtoDestaqueList {
    items {
      titulo
      preco
      categoria
      stackTecnologico
      destaque
      descricao {
        plaintext
      }
    }
  }
}
```

**Query: Filtrar apenas Destaques**
```graphql
{
  produtoDestaqueList(filter: {
    destaque: {
      _expressions: [{value: true}]
    }
  }) {
    items {
      titulo
      preco
      categoria
    }
  }
}
```

**Persisted Query:**
```bash
curl -X PUT 'http://localhost:4502/graphql/persist.json/wknd/bootcamp-products' \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{"query": "{ produtoDestaqueList { items { titulo preco categoria stackTecnologico destaque descricao { plaintext } } } }"}'
```

Execute persisted query:
```
GET http://localhost:4502/content/graphql/execute.json/wknd/bootcamp-products
```

### Shopify Storefront API

**Base URL:**
```
https://seu-store.myshopify.com/api/graphql.json
```

**Header:**
```
X-Shopify-Storefront-Access-Token: <seu-token>
```

**Query: Coleção com Produtos e Metafields**
```graphql
{
  collection(handle: "destaques") {
    title
    products(first: 10) {
      edges {
        node {
          id
          title
          handle
          priceRange {
            minVariantPrice {
              amount
              currencyCode
            }
          }
          metafields(identifiers: [
            {namespace: "custom", key: "tech_stack"},
            {namespace: "custom", key: "highlight_badge"},
            {namespace: "custom", key: "bootcamp_year"}
          ]) {
            namespace
            key
            value
          }
        }
      }
    }
  }
}
```

---

## 🚀 Quick Start com Scripts Automáticos

### ⚡ Executar Tudo Automaticamente

Os scripts estão em `scripts/` e criam todos os dados automaticamente:

```bash
cd /home/igors/projects/bootcamp-2026/scripts
```

---

### 1️⃣ Adobe Commerce - setup_commerce.sh

```bash
# Dar permissão
chmod +x setup_commerce.sh

# Executar (cria atributos, categorias e 5 produtos)
./setup_commerce.sh
```

**O que cria:**
- ✅ Atributo `bootcamp_highlight` (Yes/No)
- ✅ Atributo `tech_stack` (Dropdown)
- ✅ 4 Categorias
- ✅ 5 Produtos BOOT-*

**Testar:**
```bash
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq
```

---

### 2️⃣ AEM - setup_aem.py

```bash
# Instalar dependência
pip install requests

# Executar (cria Content Fragments)
python3 setup_aem.py
```

**O que cria:**
- ✅ Pasta DAM `/content/dam/wknd/bootcamp/produtos`
- ✅ 5 Content Fragments
- ✅ Testa GraphQL

**⚠️ Ação manual:**
1. Acesse: http://localhost:4502/libs/dam/gui/content/cfm/admin.html
2. Clique em "Enable" no modelo "Produto Destaque"

**Testar:**
```bash
curl -X POST http://localhost:4502/content/graphql/global \
  -u admin:admin -H 'Content-Type: application/json' \
  -d '{"query": "{ produtoDestaqueList { items { titulo } } }"}'
```

---

## 3️⃣ Shopify - setup_shopify.js

⚠️ **IMPORTANTE 2026:** Shopify mudou autenticação em janeiro/2026. Use nosso Wizard interativo:

### **🪄 OPÇÃO RECOMENDADA: Token Wizard** ⚡

```bash
cd /home/igors/projects/bootcamp-2026/scripts

chmod +x shopify-token-wizard.sh
./shopify-token-wizard.sh
```

O wizard vai:
1. ✅ Detectar sua situação (app já criada ou não)
2. ✅ Guiar você interativamente
3. ✅ Gerar token automaticamente (3 métodos diferentes)
4. ✅ Configurar setup_shopify.js automaticamente
5. ✅ Pronto para executar!

### **Opções do Wizard:**
- **Opção 1:** Já criei a app → Inserir Client ID + Secret
- **Opção 2:** Primeira vez → Criar app + gerar token (abre admin)
- **Opção 3:** Automático → Usa Shopify CLI (sem clicar)

### **📖 Documentação Completa**

Se preferir fazer manualmente ou tem dúvidas:
- [scripts/SHOPIFY-TOKEN-GUIDE.md](scripts/SHOPIFY-TOKEN-GUIDE.md) - Guia com 2 opções

### **🚀 Depois: Executar Setup Shopify**

```bash
cd /home/igors/projects/bootcamp-2026/scripts

# Token já foi configurado pelo wizard
node setup_shopify.js
```

**O que cria:**
- ✅ 5 Produtos com metafields
- ✅ 4 Coleções
- ✅ Metafield Definitions

---

### 4️⃣ Shopify Hydrogen - App React/Vite

```bash
# Setup
cd /home/igors/projects/bootcamp-2026/shopify-hydrogen

# Copiar .env.example
cp .env.example .env

# Editar com tokens Shopify
nano .env

# Instalar e rodar
npm install
npm run dev

# Acessar: http://localhost:3000
```

---

### 📋 Ordem Recomendada

```
1. ./setup_commerce.sh      (5 min - Commerce)
2. python3 setup_aem.py     (3 min - AEM)
3. node setup_shopify.js    (2 min - Shopify)
```

**Tempo total:** ~10 minutos ⚡

---

### 📖 Documentação Completa dos Scripts

Ver: [scripts/SETUP-GUIDE.md](scripts/SETUP-GUIDE.md)

---

## 📝 Fluxo de Integração

### Cenário: Exibir Produtos em Destaque no Hydrogen

```
┌────────────────────────────┐
│ 1. AEM Content Fragment    │
│    - Titulo: "Camiseta..." │
│    - Destaque: true        │
│    - Publicar              │
└────────────────┬───────────┘
                 │
                 ▼
┌────────────────────────────┐
│ 2. GraphQL Query (AEM)     │
│ POST /content/graphql/     │
│ Filter: destaque = true    │
└────────────────┬───────────┘
                 │
                 ▼
┌────────────────────────────┐
│ 3. Hydrogen /about.jsx     │
│ - Loader fetches AEM       │
│ - Basic Auth: admin:admin  │
│ - Fallback se offline      │
└────────────────┬───────────┘
                 │
                 ▼
┌────────────────────────────┐
│ 4. Browser                 │
│ http://localhost:3000/about│
│ Produtos renderizados ✅   │
└────────────────────────────┘
```

### Cenário: Mostrar Preços do Commerce no Hydrogen

```
┌────────────────────────────┐
│ 1. Commerce API            │
│ GET /V1/bootcamp/products  │
│ Retorna: SKU, Preço, etc   │
└────────────────┬───────────┘
                 │
                 ▼
┌────────────────────────────┐
│ 2. Hydrogen Homepage       │
│ app/routes/_index.jsx      │
│ Loader fetches Commerce    │
└────────────────┬───────────┘
                 │
                 ▼
┌────────────────────────────┐
│ 3. ProductCard Component   │
│ - Title                    │
│ - Price (R$)               │
│ - Tech Stack Badge         │
│ - Highlight Badge          │
└────────────────┬───────────┘
                 │
                 ▼
┌────────────────────────────┐
│ 4. Browser                 │
│ http://localhost:3000/     │
│ Produtos exibidos ✅       │
└────────────────────────────┘
```

---

## 🔌 APIs de Referência

### Commerce REST API
```bash
GET https://app.magento2.test/rest/V1/bootcamp/products

Response:
{
  "items": [
    {
      "sku": "BOOT-CAM-001",
      "name": "Camiseta Bootcamp 2026",
      "price": 89.90,
      "bootcamp_highlight": true,
      "tech_stack": "React",
      "image_url": "..."
    }
  ]
}
```

### AEM GraphQL
```bash
POST http://localhost:4502/content/graphql/global
Authorization: Basic admin:admin

Body:
{
  "query": "{ produtoDestaqueList { items { titulo preco destaque } } }"
}
```

### Shopify Storefront API
```bash
POST https://seu-store.myshopify.com/api/2024-01/graphql.json
X-Shopify-Storefront-Access-Token: seu-token

Body:
{
  "query": "{ collectionByHandle(handle: \"destaques\") { ... } }"
}
```

---

## 📋 Checklist de Desenvolvimento

### Fase 1: Adobe Commerce (Dias 11-14)
- [x] Criar atributos customizados
- [x] Criar categorias
- [x] Criar 5 produtos
- [x] Módulo CatalogApi
- [x] Testar API REST

### Fase 2: AEM (Dia 12)
- [x] Content Fragment Model
- [x] Upload de imagens
- [x] Criar Content Fragments
- [x] Queries GraphQL
- [x] Persisted Query

### Fase 3: Integração AEM + Commerce (Dia 15)
- [x] Componente ProductShowcase
- [x] Sling Model
- [x] HTL Template
- [x] Deploy

### Fase 4: Shopify Liquid (Dia 13)
- [ ] Metafield Definitions
- [ ] Criar 5 produtos
- [ ] Coleções
- [ ] Seção bootcamp-products.liquid

### Fase 5: Shopify Hydrogen (Dia 16)
- [x] Homepage
- [x] Product Page
- [x] About (AEM integration)
- [x] Estilos

### Fase 6: Integração Final (Dia 17)
- [ ] AEM Content no Hydrogen
- [ ] AEM Banner no Commerce
- [ ] Experience Fragments
- [ ] Teste completo
# URL: https://app.magento2.test/admin

# Criar módulos:
cp -r /home/igors/projects/bootcamp-2026/adobe-commerce/app/code/Bootcamp app/code/

# Ativar módulos
php bin/magento module:enable Bootcamp_CatalogApi
php bin/magento setup:upgrade
php bin/magento cache:flush

# Testar API
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq
```

### 3. AEM WKND (Fase 2)

```bash
# Acessar AEM local
open http://localhost:4502

# Criar Content Fragment Model
# Tools > Assets > Content Fragment Models > Produto Destaque

# Fazer upload de imagens
# DAM > WKND > Bootcamp > Produtos

# Criar Content Fragments e publicar

# Testar GraphQL
open http://localhost:4502/content/graphql/global
```

### 4. Shopify (Fase 4)

```bash
# Criar loja de teste em https://www.shopify.com/

# Criar metafield definitions via Admin API

# Criar 5 produtos com metafields

# Criar 4 coleções manuais

# Criar tema customizado com bootcamp-products.liquid
```

### 5. Shopify Hydrogen (Fase 5)

```bash
cd /home/igors/projects/bootcamp-2026/shopify-hydrogen

# Copiar projeto Hydrogen completo (será feito em etapa 5.1)
npx @shopify/create-hydrogen@latest bootcamp-hydrogen

# Configurar .env
cp .env.example .env
# Editar com seus tokens

# Rodar localmente
npm run dev

# Acessar: http://localhost:3000
```

---

## 📁 Estrutura do Projeto

```
bootcamp-2026/
├── README.md                              ← Este arquivo
├── docs/
│   ├── endpoints.md                       ← URLs, tokens, exemplos
│   ├── arquitetura.md                     ← Diagramas e fluxos
│   └── checklist.md                       ← Checklist dos 7 dias
│
├── adobe-commerce/
│   └── app/code/Bootcamp/
│       ├── CatalogApi/
│       │   ├── registration.php
│       │   ├── etc/
│       │   │   ├── module.xml
│       │   │   ├── di.xml
│       │   │   └── webapi.xml
│       │   ├── Api/ProductListInterface.php
│       │   └── Model/ProductList.php
│       │
│       └── AemContent/
│           ├── registration.php
│           ├── etc/
│           │   ├── module.xml
│           │   └── di.xml
│           ├── Block/AemBanner.php
│           └── templates/aem-banner.phtml
│
├── aem-wknd/
│   ├── core/
│   │   └── src/main/java/com/example/core/models/
│   │       ├── ProductShowcase.java
│   │       └── ProductShowcaseImpl.java
│   └── ui.apps/
│       └── src/main/content/jcr_root/apps/wknd/components/
│           └── productshowcase/
│               ├── .content.xml
│               ├── _cq_dialog/.content.xml
│               └── productshowcase.html
│
├── shopify-theme/
│   ├── sections/
│   │   └── bootcamp-products.liquid      ← Seção customizada
│   └── assets/
│       └── bootcamp-products.css         ← Estilos BEM
│
└── shopify-hydrogen/
    └── bootcamp-hydrogen/
        ├── app/
        │   ├── routes/
        │   │   ├── _index.jsx             ← Homepage (destaques)
        │   │   ├── products.$handle.jsx   ← Página de produto
        │   │   ├── about.jsx              ← Conteúdo AEM
        │   │   └── root.jsx               ← Layout principal
        │   └── styles/
        │       └── bootcamp.css           ← Variáveis CSS
        ├── .env.example
        └── package.json
```

---

## 📖 Documentação Adicional

- [📊 Endpoints.md](docs/endpoints.md) — URLs, métodos, exemplos de request/response
- [🏗️ Arquitetura.md](docs/arquitetura.md) — Diagramas de fluxos detalhados
- [✅ Checklist.md](docs/checklist.md) — Checklist completo dos 7 dias

---

## 🧪 Testando Tudo

### Commerce API
```bash
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq
```

### AEM GraphQL
```bash
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -d '{ "query": "{ produtoDestaqueList { items { titulo } } }" }'
```

### Shopify Storefront API
```bash
curl -X POST https://seu-store.myshopify.com/api/graphql.json \
  -H 'X-Shopify-Storefront-Access-Token: seu-token' \
  -d '{ "query": "{ products(first: 5) { edges { node { title } } } }" }'
```

### Hydrogen (Local)
```bash
cd shopify-hydrogen/bootcamp-hydrogen
npm run dev
# Acesse: http://localhost:3000
```

---

## 🐛 Troubleshooting

| Problema | Solução |
|----------|---------|
| Commerce API retorna 404 | Verificar se módulo está ativado: `php bin/magento module:status` |
| AEM GraphQL retorna erro de autenticação | Usar Basic Auth: `Authorization: Basic <base64(admin:admin)>` |
| Hydrogen não conecta com Shopify | Verificar `.env` com tokens corretos e domínio da loja |
| CORS errors no Hydrogen | Configurar headers CORS no Commerce/AEM |

---

## 📚 Recursos Oficiais

- [Magento 2 API Docs](https://devdocs.magento.com/api-reference/)
- [AEM as a Cloud Service](https://experienceleague.adobe.com/docs/experience-manager-cloud-service/home)
- [Shopify Storefront API](https://shopify.dev/api/storefront)
- [Hydrogen Framework](https://hydrogen.shopify.dev/)

---

## 👥 Contato / Suporte

Para dúvidas sobre o projeto, consulte:
- 📊 [endpoints.md](docs/endpoints.md) para exemplos práticos
- ✅ [checklist.md](docs/checklist.md) para status do desenvolvimento
- 🏗️ [arquitetura.md](docs/arquitetura.md) para entender fluxos

---

**Última atualização:** Abril 2026  
**Bootcamp:** Adobe Commerce + AEM + Shopify Integration  
**Status:** 🟢 Pronto para começar Fase 1
