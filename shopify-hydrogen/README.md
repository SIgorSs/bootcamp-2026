# Shopify Hydrogen - Bootcamp

## 🚀 Quick Start

### 1. Inicializar Projeto

```bash
cd /home/igors/projects/bootcamp-2026/shopify-hydrogen

# Criar novo projeto Hydrogen (ou usar existente)
npx @shopify/create-hydrogen@latest bootcamp-hydrogen

cd bootcamp-hydrogen
```

### 2. Configurar Ambiente

```bash
# Copiar template
cp .env.example .env

# Editar com seus valores
nano .env
# OU
code .env

# Valores necessários:
# PUBLIC_STOREFRONT_API_TOKEN=seu-token-aqui
# PUBLIC_STORE_DOMAIN=seu-store.myshopify.com
# SESSION_SECRET=sua-secret-key
```

### 3. Instalar e Rodar

```bash
# Instalar dependências
npm install

# Desenvolvimento
npm run dev

# Acessar: http://localhost:3000
```

---

## 📁 Estrutura

```
bootcamp-hydrogen/
├── app/
│   ├── routes/
│   │   ├── _index.jsx (Homepage - Destaques)
│   │   ├── products.$handle.jsx (Página de Produto)
│   │   ├── about.jsx (Conteúdo AEM)
│   │   └── root.jsx (Layout principal)
│   │
│   ├── components/
│   │   ├── ProductCard.jsx (Cartão de produto)
│   │   ├── Layout.jsx
│   │   └── ...
│   │
│   └── styles/
│       └── bootcamp.css (Estilos globais)
│
├── .env.example
├── .env (não commitare)
├── package.json
└── hydrogen.config.js
```

---

## 🔗 Rotas Implementadas

### GET `/` (Homepage)

**O quê:**
- Busca coleção "destaques" via Storefront API
- Renderiza componente ProductCard
- Exibe: imagem, nome, preço, tech_stack, highlight_badge

**Loader:**
```javascript
export async function loader({context}) {
  const {collection} = await storefront.query(DESTAQUES_QUERY, {
    variables: {handle: 'destaques', first: 4}
  });
  return {collection};
}
```

---

### GET `/products/:handle` (Página de Produto)

**O quê:**
- Busca produto específico pelo handle
- Renderiza detalhes: imagem, preço, variantes, metafields, descrição
- Se não encontrado: 404

**Loader:**
```javascript
export async function loader({context, params}) {
  const {product} = await storefront.query(PRODUCT_QUERY, {
    variables: {handle: params.handle}
  });
  if (!product) throw new Response(null, {status: 404});
  return {product};
}
```

---

### GET `/about` (Conteúdo AEM)

**O quê:**
- Faz POST para `http://localhost:4502/content/graphql/global`
- Autentica com Basic Auth (admin:admin)
- Busca produtos com `destaque: true`
- Fallback se AEM offline

**Loader:**
```javascript
export async function loader({context}) {
  try {
    const response = await fetch(
      'http://localhost:4502/content/graphql/global',
      {
        method: 'POST',
        headers: {
          'Authorization': `Basic ${btoa('admin:admin')}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({query: AEM_QUERY})
      }
    );
    if (!response.ok) throw new Error('AEM offline');
    const data = await response.json();
    return {
      products: data.data.produtoDestaqueList.items,
      source: 'aem-live'
    };
  } catch (error) {
    return {
      products: FALLBACK_PRODUCTS,
      source: 'aem-static',
      error: error.message
    };
  }
}
```

---

## 🧪 Componentes

### ProductCard

**Props:**
- `product` - Objeto do Shopify
- `highlight` - String (ex: "⭐ Destaque")
- `techStack` - String (ex: "React")

**Renderiza:**
- Imagem com lazy load
- Título e descrição
- Preço e desconto
- Metafields
- Link para página de produto

---

### Layout

**Estrutura:**
- Header com navegação
- Main (rotas)
- Footer

---

## 🎨 Estilos

**Arquivo:** `app/styles/bootcamp.css`

**Variáveis CSS:**
```css
--color-primary: #667eea
--color-secondary: #764ba2
--color-badge: #ffcc00
--spacing-unit: 1rem
```

**Classes principais:**
- `.container` - Max-width 1200px
- `.grid` - Grid responsivo
- `.btn` - Botões
- `.product-card` - Card de produto

---

## 🚀 Build para Produção

```bash
# Build otimizado
npm run build

# Preview produção
npm run preview

# Deploy (depende do seu host)
# Vercel, Netlify, Oxygen, etc.
```

---

## 🔗 Integração com Outros Serviços

### Shopify (Storefront API)
- ✅ Busca produtos, coleções
- ✅ Suporta metafields
- ✅ Carrinho e checkout

### Commerce (REST API - Opcional)
- ✅ Loader pode buscar `/rest/V1/bootcamp/products`
- ✅ Fallback se offline

### AEM (GraphQL)
- ✅ /about busca Content Fragments
- ✅ Basic Auth (admin:admin)
- ✅ Fallback se offline

---

## 📚 Documentação

- [Hydrogen Docs](https://hydrogen.shopify.dev/)
- [Shopify Storefront API](https://shopify.dev/api/storefront)
- [React Router (Remix)](https://remix.run/)

---

## 🐛 Troubleshooting

| Problema | Solução |
|----------|---------|
| Port 3000 já em uso | Matar processo: `lsof -i :3000` e `kill -9 PID` |
| Shopify API erro | Verificar `.env` com tokens corretos e domínio |
| AEM offline | Fallback automático, verificar `source` no /about |
| Imagens não carregam | Verificar URLs e permissões CORS |
| Variantes não aparecem | Verificar se produto no Shopify tem variantes criadas |

---

## 🎯 Next Steps

1. ✅ Copiar arquivos de exemplo: `*.jsx.example` → `*.jsx`
2. ✅ Preencher `.env` com credenciais reais
3. ✅ `npm install && npm run dev`
4. ✅ Testar: http://localhost:3000
5. ✅ Deploy!

---

**Status:** ✅ Ready to Deploy

Mais informações em [../../README.md](../../README.md)
