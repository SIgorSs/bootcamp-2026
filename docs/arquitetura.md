# 🏗️ Arquitetura Bootcamp 2026

Diagramas e fluxos detalhados da integração entre as 3 plataformas.

---

## 1️⃣ Visão Geral (Diagrama Principal)

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

---

## 2️⃣ Fluxo de Dados: Commerce → Hydrogen

```
┌─────────────────────────────────────────────────────────────┐
│  Adobe Commerce (REST API)                                  │
│  GET /V1/bootcamp/products                                  │
└──────────────────────┬──────────────────────────────────────┘
                       │
              Returns JSON:
              {
                "items": [
                  {
                    "sku": "BOOT-CAM-001",
                    "name": "Camiseta...",
                    "price": 89.90,
                    "bootcamp_highlight": true,
                    "tech_stack": "React",
                    "image_url": "..."
                  },
                  ...
                ]
              }
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  Shopify Hydrogen                                           │
│  app/routes/_index.jsx                                      │
│                                                              │
│  1. Loader fetches via Commerce REST                        │
│  2. Maps to Hydrogen ProductCard component                  │
│  3. Renders: Image, Price, TechStack badge                 │
│  4. Link para /products/$sku                                │
└─────────────────────────────────────────────────────────────┘

Timeline: ~500ms (Cache Commerce API)
```

---

## 3️⃣ Fluxo de Dados: AEM → Hydrogen

```
┌──────────────────────────────────────────────────────────────┐
│  AEM GraphQL (Persisted Query)                               │
│  GET /graphql/execute.json/wknd/bootcamp-products            │
│  POST /content/graphql/global (with filter)                  │
└──────────────────────┬───────────────────────────────────────┘
                       │
              Returns JSON:
              {
                "data": {
                  "produtoDestaqueList": {
                    "items": [
                      {
                        "titulo": "...",
                        "preco": 89.90,
                        "categoria": "Vestuário",
                        "stackTecnologico": "React",
                        "destaque": true,
                        "descricao": { "plaintext": "..." },
                        "imagem": { "_path": "/content/dam/.../..." }
                      },
                      ...
                    ]
                  }
                }
              }
                       │
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  Shopify Hydrogen                                            │
│  app/routes/about.jsx                                        │
│                                                              │
│  1. Loader fetches via AEM GraphQL (POST)                   │
│  2. Autenticação: Basic Auth (admin:admin)                  │
│  3. Filter: { destaque: { _expressions: [{ value: true }] }}│
│  4. Fallback: se AEM offline, mostra cache estático         │
│  5. Renderiza: ProductShowcase com source="aem-live"        │
└──────────────────────────────────────────────────────────────┘

Timeline: ~1000ms (com autenticação Basic Auth)
Fallback: Estático em 0ms se AEM offline
```

---

## 4️⃣ Fluxo de Dados: AEM → Commerce

```
┌──────────────────────────────────────────────────────────────┐
│  AEM Experience Fragment                                     │
│  Path: /content/experience-fragments/wknd/bootcamp-banner   │
│  Model: /content/experience-fragments/.../master            │
└──────────────────────────┬──────────────────────────────────┘
                           │
                    Publish XF
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│  Adobe Commerce (Modules)                                    │
│  Block/AemBanner.php                                         │
│                                                               │
│  1. Curl GET /content/experience-fragments/.../master.json   │
│  2. Parse JSON (título, descrição, imagem)                  │
│  3. Cache em var/cache/ (TTL: 3600s)                         │
│  4. Fallback: mostra placeholder se timeout (5s)            │
│  5. Renderiza no template: templates/aem-banner.phtml       │
└──────────────────────────────────────────────────────────────┘

                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│  Commerce Frontend                                           │
│  Homepage (CMS Layout)                                       │
│                                                               │
│  Exibe: Banner AEM atualizado em tempo real                 │
│  Update: Quando XF publicada no AEM                         │
└──────────────────────────────────────────────────────────────┘

Timeline: ~500ms (com Curl + JSON parse)
Cache: Reutiliza por 1 hora
```

---

## 5️⃣ Fluxo de Dados: Shopify → Hydrogen

