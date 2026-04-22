# 🎯 Gerar Admin API Token Shopify - Guia Atualizado 2026

**Domínio Shopify:** `qdt02k-t4.myshopify.com`

⚠️ **IMPORTANTE 2026:** Shopify mudou seu modelo de autenticação em janeiro de 2026. Existem 2 fluxos possíveis:

---

## 🔄 QUAL FLUXO VOCÊ USA?

### ✅ Opção A: Custom App (LEGACY - Ainda Funciona)
**Quando:** Sua loja ainda mostra "Create custom app" no Admin
**Token:** `shpat_...` (estático, fácil de copiar)
**Usar:** [Guia Opção A abaixo](#-opção-a-custom-app-legacy)

### ✅ Opção B: App via Dev Dashboard (NOVO - Padrão 2026)
**Quando:** Você vê "Develop apps" ou "Dev Dashboard"
**Token:** Client ID + Client Secret (OAuth / Credentials Flow)
**Usar:** [Guia Opção B abaixo](#-opção-b-oauth--credentials-flow-novo)

---

## 📋 Opção A: Custom App (LEGACY)

✅ **SE** você conseguir acessar e criar um custom app, use este fluxo.

### 1️⃣ Ir para Custom Apps

```
https://qdt02k-t4.admin.shopify.com/settings/apps-and-integrations/apps-and-sales-channels
```

Procure por **"Develop apps"** na barra lateral.

Se encontrar uma opção **"Create custom app"**, clique aqui e pule para o passo 3.

---

### 2️⃣ Se não tiver Custom Apps

Se a opção **"Create custom app"** não existir, significa sua loja usa o novo modelo (Opção B). Vá para [Opção B](#-opção-b-oauth--credentials-flow-novo).

---

### 3️⃣ Criar Custom App

Clique em **"Create custom app"** ou **"Create an app"**

**Nome:** `Bootcamp Setup`

---

### 4️⃣ Configurar Escopos

Na aba **"Admin API scopes"**, marque:
- ✅ `write_products`
- ✅ `write_product_listings`
- ✅ `write_inventory`
- ✅ `write_collections`
- ✅ `write_metafield_definitions`
- ✅ `write_metafields`

Clique em **"Save"**.

---

### 5️⃣ Instalar e Copiar Token

1. Clique em **"Install app"**
2. Na aba **"API credentials"** ou **"API Keys"**
3. Procure por **"Admin API access token"**
4. Clique em **"Reveal"** e **copie** (começa com `shpat_`)

```javascript
// Configure no script:
const ADMIN_TOKEN = "shpat_XXXXXXXXXXXXX";
```

---

## 🔐 Opção B: OAuth + Credentials Flow (NOVO)

✅ **SE** você criou no Dev Dashboard, use este fluxo.

### 1️⃣ Obter Client ID e Client Secret

```
https://qdt02k-t4.admin.shopify.com/settings/apps-and-integrations/develop-apps
```

Clique na sua app "Bootcamp Setup":

1. Vá para **"Configuration"**
2. Procure por **"Admin API credentials"** (não "access token")
3. Você vai ver:
   - **Client ID:** `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - **Client Secret:** `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

📋 **Copie os dois valores!**

---

### 2️⃣ Instalar a App

1. Clique em **"Install app"**
2. Autorize os escopos (mesmos de antes)

---

### 3️⃣ Gerar Access Token Offline

Agora você precisa gerar um **access token** programaticamente.

**Instale o Shopify CLI (mais fácil):**

```bash
# No seu computador/WSL
npm install -g @shopify/cli @shopify/theme

# Gere um token
shopify app generate-credentials

# Ou via cURL (mais manual):
curl -X POST https://qdt02k-t4.myshopify.com/admin/oauth/access_token \
  -H "Content-Type: application/json" \
  -d '{
    "client_id": "SEU_CLIENT_ID",
    "client_secret": "SEU_CLIENT_SECRET",
    "grant_type": "client_credentials",
    "scope": "write_products,write_collections,write_metafields"
  }'
```

Você vai receber um JSON com o **access_token** (novo formato, ainda começa com `shpat_` ou similar).

---

### 4️⃣ Configurar no Script

```javascript
// Use o token que recebeu
const ADMIN_TOKEN = "shpat_NOVO_TOKEN_AQUI";
```

---

## ⚡ Solução Rápida (Recomendada)

Se não conseguir nada acima, use **Shopify CLI** (automático):

```bash
# Instalar
npm install -g @shopify/cli

# Na pasta do seu projeto
cd /home/igors/projects/bootcamp-2026/scripts

# Gera credenciais automaticamente
shopify app generate-credentials

# Mostra o token direto no terminal
```

Copie o token para o script.

---

## ⚠️ NÃO Confunda Com Outras Chaves!

**Você pode encontrar estas chaves, MAS NÃO são o que precisamos:**

❌ **"Default API Key"** (Chaves de API legada)
- Aparece em: Settings → Custom data → **API keys**
- Formato: `d461508c3144e33b8fbebaf3e5618164` (apenas números/letras)
- ❌ NÃO FUNCIONA com o script

✅ **Admin API Access Token** (Isso sim!)
- Aparece em: Develop apps → Configuration → **API credentials**
- Formato: `shpat_...` (começa com `shpat_`)
- ✅ FUNCIONA com o script

---

## ✅ Testar Configuração

```bash
cd /home/igors/projects/bootcamp-2026/scripts

# Editar com seu token (DEVE começar com shpat_)
nano setup_shopify.js

# Executar
node setup_shopify.js
```

**Esperado:**
```
🛍️  Criando produtos...
   ✅ Camiseta Bootcamp 2026
   ✅ Caneca Developer
   ...
✅ SETUP SHOPIFY CONCLUÍDO!
```

---

## 🐛 Troubleshooting

| Erro | Causa | Solução |
|------|-------|---------|
| `401 Unauthorized` | Token inválido/expirado | Gere um novo token |
| `Invalid Client Credentials` | Client ID/Secret incorreto | Copie novamente de Configuration |
| `fetch is not defined` | Node.js antigo | Instale Node 18+: `nvm install 18` |
| Sem botão "Reveal" | Novo modelo (Opção B) | Use OAuth flow acima |
| `ECONNREFUSED` | Sem internet | Verifique conexão |

---

## 📍 Links Úteis

- **Shopify Admin:** https://qdt02k-t4.admin.shopify.com
- **Develop Apps:** https://qdt02k-t4.admin.shopify.com/settings/apps-and-integrations/develop-apps
- **Shopify API Docs:** https://shopify.dev/docs/api/admin-rest
- **CLI Docs:** https://shopify.dev/docs/apps/tools/cli

---

**⏰ Resumo:**
1. Tentar **Opção A** (mais fácil)
2. Se não funcionar, usar **Opção B** (OAuth)
3. Se ainda não conseguir, usar **Shopify CLI** (automático)

🚀 **Uma vez com o token, execute `node setup_shopify.js` e pronto!**
