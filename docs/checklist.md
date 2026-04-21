# ✅ Checklist Bootcamp 2026

Checklist completo para os 7 dias do bootcamp. Marque conforme completar cada tarefa.

---

## 📅 DIAS 11-14: FASE 1 — Adobe Commerce

### Dia 11: Configuração Base

- [ ] **11.1** Acessar Admin do Commerce: `https://app.magento2.test/admin`
- [ ] **11.2** Criar atributo `bootcamp_highlight` (Yes/No, Store View)
  - [ ] Stores > Attributes > Product > Add New
  - [ ] Attribute Code: `bootcamp_highlight`
  - [ ] Input Type: Yes/No
  - [ ] Scope: Store View
  - [ ] Required: No
- [ ] **11.3** Criar atributo `tech_stack` (Dropdown, Global)
  - [ ] Stores > Attributes > Product > Add New
  - [ ] Attribute Code: `tech_stack`
  - [ ] Input Type: Dropdown
  - [ ] Scope: Global
  - [ ] Opções: PHP, Java, JavaScript, React, Liquid
  - [ ] Required: No
- [ ] **11.4** Adicionar ambos atributos ao Attribute Set "Default"
  - [ ] Stores > Attributes > Attribute Set > Default
  - [ ] Drag & drop para grupos apropriados
  - [ ] Save

### Dia 12: Categorias

- [ ] **12.1** Criar estrutura de categorias em Catalog > Categories:
  - [ ] Loja Bootcamp (Root)
    - [ ] Vestuário
      - [ ] Camisetas
    - [ ] Acessórios
      - [ ] Canecas
      - [ ] Mochilas
    - [ ] Papelaria
      - [ ] Adesivos
    - [ ] Digital
      - [ ] Cursos

### Dia 13: Produtos (Parte 1)

- [ ] **13.1** Criar 5 produtos com os atributos customizados:
  - [ ] **BOOT-CAM-001**: Camiseta Bootcamp 2026
    - [ ] Tipo: Configurable (P/M/G/GG)
    - [ ] Preço: R$ 89,90
    - [ ] bootcamp_highlight: Yes
    - [ ] tech_stack: React
    - [ ] Imagem adicionada
    - [ ] Status: Enabled
  
  - [ ] **BOOT-CAN-002**: Caneca Developer
    - [ ] Tipo: Simple
    - [ ] Preço: R$ 45,00
    - [ ] bootcamp_highlight: Yes
    - [ ] tech_stack: JavaScript
    - [ ] Imagem adicionada
    - [ ] Status: Enabled
  
  - [ ] **BOOT-MOC-003**: Mochila Tech
    - [ ] Tipo: Simple
    - [ ] Preço: R$ 199,90
    - [ ] bootcamp_highlight: No
    - [ ] tech_stack: Java
    - [ ] Imagem adicionada
    - [ ] Status: Enabled
  
  - [ ] **BOOT-KIT-004**: Kit Adesivos Dev
    - [ ] Tipo: Grouped
    - [ ] Preço: R$ 29,90
    - [ ] bootcamp_highlight: Yes
    - [ ] tech_stack: PHP
    - [ ] Imagem adicionada
    - [ ] Status: Enabled
  
  - [ ] **BOOT-CUR-005**: Curso Online Adobe Commerce
    - [ ] Tipo: Virtual
    - [ ] Preço: Gratuito (sem preço)
    - [ ] bootcamp_highlight: Yes
    - [ ] tech_stack: Liquid
    - [ ] Status: Enabled

### Dia 14: Módulo CatalogApi

- [ ] **14.1** Criar estrutura do módulo:
  ```
  app/code/Bootcamp/CatalogApi/
  ├── registration.php
  ├── etc/
  │   ├── module.xml
  │   ├── di.xml
  │   └── webapi.xml
  ├── Api/
  │   └── ProductListInterface.php
  └── Model/
      └── ProductList.php
  ```

- [ ] **14.2** Implementar `registration.php`
- [ ] **14.3** Implementar `etc/module.xml`
- [ ] **14.4** Implementar `etc/di.xml`
- [ ] **14.5** Implementar `etc/webapi.xml` (define rota GET /V1/bootcamp/products)
- [ ] **14.6** Implementar `Api/ProductListInterface.php`
- [ ] **14.7** Implementar `Model/ProductList.php` (filtra SKUs BOOT-%, retorna customizados)
- [ ] **14.8** Ativar módulo:
  ```bash
  php bin/magento module:enable Bootcamp_CatalogApi
  php bin/magento setup:upgrade
  php bin/magento cache:flush
  ```