```
┌──────────────────────────────────────────────────────────────┐
│  Shopify Admin API                                            │
│  POST /2024-01/graphql.json                                  │
│  Query: Products + Metafields                                │
└──────────────────────────┬──────────────────────────────────┘
                           │
         Returns Products com Metafields:
         • custom.tech_stack: "React"
         • custom.highlight_badge: "⭐ Destaque"
         • custom.bootcamp_year: 2026
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│  Shopify Hydrogen                                            │
│  app/routes/products.$handle.jsx                             │
│  app/routes/_index.jsx                                       │
│                                                               │
│  1. Loader: Storefront API Query (Headless)                 │
│  2. Filtra: products(first: 100, query: "...")              │
│  3. Extrai: title, price, compareAtPrice, variants          │
│  4. Extrai: metafields via aliases GraphQL                  │
│     productByHandle {                                        │
│       metafields(identifiers: [                             │
│         { namespace: "custom", key: "tech_stack" },        │
│         { namespace: "custom", key: "highlight_badge" }    │
│       ]) { value }                                           │
│     }                                                         │
│  5. Renderiza: ProductCard com badges + metafields         │
└──────────────────────────────────────────────────────────────┘

Timeline: ~800ms (via Storefront API)
```

---

## 6️⃣ Fluxo de Publicação: Atualizar Conteúdo

### Cenário: Editar Preço de Produto

```
┌─────────────────────────────────────┐
│ 1. AEM Author                       │
│    Editar Content Fragment          │
│    - Titulo                         │
│    - Preco: 99.90 (antes: 89.90)   │
│    - Click "Publish"                │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ 2. AEM Publish (Replication)       │
│    Content Fragment publicado       │
│    DAM Assets sincronizados         │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ 3. Hydrogen /about.jsx              │
│    Revalidate ISR (Incremental      │
│    Static Regeneration)             │
│    - Detecta mudança via webhook    │
│    - Regerera página /about         │
│    - Novo preço exibido em <1s      │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ 4. Browser (Cliente)                │
│    Refresh ou auto-update via ISR   │
│    Vê preço novo: 99.90             │
└─────────────────────────────────────┘

Timing: ~1000ms (publish AEM → ISR revalidate)
```

### Cenário: Editar Banner do Commerce no AEM

```
┌─────────────────────────────────────┐
│ 1. AEM Author                       │
│    Experience Fragment              │
│    - Banner Title: "Nova Promo!"    │
│    - Click "Publish"                │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ 2. AEM Publish                      │
│    XF publicado                     │
│    master.json atualizado           │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ 3. Magento Cache                    │
│    FPC (Full Page Cache) invalidado │
│    ou TTL expirado (1h)             │
│    Próxima requisição:              │
│    - Curl GET master.json do AEM    │
│    - Parseia novo conteúdo          │
│    - Renderiza no template          │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ 4. Commerce Frontend                │
│    Homepage recarregada             │
│    Novo banner exibido              │
└─────────────────────────────────────┘

Timing: ~1000ms (publish AEM → Magento FPC invalidate)
```

---

## 7️⃣ Arquitetura do Módulo Bootcamp_CatalogApi

```
┌─────────────────────────────────────────────────────────┐
│  Bootcamp_CatalogApi Module Structure                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  registration.php                                       │
│  ├─ Magento\Framework\Component\ComponentRegistrar     │
│  └─ Registra módulo: Bootcamp_CatalogApi               │
│                                                          │
│  etc/module.xml                                        │
│  ├─ Setup Version: 1.0.0                               │
│  └─ Dependencies: (nenhuma)                            │
│                                                          │
│  etc/di.xml                                            │
│  ├─ Type: ProductListInterface                         │
│  └─ SharedInstance: ProductListImpl                     │
│                                                          │
│  etc/webapi.xml ← IMPORTANTE                           │
│  ├─ Route: GET /V1/bootcamp/products                  │
│  ├─ Service: ProductListInterface::getList()           │
│  └─ Resources: ["anonymous" => true] ou ["catalog"]   │
│                                                          │
│  Api/ProductListInterface.php                          │
│  ├─ function getList()                                 │
│  ├─ return: ProductListOutput[]                        │
│  └─ usado pelo REST framework                          │
│                                                          │
│  Model/ProductList.php ← CORE LOGIC                    │
│  ├─ Extends: AbstractModel                             │
│  ├─ Inject: ProductRepository, ProductFactory         │
│  ├─ getList():                                         │
│  │  1. SearchCriteria: SKU like "BOOT-%"              │
│  │  2. $repo->getList($criteria)                      │
│  │  3. Loop: Map Product → ProductListOutput         │
│  │  4. Extract: sku, name, price, type, custom attrs │
│  │  5. Return: $outputs[]                             │
│  └─ Catch: Exception → log + throw Webapi Exception   │
│                                                          │
└─────────────────────────────────────────────────────────┘

Response Flow:
  GET /rest/V1/bootcamp/products
  ↓
  WebAPI Router (Magento)
  ↓
  ProductListInterface::getList()
  ↓
  ProductListImpl (Sling Model)
  ↓
  Fetch via ProductRepository
  ↓
  Map to DTO
  ↓
  JSON Response
```

