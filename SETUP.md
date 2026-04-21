# 🚀 SETUP: Bootcamp 2026 - Guia Passo a Passo

Instruções detalhadas para configurar cada componente do projeto.

---

## 📋 Pré-requisitos Verificados

- ✅ **Java 17**: Já instalado (`/usr/bin/java`)
- ✅ **Node.js**: Instalar se não tiver (versão 18+)
- ✅ **Maven**: Instalar se não tiver (versão 3.8+)
- ✅ **Magento 2**: Já configurado (`/home/igors/projects/magento2`)
- ✅ **AEM**: Já configurado (`/home/igors/projects/aem`)

---

## 1️⃣ SETUP: Adobe Commerce (Dias 11-14)

### 1.1 Acessar o Admin

```bash
# Abrir no navegador
open https://app.magento2.test/admin

# Ou via CLI testar
curl -s https://app.magento2.test/admin 2>&1 | head -20
```

**Credenciais:** `admin` / `admin`

### 1.2 Criar Atributos Customizados

#### Atributo 1: bootcamp_highlight

1. **Acessar:** Stores > Attributes > Product Attributes
2. **Click:** Add New Attribute
3. **Preencher:**
   - **Attribute Code:** `bootcamp_highlight`
   - **Input Type:** Yes/No
   - **Scope:** Store View
   - **Use in Product Listing:** Yes
   - **Use in Search Results Layered Navigation:** No
4. **Save**

#### Atributo 2: tech_stack

1. **Click:** Add New Attribute
2. **Preencher:**
   - **Attribute Code:** `tech_stack`
   - **Input Type:** Dropdown
   - **Scope:** Global
   - **Manage Options:**
     - PHP
     - Java
     - JavaScript
     - React
     - Liquid
   - **Required:** No
3. **Save**

### 1.3 Adicionar ao Attribute Set

1. **Acessar:** Stores > Attributes > Attribute Set
2. **Click:** Default
3. **Drag & Drop:** Ambos os atributos para um grupo (ex: "Product Details")
4. **Save**

### 1.4 Criar Estrutura de Categorias

1. **Acessar:** Catalog > Categories
2. **Create New Category:**

```
Loja Bootcamp (Root Category)
├── Vestuário
│   └── Camisetas
├── Acessórios
│   ├── Canecas
│   └── Mochilas
├── Papelaria
│   └── Adesivos
└── Digital
    └── Cursos
```

Para cada categoria:
- **Name:** Preencher
- **Include in Menu:** Yes
- **Meta Title/Description:** Preencher
- **Save**

### 1.5 Criar 5 Produtos

```bash
# Script para criar produtos via API (opcional)
# Usar admin UI: Catalog > Products > Add Product
```

Para cada produto:

#### Produto 1: BOOT-CAM-001

1. **Acessar:** Catalog > Products > Add Product
2. **Atributo:** Set to "Default"
3. **Preencher:**
   - **Name:** Camiseta Bootcamp 2026
   - **SKU:** BOOT-CAM-001
   - **Type:** Configurable Product
   - **Attributes:** Tamanho (P/M/G/GG)
   - **Price:** 89.90
   - **bootcamp_highlight:** Yes
   - **tech_stack:** React
   - **Status:** Enabled
   - **Visibility:** Catalog, Search
   - **Category:** Vestuário > Camisetas
   - **Images:** Upload imagem
4. **Create Variations** (se Configurable)
5. **Save**

Repetir para os outros 4 produtos (BOOT-CAN-002, BOOT-MOC-003, BOOT-KIT-004, BOOT-CUR-005).

### 1.6 Ativar Módulo CatalogApi

```bash
cd /home/igors/projects/magento2

# Copiar módulo
cp -r /home/igors/projects/bootcamp-2026/adobe-commerce/app/code/Bootcamp app/code/

# Ativar
php bin/magento module:enable Bootcamp_CatalogApi
php bin/magento setup:upgrade
php bin/magento cache:flush
```

### 1.7 Testar API

```bash
# Testar com curl
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq

# Esperado: 5 produtos com estrutura:
# {
#   "items": [
#     {
#       "id": 1,
#       "sku": "BOOT-CAM-001",
#       "name": "Camiseta Bootcamp 2026",
#       "price": 89.90,
#       "bootcamp_highlight": true,
#       "tech_stack": "React",
#       ...
#     }
#   ],
#   "total_count": 5
# }
```