- [ ] **14.9** Testar API:
  ```bash
  curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq
  ```
- [ ] **14.10** ✅ Verificar resposta com 5 produtos, sku, name, price, type, bootcamp_highlight, tech_stack, image_url

---

## 📅 DIA 12: FASE 2 — AEM Content Fragments + GraphQL

- [ ] **12.1** Acessar AEM Author: `http://localhost:4502`
- [ ] **12.2** Criar Content Fragment Model "Produto Destaque"
  - [ ] Tools > Assets > Content Fragment Models > Create
  - [ ] Título: "Produto Destaque"
  - [ ] Adicionar campos:
    - [ ] `titulo` (Text)
    - [ ] `descricao` (Rich Text)
    - [ ] `preco` (Number)
    - [ ] `imagem` (Content Reference)
    - [ ] `categoria` (Enumeration: Vestuário, Acessórios, Papelaria, Digital)
    - [ ] `stackTecnologico` (Enumeration: PHP, Java, JavaScript, React, Liquid)
    - [ ] `destaque` (Boolean)
    - [ ] `linkExterno` (Text)
  - [ ] Click "Enable" (habilitar modelo)
  - [ ] Save

- [ ] **12.3** Criar pasta no DAM:
  - [ ] Assets > Files > WKND
  - [ ] Criar pasta "Bootcamp"
  - [ ] Criar subfolder "Produtos"
  - [ ] Fazer upload das 5 imagens dos produtos

- [ ] **12.4** Criar Content Fragments:
  - [ ] **CF-001**: Camiseta Bootcamp 2026
    - [ ] titulo: "Camiseta Bootcamp 2026"
    - [ ] descricao: "Camiseta oficial com logo bordado"
    - [ ] preco: 89.90
    - [ ] categoria: "Vestuário"
    - [ ] stackTecnologico: "React"
    - [ ] destaque: true
    - [ ] linkExterno: "https://app.magento2.test/p/boot-cam-001"
    - [ ] imagem: referência para /content/dam/wknd/bootcamp/produtos/camiseta.jpg
    - [ ] Publish
  
  - [ ] **CF-002**: Caneca Developer
    - [ ] titulo: "Caneca Developer"
    - [ ] preco: 45.00
    - [ ] categoria: "Acessórios"
    - [ ] stackTecnologico: "JavaScript"
    - [ ] destaque: true
    - [ ] Publish
  
  - [ ] **CF-003**: Mochila Tech
    - [ ] titulo: "Mochila Tech"
    - [ ] preco: 199.90
    - [ ] categoria: "Acessórios"
    - [ ] stackTecnologico: "Java"
    - [ ] destaque: false
    - [ ] Publish
  
  - [ ] **CF-004**: Kit Adesivos Dev
    - [ ] titulo: "Kit Adesivos Dev"
    - [ ] preco: 29.90
    - [ ] categoria: "Papelaria"
    - [ ] stackTecnologico: "PHP"
    - [ ] destaque: true
    - [ ] Publish
  
  - [ ] **CF-005**: Curso Online Adobe Commerce
    - [ ] titulo: "Curso Online Adobe Commerce"
    - [ ] preco: 0
    - [ ] categoria: "Digital"
    - [ ] stackTecnologico: "Liquid"
    - [ ] destaque: true
    - [ ] Publish

- [ ] **12.5** Testar GraphQL no GraphiQL:
  - [ ] Acessar: `http://localhost:4502/content/graphql/global`
  - [ ] Query: Listar todos
    ```graphql
    { produtoDestaqueList { items { titulo preco categoria } } }
    ```
  - [ ] ✅ Deve retornar 5 produtos
  
  - [ ] Query: Filtrar destaques
    ```graphql
    { produtoDestaqueList(filter: { destaque: { _expressions: [{ value: true }] } }) { items { titulo } } }
    ```
  - [ ] ✅ Deve retornar 3 produtos

- [ ] **12.6** Criar Persisted Query:
  ```bash
  curl -X PUT 'http://localhost:4502/graphql/persist.json/wknd/bootcamp-products' \
    -H 'Content-Type: application/json' \
    -u admin:admin \
    -d '{"query": "{ produtoDestaqueList { items { titulo preco categoria stackTecnologico destaque descricao { plaintext } } } }"}'
  ```
  - [ ] ✅ Retorna status: "ok"

