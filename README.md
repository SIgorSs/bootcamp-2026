# 🚀 Bootcamp 2026: Integração Adobe Commerce + AEM + Shopify

## 📋 Visão Geral

Projeto de integração de 3 plataformas de e-commerce e gerenciamento de conteúdo:

- **Adobe Commerce (Magento 2)** — Catálogo de produtos via REST API
- **AEM (Adobe Experience Manager)** — Gerenciamento de conteúdo via GraphQL
- **Shopify** — Loja headless com Hydrogen (React/Vite)

O **AEM é o "cérebro de conteúdo"** que alimenta Commerce e Shopify. Commerce gerencia catálogo e vendas. Shopify oferece uma experiência headless com Hydrogen.

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────┐
│                     AEM Content                          │
│              (Content Fragments + GraphQL)               │
└──────────────┬────────────────┬──────────────────────────┘
               │                │
       ┌───────▼────────┐  ┌────▼──────────┐
       │ Adobe Commerce │  │ Shopify Store │
       │  REST API      │  │ Liquid + JS   │
       │  /V1/bootcamp  │  │               │
       └────────┬───────┘  └────┬──────────┘
                │               │
         ┌──────▼───────────────▼──────┐
         │   Shopify Hydrogen App      │
         │  (React/Vite Headless)      │
         │  - Homepage (Destaques)     │
         │  - Product Page             │
         │  - About (Conteúdo AEM)     │
         └────────────────────────────┘
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
├── 📄 README.md                       ← Você está aqui
├── 📄 SETUP.md                        ← Guia passo a passo
├── 📁 docs/
│   ├── endpoints.md                   ← API Reference
│   ├── arquitetura.md                 ← Diagramas e fluxos
│   └── checklist.md                   ← Tarefas por dia
│
├── 📁 adobe-commerce/
│   └── app/code/Bootcamp/
│       ├── CatalogApi/                ← REST API (✅ Pronto)
│       └── AemContent/                ← Banner integrado (✅ Pronto)
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
│   └── pom.xml                        ← Maven config
│
├── 📁 shopify-theme/
│   ├── assets/bootcamp-products.css    ← Estilos BEM
│   └── sections/bootcamp-products.liquid ← Seção customizada
│
└── 📁 shopify-hydrogen/
    ├── app/
    │   ├── routes/
    │   │   ├── _index.jsx              ← Homepage
    │   │   └── about.jsx               ← About (conteúdo AEM)
    │   ├── components/
    │   │   └── ProductCard.jsx         ← Card de produto
    │   └── styles/
    │       └── bootcamp.css            ← CSS global
    ├── .env.example                    ← Template de variáveis
    └── README.md
```

---

## 🚀 Quick Start

### 1. Adobe Commerce - CatalogApi

```bash
# Entrar no diretório Commerce
cd /home/igors/magento2

# Ativar módulos
php bin/magento module:enable Bootcamp_CatalogApi Bootcamp_AemContent
php bin/magento setup:upgrade
php bin/magento cache:flush

# Testar API
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq
# Esperado: JSON com 5 produtos
```

### 2. AEM - ProductShowcase Component

```bash
# Build e deploy do componente
cd /home/igors/projects/bootcamp-2026/aem-wknd

mvn clean install -PautoInstallSinglePackage

# Ou deploy manual
mvn clean install -pl ui.apps
mvn clean install -pl core
```

### 3. Shopify Hydrogen - Homepage

```bash
# Setup
cd /home/igors/projects/bootcamp-2026/shopify-hydrogen

# Copiar .env.example e configurar
cp .env.example .env

# Editar .env com credenciais Shopify
nano .env

# Install e dev
npm install
npm run dev

# Acessar: http://localhost:3000
```

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