---

## 2️⃣ SETUP: AEM (Dia 12)

### 2.1 Acessar AEM Author

```bash
# Abrir no navegador
open http://localhost:4502

# Ou testar via curl
curl -s http://localhost:4502/system/console/status-osgi 2>&1 | head -5
```

**Credenciais:** `admin` / `admin`

### 2.2 Criar Content Fragment Model

1. **Acessar:** Tools > Assets > Content Fragment Models
2. **Create > Create**
3. **Preencher:**
   - **Model Title:** Produto Destaque
4. **Click "Create"**
5. **Adicionar Campos:** (Data Type > field name)
   - **Text** > titulo
   - **Rich Text** > descricao
   - **Number** > preco
   - **Content Reference** > imagem
   - **Enumeration** > categoria (valores: Vestuário, Acessórios, Papelaria, Digital)
   - **Enumeration** > stackTecnologico (valores: PHP, Java, JavaScript, React, Liquid)
   - **Boolean** > destaque
   - **Text** > linkExterno
6. **⚠️ IMPORTANTE:** Click **Enable** (habilitar o modelo)
7. **Save**

### 2.3 Upload de Imagens

1. **Acessar:** Assets > Files > WKND
2. **Criar pasta:** Bootcamp
3. **Criar subfolder:** Produtos
4. **Upload:** As 5 imagens dos produtos

### 2.4 Criar Content Fragments

1. **Acessar:** Assets > Files > WKND > Bootcamp > Produtos
2. **Create > Create Content Fragment**
3. **Preencher:**

**CF-1: Camiseta Bootcamp 2026**
- titulo: "Camiseta Bootcamp 2026"
- descricao: "Camiseta oficial com logo bordado"
- preco: 89.90
- imagem: Selecionar imagem
- categoria: "Vestuário"
- stackTecnologico: "React"
- destaque: true
- linkExterno: "https://app.magento2.test/p/boot-cam-001"
- **Publish**

(Repetir para CF-2 a CF-5)

### 2.5 Testar GraphQL

```bash
# GraphiQL Interface
open http://localhost:4502/content/graphql/global

# Query: Listar todos
query {
  produtoDestaqueList {
    items {
      titulo
      preco
      categoria
      destaque
    }
  }
}

# Query: Filtrar destaques
query {
  produtoDestaqueList(filter: { destaque: { _expressions: [{ value: true }] } }) {
    items {
      titulo
    }
  }
}
```

**Esperado:** 5 produtos no primeiro query, 3 no segundo.

### 2.6 Criar Persisted Query

```bash
curl -X PUT 'http://localhost:4502/graphql/persist.json/wknd/bootcamp-products' \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{
    "query": "{ produtoDestaqueList { items { titulo preco categoria stackTecnologico destaque descricao { plaintext } } } }"
  }'

# Esperado: {"status":"ok","queryId":"wknd/bootcamp-products"}
```

---

## 3️⃣ SETUP: Shopify (Dia 13)

### 3.1 Criar Shopify Store

1. **Acessar:** https://www.shopify.com/
2. **Sign Up** e criar loja de teste
3. **Obter credenciais:**
   - Store domain: `seu-store.myshopify.com`
   - Storefront API token (em Settings > Apps and integrations > Develop apps)

### 3.2 Criar Metafield Definitions

1. **Acessar Shopify Admin:** https://seu-store.myshopify.com/admin
2. **Settings > Custom data > Metafields > Products**
3. **Create definition:**

**Definição 1:**
- Namespace: `custom`
- Key: `tech_stack`
- Type: Single line text
- Storefront access: Enabled

**Definição 2:**
- Namespace: `custom`
- Key: `highlight_badge`
- Type: Single line text
- Storefront access: Enabled

**Definição 3:**
- Namespace: `custom`
- Key: `bootcamp_year`
- Type: Integer (min: 2020, max: 2030)
- Storefront access: Enabled

### 3.3 Criar 5 Produtos

1. **Products > Add product**
2. **Para cada produto:** preencher title, preço, imagem, metafields
3. **Publicar**

