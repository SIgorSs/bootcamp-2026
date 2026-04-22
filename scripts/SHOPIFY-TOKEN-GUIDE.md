# 🎯 Passo a Passo: Gerar Admin API Token Shopify

**Domínio Shopify:** `qdt02k-t4.myshopify.com`

---

## 1️⃣ Acessar Shopify Admin

```
https://qdt02k-t4.admin.shopify.com
```

Ou use:
```
https://admin.shopify.com
```
(Shopify vai redirecionar para sua loja)

---

## 2️⃣ Navegar para Develop Apps

Na barra lateral esquerda:
1. Procure por **"Apps and sales channels"**
2. Clique nele
3. Procure por **"Develop apps"** 
4. Clique em **"Develop apps"**

**Link direto:**
```
https://qdt02k-t4.admin.shopify.com/settings/apps-and-integrations/develop-apps
```

---

## 3️⃣ Criar Nova App

Clique no botão **"Create an app"** (canto superior direito)

**Na janela que abrir:**
- **App name:** `Bootcamp Setup`
- Clique em **"Create app"**

---

## 4️⃣ Configurar Admin API Scopes

Na página da app:
1. Vá para a aba **"Configuration"**
2. Desça até a seção **"Admin API scopes"**
3. **Marque ✅ todas estas:**
   - ✅ `write_products`
   - ✅ `write_product_listings`
   - ✅ `write_inventory`
   - ✅ `write_collections`
   - ✅ `write_metafield_definitions`
   - ✅ `write_metafields`

4. Clique em **"Save"** (canto inferior direito)

---

## 5️⃣ Instalar a App

1. Na página da app, clique em **"Install app"** (canto superior direito)
2. Uma janela vai pedir confirmação
3. Clique em **"Install"** de novo

---

## 6️⃣ Copiar o Token

1. Na página da app (após instalar), vá para a aba **"API credentials"**
2. Procure por **"Admin API access tokens"**
3. Clique em **"Reveal token"**
4. **Copie o token** (é uma string começando com `shpat_`)

**Exemplo do que você vai ver:**
```
shpat_1234567890abcdefghijklmnopqrstuvwxyz
```

---

## 7️⃣ Configurar o Script

Abra o arquivo do script:

```bash
nano /home/igors/projects/bootcamp-2026/scripts/setup_shopify.js
```

Procure pelas primeiras linhas:

```javascript
const SHOP_DOMAIN = "sua-loja.myshopify.com";
const ADMIN_TOKEN = "shpat_SEU_ADMIN_API_TOKEN_AQUI";
```

**Substitua por:**

```javascript
const SHOP_DOMAIN = "qdt02k-t4.myshopify.com";
const ADMIN_TOKEN = "shpat_COLE_O_TOKEN_AQUI";
```

**Como salvar:**
- Pressione: `CTRL+O`
- Pressione: `ENTER`
- Pressione: `CTRL+X`

---

## 8️⃣ Executar o Script

```bash
cd /home/igors/projects/bootcamp-2026/scripts

node setup_shopify.js
```

**Você deve ver:**
```
==================================================
  BOOTCAMP 2026 - Setup Shopify
==================================================

🛍️  Criando produtos...
   ✅ Camiseta Bootcamp 2026
   ✅ Caneca Developer
   ✅ Mochila Tech
   ✅ Kit Adesivos Dev
   ✅ Curso Online Adobe Commerce

📁 Criando coleções...
   ✅ Destaques
   ✅ Vestuário
   ✅ Acessórios
   ✅ Digital

==================================================
  ✅ SETUP SHOPIFY CONCLUÍDO!
==================================================
```

---

## ✅ Verificar se Funcionou

1. **Ir ao Shopify Admin:** https://qdt02k-t4.admin.shopify.com
2. **Products** → Deve ter 5 novos produtos
3. **Collections** → Deve ter 4 novas coleções
4. **Settings → Custom data → Metafields → Products** → Deve ter 3 novos metafields

---

## ⚠️ Se Não Funcionou

| Problema | Solução |
|----------|---------|
| `401 Unauthorized` | Token incorreto. Gere um novo seguindo os passos acima. |
| `Invalid Shop Domain` | Certifique-se que está: `qdt02k-t4.myshopify.com` (não `myshopify.com` só) |
| `fetch is not defined` | Instale: `npm install -g node-fetch` |
| `Connection refused` | Verifique sua internet |
| App não aparece em "Develop apps" | Recarregue a página (F5) |

---

## 📍 Links Úteis

- **Shopify Admin:** https://qdt02k-t4.admin.shopify.com
- **Develop Apps:** https://qdt02k-t4.admin.shopify.com/settings/apps-and-integrations/develop-apps
- **Shopify Docs:** https://shopify.dev/api/admin-rest

---

**Pronto! Após gerar o token e configurar o script, execute e tudo será criado automaticamente!** 🚀
