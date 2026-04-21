# 🔌 Endpoints & APIs Bootcamp 2026

Referência completa de endpoints, métodos, autenticação e exemplos.

---

## 1️⃣ Adobe Commerce REST API

### Base URL
```
https://app.magento2.test/rest/V1/
```

### Autenticação
```
Header: Authorization: Bearer <token>
```
Ou para desenvolvimento local (integração simples):
```
Sem autenticação (permissões anônimas habilitadas)
```

---

### Endpoint: GET /bootcamp/products

**Descrição:** Retorna 5 produtos com atributos customizados.

**Método:** `GET`

**URL Completa:**
```
https://app.magento2.test/rest/V1/bootcamp/products
```

**Headers:**
```
Content-Type: application/json
```

**Query Parameters:**
```
Nenhum (retorna todos os 5 produtos BOOT-%)
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
      "image_url": "https://app.magento2.test/media/catalog/product/b/o/boot-can-002.jpg",
      "description": "Caneca para desenvolvedores",
      "status": 1,
      "visibility": 4
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
      "image_url": "https://app.magento2.test/media/catalog/product/b/o/boot-moc-003.jpg",
      "description": "Mochila para carregar equipamentos",
      "status": 1,
      "visibility": 4
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
      "image_url": "https://app.magento2.test/media/catalog/product/b/o/boot-kit-004.jpg",
      "description": "Kit com 10 adesivos para desenvolvedores",
      "status": 1,
      "visibility": 4
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
      "image_url": null,
      "description": "Acesso ao curso online completo",
      "status": 1,
      "visibility": 4
    }
  ],
  "total_count": 5
}
```

**Erro (404 Not Found):**
```json
{
  "message": "Módulo Bootcamp_CatalogApi não ativado"
}
```

**Exemplo de cURL:**
```bash
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq
```

**Exemplo de JavaScript/Fetch:**
```javascript
async function getProducts() {
  const response = await fetch('https://app.magento2.test/rest/V1/bootcamp/products', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  });
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  return await response.json();
}

getProducts().then(data => {
  console.log('Produtos:', data.items);
}).catch(error => {
  console.error('Erro ao buscar produtos:', error);
});
```

---

### Endpoint: GET /products (Buscar todos - Magento padrão)

**URL:**
```
https://app.magento2.test/rest/V1/products
```

**Retorna:** Lista completa de produtos com paginação.

---

## 2️⃣ AEM GraphQL API

### Base URL
```
http://localhost:4502/content/graphql/global
```

### Autenticação
```
Basic Auth: Authorization: Basic <base64(admin:admin)>
Header: Content-Type: application/json
```

---

### Query: Listar Todos os Produtos Destaque

**Método:** `POST`

**URL Completa:**
```
http://localhost:4502/content/graphql/global
```

**Body:**
```graphql
{
  produtoDestaqueList {
    items {
      titulo
      descricao {
        plaintext
      }
      preco
      categoria
      stackTecnologico
      destaque
      imagem {
        _path
      }
      linkExterno
    }
  }
}
```

**Response (200 OK):**
```json
{
  "data": {
    "produtoDestaqueList": {
      "items": [
        {
          "titulo": "Camiseta Bootcamp 2026",
          "descricao": {
            "plaintext": "Camiseta oficial do Bootcamp com logo"
          },
          "preco": 89.9,
          "categoria": "Vestuário",
          "stackTecnologico": "React",
          "destaque": true,
          "imagem": {
            "_path": "/content/dam/wknd/bootcamp/produtos/camiseta.jpg"
          },
          "linkExterno": "https://app.magento2.test/p/boot-cam-001"
        },
        {
          "titulo": "Caneca Developer",
          "descricao": {
            "plaintext": "Caneca térmica para bebidas quentes"
          },
          "preco": 45.0,
          "categoria": "Acessórios",
          "stackTecnologico": "JavaScript",
          "destaque": true,
          "imagem": {
            "_path": "/content/dam/wknd/bootcamp/produtos/caneca.jpg"
          },
          "linkExterno": "https://app.magento2.test/p/boot-can-002"
        }
      ]
    }
  }
}
```

**Exemplo de cURL:**
```bash
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{
    "query": "{ produtoDestaqueList { items { titulo preco destaque } } }"
  }' | jq
```