### 3.4 Criar Coleções

1. **Collections > Create collection**
2. **Tipo:** Manual
3. **Adicionar produtos:**
   - Destaques (3 produtos)
   - Vestuário (camiseta)
   - Acessórios (caneca, mochila)
   - Digital (curso)

### 3.5 Adicionar Seção ao Tema

1. **Online Store > Themes > Customize**
2. **Add section > Bootcamp Products** (após copiar arquivo liquid)
3. **Configure:** Coleção "Destaques"
4. **Save**

---

## 4️⃣ SETUP: Shopify Hydrogen (Dia 16)

### 4.1 Inicializar Projeto

```bash
cd /home/igors/projects/bootcamp-2026/shopify-hydrogen

# Criar novo projeto Hydrogen
npx @shopify/create-hydrogen@latest bootcamp-hydrogen

cd bootcamp-hydrogen
```

### 4.2 Configurar Ambiente

```bash
# Copiar exemplo
cp .env.example .env

# Editar .env
nano .env
# OU
code .env

# Preencher:
# PUBLIC_STOREFRONT_API_TOKEN=seu-token
# PUBLIC_STORE_DOMAIN=seu-store.myshopify.com
```

### 4.3 Instalar Dependências e Rodar

```bash
npm install

# Desenvolvimento
npm run dev

# Acessar: http://localhost:3000
```

---

## 5️⃣ SETUP: Integração Completa (Dia 15 e 17)

### 5.1 Ativar Módulo AemContent no Commerce

```bash
cd /home/igors/projects/magento2

# Copiar módulo
cp -r /home/igors/projects/bootcamp-2026/adobe-commerce/app/code/Bootcamp/AemContent app/code/Bootcamp/

# Ativar
php bin/magento module:enable Bootcamp_AemContent
php bin/magento setup:upgrade
php bin/magento cache:flush
```

### 5.2 Adicionar Banner AEM na Homepage

1. **Admin:** Content > Pages > Home
2. **Edit with Page Builder**
3. **Add Block > AEM Banner**
4. **Save & Publish**

### 5.3 Criar Página /about no Hydrogen

```bash
# Copiar arquivo de exemplo
cp /home/igors/projects/bootcamp-2026/shopify-hydrogen/about.jsx.example app/routes/about.jsx

# Editar se necessário
code app/routes/about.jsx

# Recarregar: http://localhost:3000/about
```

---

## ✅ Verificação Final

### Checklist de Integração

```bash
# 1. Commerce API respondendo
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq '.total_count'
# Esperado: 5

# 2. AEM GraphQL respondendo
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{"query":"{ produtoDestaqueList { items { titulo } } }"}' | jq '.data.produtoDestaqueList.items | length'
# Esperado: 5

# 3. Hydrogen rodando
curl -s http://localhost:3000 | grep -o '<title>.*</title>'
# Esperado: contém "Bootcamp"

# 4. Shopify Storefront API (substitua values)
curl -X POST https://seu-store.myshopify.com/api/2024-01/graphql.json \
  -H 'X-Shopify-Storefront-Access-Token: seu-token' \
  -H 'Content-Type: application/json' \
  -d '{"query":"{ shop { name } }"}' | jq '.data.shop.name'
# Esperado: nome da loja
```

---

## 🐛 Troubleshooting

| Problema | Solução |
|----------|---------|
| Commerce API retorna 404 | Verificar módulo: `php bin/magento module:status` |
| AEM GraphQL retorna erro auth | Tentar com `-u admin:admin` no curl |
| Hydrogen não conecta Shopify | Verificar `.env` com tokens corretos |
| Port 4502 recusada | Iniciar AEM: `docker-compose up -d` |
| Port 3000 ocupada | `lsof -i :3000` e matar processo ou usar outra porta |

---

## 📞 Próximos Passos

1. ✅ Seguir este guia passo a passo
2. ✅ Marcar checkboxes no [checklist.md](checklist.md)
3. ✅ Consultar [endpoints.md](endpoints.md) para testes específicos
4. ✅ Referir [arquitetura.md](arquitetura.md) para entender fluxos

**Tempo estimado:** 40-60 horas (7 dias de bootcamp intensivo)

---

**Última atualização:** Abril 2026