---

## 8️⃣ Arquitetura do Componente ProductShowcase (AEM)

```
┌──────────────────────────────────────────────────────────┐
│  ProductShowcase Component (AEM WKND)                    │
├──────────────────────────────────────────────────────────┤
│                                                            │
│  ui.apps/src/main/content/jcr_root/apps/wknd/            │
│  components/productshowcase/                              │
│  │                                                        │
│  ├─ .content.xml                                         │
│  │  ├─ jcr:title = "Product Showcase"                   │
│  │  ├─ jcr:description = "Exibe produtos do Commerce"  │
│  │  ├─ componentGroup = ".hidden"                       │
│  │  └─ cq:authorizableId = "authors"                   │
│  │                                                        │
│  ├─ _cq_dialog/.content.xml                             │
│  │  ├─ Dialog fields:                                    │
│  │  │  ├─ apiUrl (textfield)                             │
│  │  │  ├─ sectionTitle (textfield)                       │
│  │  │  └─ onlyHighlights (checkbox)                      │
│  │  └─ Tabs: Basic, Settings                             │
│  │                                                        │
│  ├─ productshowcase.html (HTL Template)                 │
│  │  ├─ <div class="productshowcase">                    │
│  │  ├─ <h2>${productShowcase.sectionTitle}</h2>        │
│  │  ├─ <div data-sly-list="${productShowcase.products}">│
│  │  │  ├─ <img src="${item.imageUrl}">                  │
│  │  │  ├─ <h3>${item.name}</h3>                         │
│  │  │  ├─ <p>${item.price}</p>                          │
│  │  │  ├─ <span>${item.techStack}</span>                │
│  │  │  └─ <em data-sly-test="${item.highlight}">★</em>  │
│  │  └─ </div>                                            │
│  │                                                        │
│  └─ productshowcase.css (estilos)                       │
│     ├─ .productshowcase { display: grid; }             │
│     ├─ .productshowcase__card { ... }                   │
│     └─ .productshowcase__badge { ... }                  │
│                                                            │
│  core/src/main/java/com/example/core/models/             │
│  │                                                        │
│  ├─ ProductShowcase.java (Interface)                    │
│  │  ├─ String getSectionTitle()                          │
│  │  ├─ List<Product> getProducts()                       │
│  │  └─ boolean isEmpty()                                 │
│  │                                                        │
│  └─ ProductShowcaseImpl.java (Sling Model)               │
│     ├─ @Model annotation (adaptables = Resource.class)  │
│     ├─ @Inject: ValueMap (diálogo)                      │
│     ├─ @PostConstruct init()                            │
│     │  ├─ Fetch apiUrl from ValueMap                    │
│     │  ├─ HTTP GET via Apache HttpClient                │
│     │  ├─ Parse JSON response                           │
│     │  ├─ Filter if onlyHighlights=true                 │
│     │  ├─ Map to List<Product>                          │
│     │  └─ Handle errors (timeout, 404, etc)            │
│     └─ Catch: Exception → log + empty list              │
│                                                            │
└──────────────────────────────────────────────────────────┘

Component Usage:
  1. Author drags ProductShowcase no Page Editor
  2. Dialog: preenche apiUrl, sectionTitle, onlyHighlights
  3. Save & Publish
  4. Frontend: HTL renderiza loop + CSS
```

---

## 9️⃣ Arquitetura do Seção Liquid (Shopify)