---

### Query: Filtrar Apenas Destaques (destaque: true)

**Body:**
```graphql
{
  produtoDestaqueList(filter: { destaque: { _expressions: [{ value: true }] } }) {
    items {
      titulo
      preco
      stackTecnologico
    }
  }
}
```

**Response:** Retorna apenas 3 produtos com `destaque: true`.

**Exemplo de cURL:**
```bash
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{
    "query": "{ produtoDestaqueList(filter: { destaque: { _expressions: [{ value: true }] } }) { items { titulo preco stackTecnologico } } }"
  }' | jq
```

---

### Persisted Query: bootcamp-products

**Criar a Persisted Query:**
```bash
curl -X PUT 'http://localhost:4502/graphql/persist.json/wknd/bootcamp-products' \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{
    "query": "{ produtoDestaqueList { items { titulo preco categoria stackTecnologico destaque descricao { plaintext } imagem { _path } linkExterno } } }"
  }'
```

**Response (200 OK):**
```json
{
  "status": "ok",
  "queryId": "wknd/bootcamp-products"
}
```

**Usar a Persisted Query (sem passar a query completa):**
```bash
curl http://localhost:4502/graphql/execute.json/wknd/bootcamp-products \
  -H 'Content-Type: application/json'
```

**URL Curta:**
```
http://localhost:4502/graphql/execute.json/wknd/bootcamp-products
```

---

### Query: Filtrar por Categoria

**Body:**
```graphql
{
  produtoDestaqueList(filter: { categoria: { _expressions: [{ value: "Vestuário" }] } }) {
    items {
      titulo
      categoria
    }
  }
}
```

---

## 3️⃣ Shopify Storefront API

### Base URL
```
https://seu-store.myshopify.com/api/2024-01/graphql.json
```

### Autenticação
```
Header: X-Shopify-Storefront-Access-Token: <seu-token>
Header: Content-Type: application/json
```

---

### Query: Listar 5 Produtos da Coleção "Destaques"

**Método:** `POST`

**URL Completa:**
```
https://seu-store.myshopify.com/api/2024-01/graphql.json
```

**Body:**
```graphql
{
  collectionByHandle(handle: "destaques") {
    products(first: 5) {
      edges {
        node {
          id
          handle
          title
          description
          priceRange {
            minVariantPrice {
              amount
              currencyCode
            }
          }
          compareAtPriceRange {
            maxVariantPrice {
              amount
              currencyCode
            }
          }
          metafields(identifiers: [
            { namespace: "custom", key: "tech_stack" },
            { namespace: "custom", key: "highlight_badge" },
            { namespace: "custom", key: "bootcamp_year" }
          ]) {
            namespace
            key
            value
          }
          featuredImage {
            url
            altText
          }
          variants(first: 3) {
            edges {
              node {
                id
                title
                availableForSale
                selectedOptions {
                  name
                  value
                }
                priceV2 {
                  amount
                  currencyCode
                }
              }
            }
          }
        }
      }
    }
  }
}
```

**Response (200 OK):**
```json
{
  "data": {
    "collectionByHandle": {
      "products": {
        "edges": [
          {
            "node": {
              "id": "gid://shopify/Product/123456789",
              "handle": "camiseta-bootcamp-2026",
              "title": "Camiseta Bootcamp 2026",
              "description": "Camiseta oficial com logo bordado",
              "priceRange": {
                "minVariantPrice": {
                  "amount": "89.90",
                  "currencyCode": "BRL"
                }
              },
              "compareAtPriceRange": {
                "maxVariantPrice": {
                  "amount": "129.90",
                  "currencyCode": "BRL"
                }
              },
              "metafields": [
                {
                  "namespace": "custom",
                  "key": "tech_stack",
                  "value": "React"
                },
                {
                  "namespace": "custom",
                  "key": "highlight_badge",
                  "value": "⭐ Destaque"
                },
                {
                  "namespace": "custom",
                  "key": "bootcamp_year",
                  "value": "2026"
                }
              ],
              "featuredImage": {
                "url": "https://cdn.shopify.com/s/files/1/0/camiseta.jpg",
                "altText": "Camiseta Bootcamp 2026"
              },
              "variants": {
                "edges": [
                  {
                    "node": {
                      "id": "gid://shopify/ProductVariant/234567890",
                      "title": "P",
                      "availableForSale": true,
                      "selectedOptions": [
                        {
                          "name": "Tamanho",
                          "value": "P"
                        }
                      ],
                      "priceV2": {
                        "amount": "89.90",
                        "currencyCode": "BRL"
                      }
                    }
                  }
                ]
              }
            }
          }
        ]
      }
    }
  }
}
```