- [ ] **12.7** Criar Página "Vitrine Bootcamp" no AEM
  - [ ] Sites > WKND > Language Masters > EN
  - [ ] Create > Page
  - [ ] Título: "Vitrine Bootcamp"
  - [ ] Template: "Page"
  - [ ] Adicionar componente "Content Fragment List"
  - [ ] Configurar para /content/dam/wknd/bootcamp/produtos
  - [ ] Publish

---

## 📅 DIA 13: FASE 4 — Shopify Liquid + Metafields

- [ ] **13.1** Criar Shopify Store de teste em https://www.shopify.com/
- [ ] **13.2** Acessar Shopify Admin: `https://seu-store.myshopify.com/admin`

- [ ] **13.3** Criar Metafield Definitions:
  - [ ] Settings > Custom data > Metafields > Products
  - [ ] Criar:
    - [ ] `custom.tech_stack` (Single line text, Storefront access: Enabled)
    - [ ] `custom.highlight_badge` (Single line text, Storefront access: Enabled)
    - [ ] `custom.bootcamp_year` (Integer, min: 2020, max: 2030, Storefront access: Enabled)

- [ ] **13.4** Criar 5 Produtos no Shopify:
  - [ ] **BOOT-CAM-001**: Camiseta Bootcamp 2026
    - [ ] Tipo: Product with variants (P/M/G/GG)
    - [ ] Preço: 89.90 BRL
    - [ ] Compare at price: 129.90 BRL
    - [ ] Metafields:
      - [ ] tech_stack: "React"
      - [ ] highlight_badge: "⭐ Destaque"
      - [ ] bootcamp_year: "2026"
    - [ ] Imagem adicionada
    - [ ] Status: Active
  
  - [ ] **BOOT-CAN-002**: Caneca Developer
    - [ ] Tipo: Product (simple)
    - [ ] Preço: 45.00 BRL
    - [ ] Metafields preenchidos
    - [ ] Status: Active
  
  - [ ] **BOOT-MOC-003**: Mochila Tech
    - [ ] Tipo: Product (simple)
    - [ ] Preço: 199.90 BRL
    - [ ] Metafields preenchidos
    - [ ] Status: Active
  
  - [ ] **BOOT-KIT-004**: Kit Adesivos Dev
    - [ ] Tipo: Product (simple)
    - [ ] Preço: 29.90 BRL
    - [ ] Metafields preenchidos
    - [ ] Status: Active
  
  - [ ] **BOOT-CUR-005**: Curso Online Adobe Commerce
    - [ ] Tipo: Product (service/digital)
    - [ ] Preço: 0 BRL (ou custom)
    - [ ] Metafields preenchidos
    - [ ] Status: Active

- [ ] **13.5** Criar 4 Coleções Manuais:
  - [ ] Destaques (conter 3 produtos com highlight_badge)
  - [ ] Vestuário (conter camiseta)
  - [ ] Acessórios (conter caneca, mochila)
  - [ ] Digital (conter curso)

- [ ] **13.6** Atualizar Menu de Navegação:
  - [ ] Adicionar links para as 4 coleções

- [ ] **13.7** Criar Seção Custom `bootcamp-products.liquid`:
  - [ ] Themes > Customize > Edit code
  - [ ] Criar arquivo: `sections/bootcamp-products.liquid`
  - [ ] Implementar:
    - [ ] Loop nos produtos da coleção selecionada
    - [ ] Exibir `product.metafields.custom.highlight_badge`
    - [ ] Exibir `product.metafields.custom.tech_stack`
    - [ ] Calcular desconto: `{{ product.compare_at_price | minus: product.price | times: 100 | divided_by: product.compare_at_price | round }}%`
    - [ ] Schema JSON com settings: título, descrição, coleção, max_products, padding

- [ ] **13.8** Criar arquivo de estilos:
  - [ ] `assets/bootcamp-products.css`
  - [ ] Implementar estilos BEM: `.bootcamp-products`, `.bootcamp-products__card`, etc.

- [ ] **13.9** Adicionar na Homepage via Theme Editor:
  - [ ] Online Store > Themes > Customize
  - [ ] Add section > Bootcamp Products
  - [ ] Configurar: Coleção "Destaques"
  - [ ] Save

---

## 📅 DIA 15: FASE 3 — AEM + Commerce (Integração)

