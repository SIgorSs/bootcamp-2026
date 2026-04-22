# 📋 Guia de Execução dos Scripts de Setup

Scripts automáticos para configurar Adobe Commerce, AEM e Shopify com 5 produtos each.

---

## 📋 Pré-requisitos

### Adobe Commerce (WSL)
- ✅ Magento 2 rodando em `https://app.magento2.test`
- ✅ Acesso Admin (usuário: `admin`, senha: `admin123`)
- ✅ `curl` instalado

### AEM (Windows)
- ✅ AEM rodando em `http://localhost:4502`
- ✅ Python 3 com `requests` instalado
- ✅ Acesso (usuário: `admin`, senha: `admin`)

### Shopify
- ✅ Conta de desenvolvedor Shopify
- ✅ App customizado criado
- ✅ Admin API Token gerado (com scopes corretos)
- ✅ Node.js 18+ instalado

---

## 🚀 Como Executar

### 1️⃣ Adobe Commerce (Executar no WSL)

#### a) Preparar o script
```bash
cd /home/igors/projects/bootcamp-2026/scripts

# Ver o conteúdo
cat setup_commerce.sh
```

#### b) Editar a senha (se necessário)
```bash
# Abrir o arquivo
nano setup_commerce.sh

# Procurar por:
ADMIN_PASS="admin123"  # ← Altere se sua senha é diferente

# Salvar: CTRL+O, ENTER, CTRL+X
```

#### c) Dar permissão e executar
```bash
chmod +x setup_commerce.sh

# Executar
./setup_commerce.sh
```

**Esperado:**
```
✅ bootcamp_highlight criado!
✅ tech_stack criado!
✅ Categorias criadas
✅ 5 produtos criados
```

#### d) Testar
```bash
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq

# Deve retornar um JSON com 5 produtos (BOOT-*)
```

---

### 2️⃣ AEM (Executar no Windows ou WSL com acesso localhost:4502)

#### a) Instalar dependência Python
```bash
pip install requests
```

#### b) Verificar se AEM está acessível
```bash
curl -s http://localhost:4502 -u admin:admin | head -20

# Se retornar HTML, está OK
```

#### c) Executar o script
```bash
cd /home/igors/projects/bootcamp-2026/scripts

chmod +x setup_aem.py
python3 setup_aem.py
```

**Esperado:**
```
✅ Pastas criadas
✅ 5 Content Fragments criados
✅ GraphQL testado
```

#### d) ⚠️ AÇÃO MANUAL NECESSÁRIA
1. Acesse: `http://localhost:4502/libs/dam/gui/content/cfm/admin.html`
2. Procure por "Produto Destaque"
3. Clique no botão "Enable"
4. Aguarde recarregar

#### e) Testar GraphQL
```bash
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{"query": "{ produtoDestaqueList { items { titulo preco destaque } } }"}'

# Deve retornar 5 produtos com destaque
```

---

### 3️⃣ Shopify (Executar no Windows ou WSL)

#### ⚠️ IMPORTANTE: Obter o Admin API Token

**Você passou credenciais Webhook, mas precisa do Admin API Token!**

**Para gerar o token correto:**

1. **Acesse Shopify Admin:**
   - https://seu-store.myshopify.com/admin

2. **Settings → Apps and sales channels**

3. **Develop apps → Create an app**
   - Nome: `Bootcamp Setup`
   - Clique em: Create app

4. **Configuration → Admin API scopes**
   - Marque ✅:
     - `write_products`
     - `write_product_listings`
     - `write_inventory`
     - `write_collections`
     - `write_metafield_definitions`
     - `write_metafields`
   - Clique: Save

5. **Install app**
   - Clique: Install app
   - Confirm

6. **Reveal token**
   - Clique em: Reveal token
   - Copie o token (começa com `shpat_`)

#### a) Editar o script com o token correto
```bash
cd /home/igors/projects/bootcamp-2026/scripts

nano setup_shopify.js
```

Procure por:
```javascript
const SHOP_DOMAIN = "sua-loja.myshopify.com";
const ADMIN_TOKEN = "shpat_SEU_ADMIN_API_TOKEN_AQUI";
```

Altere para:
```javascript
const SHOP_DOMAIN = "sua-loja.myshopify.com";  // ex: "techstore.myshopify.com"
const ADMIN_TOKEN = "shpat_xxxxxxxxxxx";        // Token que você copiou
```

