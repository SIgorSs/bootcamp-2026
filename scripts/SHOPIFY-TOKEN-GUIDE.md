# 🎯 Gerar Admin API Token Shopify - Guia Atualizado 2026

**Domínio Shopify:** `qdt02k-t4.myshopify.com`

📌 **Fonte Oficial:** https://help.shopify.com (Documentação oficial Shopify 2026)

⚠️ **IMPORTANTE 2026:** Shopify mudou seu modelo de autenticação em janeiro de 2026. A partir dessa data:

- ❌ Apps novos **não** aparecem mais no admin com token estático para copiar
- ✅ Apps novos **precisam** gerar token via OAuth (Client Credentials Flow)
- ✅ Apps antigos (pré-janeiro 2026) ainda podem ter token estático

Existem 2 cenários possíveis:

---

## 🔄 QUAL FLUXO VOCÊ USA?

### 📅 App Criado ANTES de Janeiro 2026?
**Token:** `shpat_...` (estático, fácil de copiar)
→ [Opção A: Custom App ANTIGO](#-opção-a-custom-app-antigo-pré-janeiro-2026)

### 📅 App Criado DEPOIS de Janeiro 2026?
**Token:** Gera via OAuth (Client ID + Secret)
→ [Opção B: App Novo via Dev Dashboard](#-opção-b-custom-app-novo-pós-janeiro-2026)

### ❓ Não sabe quando foi criado?
**Teste:** Vá em Admin → Settings → Develop apps → [Seu app] → Credenciais da API
- Se aparecer botão **"Revelar token"** → Use Opção A
- Se aparecer **"Client ID"** e **"Client Secret"** → Use Opção B

---

## 📋 Opção A: Custom App ANTIGO (Pré-Janeiro 2026)

✅ **APLICA SE:** Você tem um app criado antes de janeiro de 2026

Neste caso, o token estático ainda está disponível no admin.

### 1️⃣ Ir para Admin da Shopify

```
https://qdt02k-t4.admin.shopify.com
```

### 2️⃣ Configurações → Apps e canais de vendas

Na barra lateral esquerda, clique em **"Apps e canais de vendas"**

### 3️⃣ Desenvolver apps

Clique em **"Desenvolver apps"**

### 4️⃣ Selecionar seu app

Clique no nome da app que criou (ex: "Bootcamp Setup")

### 5️⃣ Credenciais da API → Revelar token

1. Vá para aba **"Credenciais da API"**
2. Procure por **"Token de acesso da API Admin"**
3. Clique em **"Revelar token"**
4. **Copie o token** (começa com `shpat_`)

```javascript
// Configure no script:
const ADMIN_TOKEN = "shpat_XXXXXXXXXXXXX";
```

---

## 📋 Opção B: Custom App NOVO (Pós-Janeiro 2026)

## 📋 Opção B: Custom App NOVO (Pós-Janeiro 2026)

✅ **APLICA SE:** Você criou a app após janeiro 2026

**Fluxo oficial Shopify 2026:**
1. Acessar Dev Dashboard (dev.shopify.com)
2. Obter Client ID + Client Secret
3. Gerar token programaticamente via OAuth (Client Credentials Flow)
4. Usar o token gerado no script

⚠️ **Importante:** O token **não fica visível para copiar diretamente no admin** — precisa ser gerado via API.

### Método 1️⃣: Usar Shopify CLI (RECOMENDADO)

Mais fácil, automático:

```bash
npm install -g @shopify/cli @shopify/theme

shopify app generate-credentials --shop qdt02k-t4.myshopify.com
```

O CLI vai:
1. Abrir navegador (autorizar)
2. Gerar token automaticamente
3. Mostrar o token no terminal

Copie o token (começa com `shpat_`)

### Método 2️⃣: Manual via cURL

Se preferir fazer manualmente:

#### Passo 1: Obter Client ID + Client Secret

1. Acesse: https://dev.shopify.com
2. Selecione sua app "Bootcamp Setup"
3. Vá em **Settings** → **Credentials**
4. Copie:
   - **Client ID**
   - **Client Secret**

#### Passo 2: Gerar Token

```bash
curl -X POST https://qdt02k-t4.myshopify.com/admin/oauth/access_token \
  -H "Content-Type: application/json" \
  -d '{
    "client_id": "SEU_CLIENT_ID",
    "client_secret": "SEU_CLIENT_SECRET",
    "grant_type": "client_credentials",
    "scope": "write_products,write_product_listings,write_inventory,write_collections,write_metafield_definitions,write_metafields"
  }'
```

**Resposta esperada:**
```json
{
  "access_token": "shpat_XXXXXXXXXXXXXXXXXXXX",
  "scope": "write_products,write_product_listings,..."
}
```

Copie o `access_token`

---

---

## ⚠️ NÃO Confunda Com Outras Chaves!

**Você pode encontrar estas chaves, MAS NÃO são o que precisamos:**

❌ **"Default API Key"** (Chaves de API legada)
- Aparece em: Settings → Custom data → API keys
- Formato: `d461508c3144e33b8fbebaf3e5618164`
- ❌ NÃO FUNCIONA

❌ **Webhook Secret** (Webhook config)
- Formato: `shpss_...` (começa com `shpss_`)
- ❌ NÃO FUNCIONA

✅ **Admin API Access Token** (ESSA SIM!)
- Formato: `shpat_...` (começa com `shpat_`)
- ✅ FUNCIONA com o script

**Fonte:** Documentação oficial Shopify, abril 2026

---

## ✅ Resumo Prático

| Cenário | Solução |
|---------|---------|
| **App criada antes de Jan 2026** | Opção A: Copiar token do admin |
| **App criada depois de Jan 2026** | Opção B: Gerar via Shopify CLI ou cURL |
| **Sem certeza** | Use nosso `shopify-token-wizard.sh` (automático) |

---

## 🚀 Próximo Passo

Após obter o token (qualquer método):

```bash
cd /home/igors/projects/bootcamp-2026/scripts

# Opção 1: Usar nosso wizard (RECOMENDADO)
./shopify-token-wizard.sh

# Opção 2: Configurar manualmente
nano setup_shopify.js
# Altere: const ADMIN_TOKEN = "shpat_SEU_TOKEN_AQUI";

# Depois executar
node setup_shopify.js
```

**Esperado:**
```
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

✅ SETUP SHOPIFY CONCLUÍDO!
```

---

## 🐛 Troubleshooting

| Erro | Causa | Solução |
|------|-------|---------|
| `401 Unauthorized` | Token inválido/expirado | Gere um novo token |
| `Invalid Client Credentials` | Client ID/Secret errado | Copie novamente |
| `fetch is not defined` | Node antigo | Instale Node 18+: `nvm install 18` |
| `ECONNREFUSED` | Sem internet | Verifique conexão |
| "Não vejo botão Reveal" | App nova (pós-Jan 2026) | Use Opção B (CLI/cURL) |

---

## 📍 Links Úteis

- **Shopify Admin:** https://qdt02k-t4.admin.shopify.com
- **Dev Dashboard:** https://dev.shopify.com
- **API Docs:** https://shopify.dev/docs/api/admin-rest
- **CLI Docs:** https://shopify.dev/docs/apps/tools/cli
- **Help Shopify:** https://help.shopify.com

---

🔐 **Seu token é sensível — nunca compartilhe nem commite no git!**