- [ ] **15.1** Criar Componente "Product Showcase" no AEM (WKND):
  - [ ] ui.apps/src/main/content/jcr_root/apps/wknd/components/
  - [ ] Criar pasta: `productshowcase/`
  
  - [ ] **15.1.1** Criar `.content.xml` (metadados do componente)
  - [ ] **15.1.2** Criar `_cq_dialog/.content.xml` (dialog com campos):
    - [ ] `apiUrl` (text) — URL da API Commerce
    - [ ] `sectionTitle` (text) — Título da seção
    - [ ] `onlyHighlights` (checkbox) — Apenas destaques?
  
  - [ ] **15.1.3** Criar `productshowcase.html` (template HTL):
    - [ ] Iterar sobre products
    - [ ] Exibir imagem, nome, preço, tech_stack, bootcamp_highlight
  
  - [ ] **15.2** No módulo WKND core, criar Sling Model:
    - [ ] `core/src/main/java/com/example/core/models/ProductShowcase.java` (interface)
      - [ ] `getSectionTitle()` : String
      - [ ] `getProducts()` : List<Product>
      - [ ] `isEmpty()` : boolean
    
    - [ ] `core/src/main/java/com/example/core/models/ProductShowcaseImpl.java` (implementação)
      - [ ] Fazer HTTP GET para API Commerce
      - [ ] Parsear JSON com Gson
      - [ ] Filtrar por `bootcamp_highlight` se configurado
      - [ ] Tratar erros graciosamente
      - [ ] Timeout 5s

- [ ] **15.3** Build e Deploy:
  ```bash
  mvn clean install -PautoInstallSinglePackage -pl core,ui.apps,ui.frontend
  ```
  - [ ] ✅ Build bem-sucedido

- [ ] **15.4** Criar Página "Loja Bootcamp" no AEM:
  - [ ] Sites > WKND > Language Masters > EN
  - [ ] Create > Page
  - [ ] Título: "Loja Bootcamp"
  - [ ] Template: "Page"
  - [ ] Drag & drop componente "Product Showcase"
  - [ ] Configurar:
    - [ ] apiUrl: `https://app.magento2.test/rest/V1/bootcamp/products`
    - [ ] sectionTitle: "Produtos em Destaque"
    - [ ] onlyHighlights: checked
  - [ ] Publish
  - [ ] ✅ Acessar página e verificar produtos carregando

---

## 📅 DIA 16: FASE 5 — Shopify Hydrogen

- [ ] **16.1** Inicializar Projeto Hydrogen:
  ```bash
  cd /home/igors/projects/bootcamp-2026/shopify-hydrogen
  npx @shopify/create-hydrogen@latest bootcamp-hydrogen
  ```

- [ ] **16.2** Configurar `.env`:
  - [ ] Copiar `.env.example` para `.env`
  - [ ] Preencher:
    - [ ] `PUBLIC_STOREFRONT_API_TOKEN=seu-token`
    - [ ] `PUBLIC_STORE_DOMAIN=seu-store.myshopify.com`
    - [ ] `SESSION_SECRET=bootcamp-secret-key-2026`

- [ ] **16.3** Homepage (`app/routes/_index.jsx`):
  - [ ] Loader busca coleção "destaques" via Storefront API GraphQL
  - [ ] Renderizar componente `ProductCard`
    - [ ] Exibir `<Image>` do Hydrogen
    - [ ] Exibir `<Money>` do Hydrogen
    - [ ] Exibir `product.metafields.custom.techStack`
    - [ ] Exibir `product.metafields.custom.highlightBadge`
  - [ ] Query GraphQL com aliases para metafields

- [ ] **16.4** Página de Produto (`app/routes/products.$handle.jsx`):
  - [ ] Loader recebe `$handle` da URL
  - [ ] Buscar produto via Storefront API
  - [ ] Renderizar:
    - [ ] Imagem grande
    - [ ] Preço atual
    - [ ] Compare at price (riscado)
    - [ ] Variantes (dropdown ou buttons)
    - [ ] Metafields (tech_stack, highlight_badge)
    - [ ] Descrição em HTML
    - [ ] "Add to cart" button
  - [ ] Se não encontrado: retornar 404

- [ ] **16.5** Criar estilos:
  - [ ] `app/styles/bootcamp.css`
  - [ ] Variáveis CSS: cores, espaçamento, fontes
  - [ ] Importar em `root.jsx`