Salve: `CTRL+O, ENTER, CTRL+X`

#### b) Instalar dependência Node (se necessário)
```bash
# Node 18+ já tem fetch nativo, mas se quiser ter certeza:
npm install -g node-fetch
```

#### c) Executar o script
```bash
node setup_shopify.js
```

**Esperado:**
```
✅ Produtos criados
✅ Coleções criadas
✅ 5 produtos + 4 coleções
```

#### d) Testar
```bash
curl -X POST https://sua-loja.myshopify.com/api/2024-01/graphql.json \
  -H 'Content-Type: application/json' \
  -H 'X-Shopify-Storefront-Access-Token: seu-token' \
  -d '{"query": "{ products(first: 5) { edges { node { title } } } }"}'
```

---

## ✅ Ordem Recomendada

```
1. ./setup_commerce.sh    (Commerce com 5 produtos)
2. python3 setup_aem.py   (AEM com 5 fragments)
3. node setup_shopify.js  (Shopify com 5 produtos + 4 coleções)
```

---

## 🔍 Verificação Completa

### Commerce
```bash
curl -s https://app.magento2.test/rest/V1/bootcamp/products | python3 -m json.tool
# → 5 produtos com sku BOOT-*
```

### AEM GraphQL
```bash
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{"query": "{ produtoDestaqueList { items { titulo } } }"}'
# → 5 fragments
```

### Shopify Storefront API
```bash
curl -X POST https://sua-loja.myshopify.com/api/2024-01/graphql.json \
  -H 'Content-Type: application/json' \
  -H 'X-Shopify-Storefront-Access-Token: seu-token-storefront' \
  -d '{"query": "{ products(first: 5) { edges { node { title } } } }"}'
# → 5 produtos
```

---

## ⚠️ Troubleshooting

### Commerce
| Erro | Solução |
|------|---------|
| `Connection refused` | Verificar se Magento está rodando: `curl -I https://app.magento2.test` |
| `Unauthorized (401)` | Verificar senha do admin em `setup_commerce.sh` |
| `404 Not Found` | Verificar se URL está correta em `setup_commerce.sh` |

### AEM
| Erro | Solução |
|------|---------|
| `ModuleNotFoundError: requests` | Instalar: `pip install requests` |
| `Connection refused` | Verificar se AEM está rodando: `curl http://localhost:4502` |
| `GraphQL retorna erro` | Habilitar o Content Fragment Model manualmente (passo 4.d) |

### Shopify
| Erro | Solução |
|------|---------|
| `401 Unauthorized` | Verificar se token está correto (não use Webhook Secret!) |
| `Cannot find module 'node-fetch'` | Node 18+ tem fetch nativo, ou instale: `npm install node-fetch` |
| `SHOP_DOMAIN não configurado` | Editar script e colocar sua loja |

---

## 📄 O que cada script cria

### setup_commerce.sh
- ✅ Atributo `bootcamp_highlight` (Yes/No)
- ✅ Atributo `tech_stack` (Dropdown)
- ✅ 4 Categorias (Vestuário, Acessórios, Papelaria, Digital)
- ✅ 5 Produtos com atributos customizados

### setup_aem.py
- ✅ Pasta `/content/dam/wknd/bootcamp/produtos`
- ✅ 5 Content Fragments com campos:
  - titulo, descricao, preco, categoria, stackTecnologico, destaque
- ✅ Testa GraphQL query

### setup_shopify.js
- ✅ 5 Produtos com variantes, metafields e preços
- ✅ 4 Coleções (Destaques, Vestuário, Acessórios, Digital)
- ✅ Metafields com Storefront access habilitado

---

## 📍 Próximos passos após os scripts

1. **Commerce:**
   - Ir ao Admin e conferir os produtos
   - Testar API: `/rest/V1/bootcamp/products`

2. **AEM:**
   - Habilitar o Content Fragment Model
   - Acessar GraphQL Editor

3. **Shopify:**
   - Adicionar seção na homepage:
     - Online Store > Themes > Customize > Add section > Bootcamp Products
   - Gerar Storefront Access Token para o Hydrogen

4. **Hydrogen:**
   - Configurar `.env` com tokens Shopify e URLs de Commerce/AEM
   - Rodar: `npm install && npm run dev`

---

**Todos os scripts estão prontos!** 🚀