**Exemplo de cURL:**
```bash
curl -X POST https://seu-store.myshopify.com/api/2024-01/graphql.json \
  -H 'X-Shopify-Storefront-Access-Token: seu-token-aqui' \
  -H 'Content-Type: application/json' \
  -d '{ "query": "{ collectionByHandle(handle: \"destaques\") { products(first: 5) { edges { node { title priceRange { minVariantPrice { amount } } } } } } }" }' | jq
```

---

### Query: Buscar Produto por Handle

**Body:**
```graphql
{
  productByHandle(handle: "camiseta-bootcamp-2026") {
    id
    title
    handle
    description
    onlineStoreUrl
    priceRange {
      minVariantPrice {
        amount
        currencyCode
      }
    }
    compareAtPriceRange {
      maxVariantPrice {
        amount
        currencyCode
      }
    }
    metafields(identifiers: [
      { namespace: "custom", key: "tech_stack" },
      { namespace: "custom", key: "highlight_badge" }
    ]) {
      namespace
      key
      value
    }
    variants(first: 10) {
      edges {
        node {
          id
          title
          sku
          availableForSale
          selectedOptions {
            name
            value
          }
          priceV2 {
            amount
            currencyCode
          }
          image {
            url
          }
        }
      }
    }
  }
}
```

---

## 4️⃣ Shopify Hydrogen API (Local)

### Base URL
```
http://localhost:3000
```

**Desenvolvimento:**
```bash
npm run dev
```

---

### Endpoint: GET /

**Descrição:** Homepage com produtos em destaque da coleção "destaques" (via Storefront API).

**Response:** Renderiza componentes React com ProductCard.

---

### Endpoint: GET /products/:handle

**Descrição:** Página dinâmica de produto.

**Parâmetro:** `handle` (ex: `camiseta-bootcamp-2026`)

**Response:** Página com imagem, preço, variantes, metafields, descrição.

---

### Endpoint: GET /about

**Descrição:** Página "Sobre" que consome conteúdo do AEM via GraphQL.

**Fluxo:**
1. Loader faz POST para `http://localhost:4502/content/graphql/global`
2. Autentica com Basic Auth (`admin:admin`)
3. Retorna produtos com `destaque: true`
4. Renderiza em componentes React

**Response:** Página com conteúdo do AEM ou fallback se offline.

---

## 5️⃣ Resumo de Autenticação

| API | Tipo | Token/Credencial |
|-----|------|------------------|
| Commerce REST | Bearer / None | Token ou sem autenticação |
| AEM GraphQL | Basic Auth | admin:admin (base64) |
| Shopify Storefront | Header Token | `X-Shopify-Storefront-Access-Token` |
| Shopify Admin | Bearer | `X-Shopify-Admin-Access-Token` |

---

## 6️⃣ Verificação de Conectividade

### Testar Commerce
```bash
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq '.items | length'
# Esperado: 5
```

### Testar AEM
```bash
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{ "query": "{ produtoDestaqueList { items { titulo } } }" }' | jq '.data.produtoDestaqueList.items | length'
# Esperado: 5
```

### Testar Shopify
```bash
curl -s -X POST https://seu-store.myshopify.com/api/2024-01/graphql.json \
  -H 'X-Shopify-Storefront-Access-Token: seu-token' \
  -H 'Content-Type: application/json' \
  -d '{ "query": "{ shop { name } }" }' | jq '.data.shop.name'
# Esperado: Nome da loja
```

### Testar Hydrogen (Local)
```bash
curl -s http://localhost:3000 | grep -o '<title>.*</title>'
# Esperado: <title>Bootcamp Hydrogen</title>
```

---

**Última atualização:** Abril 2026