- [ ] **16.6** Rodar localmente:
  ```bash
  npm run dev
  ```
  - [ ] ✅ Acessar `http://localhost:3000`
  - [ ] ✅ Ver produtos em destaque
  - [ ] ✅ Clicar em um produto e ver página de detalhe

---

## 📅 DIA 17: FASE 6 — Integração AEM nos Storefronts

- [ ] **17.1** AEM Content no Hydrogen (`/about`):
  - [ ] Criar `app/routes/about.jsx`
  - [ ] Loader faz POST para `http://localhost:4502/content/graphql/global`
  - [ ] Autenticação: Basic Auth com `btoa('admin:admin')`
  - [ ] Query: Produtos com `destaque: true`
  - [ ] Fallback gracioso se AEM offline
  - [ ] Renderizar: componente que exibe origem (`aem-live` ou `aem-static`)

- [ ] **17.2** AEM Content no Commerce (Banner):
  - [ ] Criar módulo `Bootcamp_AemContent` em `app/code/Bootcamp/`
  - [ ] Criar `Block/AemBanner.php`:
    - [ ] Usar `Magento\Framework\HTTP\Client\Curl`
    - [ ] Buscar model.json do Experience Fragment do AEM
    - [ ] Timeout: 5 segundos
    - [ ] Fallback se offline
  
  - [ ] Criar `templates/aem-banner.phtml`:
    - [ ] Renderizar título e texto do banner
  
  - [ ] Ativar módulo:
    ```bash
    php bin/magento module:enable Bootcamp_AemContent
    php bin/magento setup:upgrade
    ```
  
  - [ ] Adicionar na homepage via CMS > Blocks ou via Layout Update

- [ ] **17.3** Criar Experience Fragment no AEM:
  - [ ] Experience Fragments > WKND > Create
  - [ ] Template: "Web Variation"
  - [ ] Título: "Banner Promo Bootcamp"
  - [ ] Adicionar componente Title: "Aprenda Adobe Commerce com a gente!"
  - [ ] Adicionar componente Text: "Agende sua sessão hoje"
  - [ ] Publish

- [ ] **17.4** Testar o Fluxo Completo:
  - [ ] Editar título no Experience Fragment do AEM
  - [ ] Publish
  - [ ] ✅ Recarregar homepage do Commerce → banner atualizado
  - [ ] ✅ Recarregar `/about` do Hydrogen → produtos atualizados

---

## 📋 VALIDAÇÃO FINAL

- [ ] **Fase 1**: Commerce API retorna 5 produtos com customizados
  ```bash
  curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq '.items | length'
  # Esperado: 5
  ```

- [ ] **Fase 2**: AEM GraphQL retorna 5 content fragments
  ```bash
  curl -X POST http://localhost:4502/content/graphql/global -u admin:admin \
    -H 'Content-Type: application/json' \
    -d '{"query":"{ produtoDestaqueList { items { titulo } } }"}' | jq '.data.produtoDestaqueList.items | length'
  # Esperado: 5
  ```

- [ ] **Fase 3**: Componente ProductShowcase renderiza na página do AEM
  - [ ] Acessar: `http://localhost:4502/content/dam/wknd/bootcamp/loja`
  - [ ] ✅ Ver 3+ produtos carregando

- [ ] **Fase 4**: Produtos e metafields aparecem na loja Shopify
  - [ ] Acessar: `https://seu-store.myshopify.com/`
  - [ ] ✅ Ver seção bootcamp-products com 3+ produtos
  - [ ] ✅ Ver badges e tech_stack

- [ ] **Fase 5**: Hydrogen rodando localmente
  ```bash
  curl -s http://localhost:3000 | grep '<title>'
  # Esperado: contém "Bootcamp"
  ```

- [ ] **Fase 6**: AEM integrado em Hydrogen e Commerce
  - [ ] Acessar: `http://localhost:3000/about`
  - [ ] ✅ Ver conteúdo do AEM (ou fallback se offline)
  - [ ] ✅ Editar no AEM e ver refletido em tempo real

---

## 🎉 Projeto Concluído!

- [ ] Todos os endpoints testados e funcionando
- [ ] Documentação atualizada
- [ ] Código comentado e organizado
- [ ] Repositório git com commits significativos
- [ ] README com instruções de setup
- [ ] Pronto para deploy

**Status:** 🟢 Bootcamp Completo!

---

**Última atualização:** Abril 2026