```
┌──────────────────────────────────────────────────────────┐
│  bootcamp-products.liquid (Shopify Section)             │
├──────────────────────────────────────────────────────────┤
│                                                            │
│  sections/bootcamp-products.liquid                       │
│  │                                                        │
│  ├─ Liquid Tags:                                         │
│  │  ├─ {% for product in section.settings.collection ... │
│  │  ├─ {{ product.title }}                               │
│  │  ├─ {{ product.featured_image }}                      │
│  │  ├─ {{ product.price | money }}                       │
│  │  ├─ {{ product.metafields.custom.tech_stack }}       │
│  │  ├─ {{ product.metafields.custom.highlight_badge }}  │
│  │  └─ Discount calc:                                    │
│  │     {{ product.compare_at_price                       │
│  │        | minus: product.price                         │
│  │        | times: 100                                   │
│  │        | divided_by: product.compare_at_price         │
│  │        | round }}%                                     │
│  │                                                        │
│  ├─ Schema JSON:                                         │
│  │  ├─ "type": "image_picker" (section banner)           │
│  │  ├─ "type": "text" (title, description)              │
│  │  ├─ "type": "collection" (coleção selecionada)       │
│  │  ├─ "type": "range" (max_products: 1-20)             │
│  │  ├─ "type": "select" (padding: small/medium/large)   │
│  │  └─ "type": "color" (background)                     │
│  │                                                        │
│  └─ Output:                                              │
│     ├─ HTML com grid de produtos                         │
│     ├─ Classes CSS BEM                                    │
│     └─ Lazy load com native img loading="lazy"          │
│                                                            │
│  assets/bootcamp-products.css                            │
│  │                                                        │
│  ├─ :root (variáveis)                                    │
│  │  ├─ --color-primary: #007bff                         │
│  │  ├─ --color-badge: #ffcc00                           │
│  │  └─ --spacing-unit: 1rem                             │
│  │                                                        │
│  └─ Classes BEM:                                         │
│     ├─ .bootcamp-products { ... }                       │
│     ├─ .bootcamp-products__grid { display: grid; }      │
│     ├─ .bootcamp-products__card { ... }                 │
│     ├─ .bootcamp-products__card--highlight { ... }      │
│     ├─ .bootcamp-products__image { ... }                │
│     ├─ .bootcamp-products__title { ... }                │
│     ├─ .bootcamp-products__price { ... }                │
│     ├─ .bootcamp-products__badge { ... }                │
│     └─ .bootcamp-products__discount { ... }             │
│                                                            │
└──────────────────────────────────────────────────────────┘

Theme Integration:
  1. Online Store > Themes > Customize
  2. Add section > Bootcamp Products
  3. Configure: Collection, Max Products, Padding
  4. Save
  5. Seção aparece na homepage com produtos dinâmicos
```

---

## 🔟 Fluxo de Erro & Fallback

```
┌─────────────────────────────────────────────────────────┐
│  Cenário: AEM está OFFLINE                              │
└─────────────────────────────────────────────────────────┘

Hydrogen /about.jsx Loader:
  ├─ POST http://localhost:4502/content/graphql/global
  ├─ Timeout: 5s
  ├─ ❌ Connection Refused
  │
  ├─ Catch Exception
  │
  ├─ Check Cache: var/cache/aem-products.json
  │  ├─ Encontrado? ✅ Use it (marked as stale)
  │  └─ Não encontrado? Use fallback estático
  │
  └─ Return:
     {
       "products": [...],
       "source": "aem-static",  ← indica que é fallback
       "error": "AEM offline, usando cache"
     }

Page Renders:
  - Mostra banner: "⚠️ Conteúdo em cache (AEM offline)"
  - Exibe produtos do cache
  - User pode navegar normalmente

Resolution:
  - AEM volta online
  - Próxima requisição: GET novamente
  - Cache atualizado, banner desaparece
  - source muda para "aem-live"
```

---

## 📞 Fluxo de Comunicação Entre Serviços

```
                ┌──────────┐
                │ Hydrogen │
                │ :3000    │
                └────┬─────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        │(1)REST     │(2)GraphQL  │(3)GraphQL
        │            │            │
        ▼            ▼            ▼
    Commerce       AEM          AEM
    :443/          :4502/       :4502/
    rest/V1/       content/     graphql/
    bootcamp/      graphql/     execute.json/
    products       global       wknd/...

(1) Busca produto Commerce (JSON)
    - Sem auth ou Bearer token
    - Response: array of products

(2) Busca conteúdo AEM (GraphQL)
    - Basic Auth (admin:admin)
    - Query: produtoDestaqueList
    - Response: JSON com destaque=true

(3) Usa Persisted Query do AEM
    - Sem query string (mais rápido)
    - Response: JSON pré-calculado

Parallelization:
  - Hydrogen pode fazer (1), (2), (3) em paralelo
  - Promise.all([fetch1, fetch2, fetch3])
  - Max latency = max(latency1, latency2, latency3) ~ 1000ms
```

---

**Última atualização:** Abril 2026
