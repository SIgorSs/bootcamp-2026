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

### Localmente Instalado
- **Node.js 18+** — Para Hydrogen
- **Java 17+** — Para AEM (✅ já instalado)
- **Maven 3.8+** — Build do AEM
- **PHP 8.1+** — Development do Commerce (opcional)

### Instâncias Externas
- **Adobe Commerce** (`https://app.magento2.test`) — ✅ Local WSL
- **AEM Author** (`http://localhost:4502`) — ✅ Local WSL
- **Shopify Store** — Loja de teste (precisará ser criada)
- **Shopify Hydrogen** — App local em desenvolvimento

### Credenciais Necessárias
- Adobe Commerce: admin / admin (local)
- AEM: admin / admin (local)
- Shopify: Access Token para Storefront API
- Shopify: Access Token para Admin API

---

## 🚀 Como Iniciar

### 1. Clonar e Preparar

```bash
cd /home/igors/projects/bootcamp-2026

# Estrutura já criada
ls -la
```

### 2. Adobe Commerce (Fases 1 e 3)

```bash
cd /home/igors/projects/magento2

# Verificar instalação
php bin/magento --version

# Criar atributos e categorias (via admin UI)
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
