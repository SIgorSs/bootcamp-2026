#!/usr/bin/env node

/**
 * SCRIPT DE SETUP - SHOPIFY - BOOTCAMP 2026
 * Cria produtos e coleções automaticamente
 * 
 * IMPORTANTE: Precisa do Admin API Token (começa com shpat_)
 * NÃO use: Webhook Secret, Default API Key, ou outras chaves!
 * 
 * Como gerar (2 opções):
 * 
 * OPÇÃO A (LEGACY - Custom Apps):
 * 1. Settings > Apps and sales channels > Develop apps
 * 2. Create custom app > Nome: "Bootcamp Setup"
 * 3. Configuration > Admin API scopes (marque 6 escopos)
 * 4. Install app > API credentials > Reveal token > Copiar aqui
 * 
 * OPÇÃO B (NOVO - OAuth 2026):
 * 1. Develop apps > Create an app
 * 2. Configuration > Admin API credentials > Copiar Client ID + Secret
 * 3. Usar Shopify CLI: shopify app generate-credentials
 * 4. Usar o access_token gerado (começa com shpat_)
 * 
 * Ver: scripts/SHOPIFY-TOKEN-GUIDE.md para instruções completas
 */

// ─── CONFIGURAÇÕES ────────────────────────────────────────
// ⚠️ ALTERE ESSES VALORES
const SHOP_DOMAIN = "sua-loja.myshopify.com";
const ADMIN_TOKEN = "shpat_SEU_ADMIN_API_TOKEN_AQUI";
// ⚠️ O token DEVE começar com "shpat_" (não use API Key legada!)

const API_VERSION = "2024-01";
const BASE_URL = `https://${SHOP_DOMAIN}/admin/api/${API_VERSION}`;

const HEADERS = {
  "Content-Type": "application/json",
  "X-Shopify-Access-Token": ADMIN_TOKEN,
};

// ─── HELPER ───────────────────────────────────────────────
async function shopifyRequest(endpoint, method = "GET", body = null) {
  const options = { method, headers: HEADERS };
  if (body) options.body = JSON.stringify(body);

  try {
    const res = await fetch(`${BASE_URL}${endpoint}`, options);
    const data = await res.json();

    if (!res.ok) {
      console.error(`❌ Erro ${res.status} em ${endpoint}:`, data);
      return null;
    }
    return data;
  } catch (err) {
    console.error(`❌ Erro de conexão: ${err.message}`);
    return null;
  }
}

async function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

// ─── 1. CRIAR PRODUTOS ────────────────────────────────────
const PRODUTOS = [
  {
    title: "Camiseta Bootcamp 2026",
    body_html:
      "<p>Camiseta oficial do Bootcamp 2026. 100% algodão, confortável e com design exclusivo.</p>",
    vendor: "Bootcamp 2026",
    product_type: "Vestuário",
    tags: ["bootcamp", "camiseta"],
    variants: [
      { option1: "P", price: "89.90", sku: "BOOT-CAM-001-P", inventory_quantity: 20 },
      { option1: "M", price: "89.90", sku: "BOOT-CAM-001-M", inventory_quantity: 20 },
      { option1: "G", price: "89.90", sku: "BOOT-CAM-001-G", inventory_quantity: 20 },
      { option1: "GG", price: "89.90", sku: "BOOT-CAM-001-GG", inventory_quantity: 20 },
    ],
    options: [{ name: "Tamanho", values: ["P", "M", "G", "GG"] }],
    metafields: [
      { namespace: "custom", key: "tech_stack", value: "React", type: "single_line_text_field" },
      { namespace: "custom", key: "bootcamp_year", value: 2026, type: "number_integer" },
    ],
    status: "active",
  },
  {
    title: "Caneca Developer",
    body_html: "<p>Caneca perfeita para seus cafés enquanto programa. Cerâmica resistente, 350ml.</p>",
    vendor: "Bootcamp 2026",
    product_type: "Acessórios",
    tags: ["bootcamp", "caneca"],
    variants: [{ price: "45.00", sku: "BOOT-CAN-002", inventory_quantity: 50 }],
    metafields: [
      { namespace: "custom", key: "tech_stack", value: "JavaScript", type: "single_line_text_field" },
      { namespace: "custom", key: "bootcamp_year", value: 2026, type: "number_integer" },
    ],
    status: "active",
  },
  {
    title: "Mochila Tech",
    body_html: "<p>Mochila resistente para carregar seu notebook e equipamentos. Compartimentos organizados.</p>",
    vendor: "Bootcamp 2026",
    product_type: "Acessórios",
    tags: ["bootcamp", "mochila"],
    variants: [{ price: "199.90", sku: "BOOT-MOC-003", inventory_quantity: 30 }],
    metafields: [
      { namespace: "custom", key: "tech_stack", value: "Java", type: "single_line_text_field" },
      { namespace: "custom", key: "bootcamp_year", value: 2026, type: "number_integer" },
    ],
    status: "active",
  },
  {
    title: "Kit Adesivos Dev",
    body_html: "<p>Conjunto com 15 adesivos com logos de tecnologias populares. Perfeito para personalizar!</p>",
    vendor: "Bootcamp 2026",
    product_type: "Papelaria",
    tags: ["bootcamp", "adesivos"],
    variants: [{ price: "29.90", sku: "BOOT-KIT-004", inventory_quantity: 100 }],
    metafields: [
      { namespace: "custom", key: "tech_stack", value: "PHP", type: "single_line_text_field" },
      { namespace: "custom", key: "bootcamp_year", value: 2026, type: "number_integer" },
    ],
    status: "active",
  },
  {
    title: "Curso Online Adobe Commerce",
    body_html:
      "<p>Aprenda Adobe Commerce do zero ao avançado. Acesso vitalício, certificado incluso. 20 horas de conteúdo.</p>",
    vendor: "Bootcamp 2026",
    product_type: "Cursos Digital",
    tags: ["bootcamp", "curso", "digital"],
    variants: [
      { price: "0", sku: "BOOT-CUR-005", inventory_quantity: 9999, requires_shipping: false },
    ],
    metafields: [
      { namespace: "custom", key: "tech_stack", value: "Liquid", type: "single_line_text_field" },
      { namespace: "custom", key: "bootcamp_year", value: 2026, type: "number_integer" },
    ],
    status: "active",
  },
];

async function createProducts() {
  console.log("\n🛍️  Criando produtos...");
  const productIds = {};

  for (const produto of PRODUTOS) {
    const res = await shopifyRequest("/products.json", "POST", { product: produto });

    if (res?.product) {
      const p = res.product;
      productIds[p.title] = p.id;
      console.log(`   ✅ ${p.title}`);
    } else {
      console.log(`   ❌ Erro ao criar: ${produto.title}`);
    }

    await sleep(300);
  }

  return productIds;
}

// ─── 2. CRIAR COLEÇÕES ────────────────────────────────────
async function createCollections(productIds) {
  console.log("\n📁 Criando coleções...");

  const colecoes = [
    {
      title: "Destaques",
      handle: "destaques",
      body_html: "<p>Os melhores produtos do Bootcamp 2026.</p>",
      products: Object.values(productIds),
    },
    {
      title: "Vestuário",
      handle: "vestuario",
      body_html: "<p>Roupas da marca Bootcamp.</p>",
      products: [productIds["Camiseta Bootcamp 2026"]].filter(Boolean),
    },
    {
      title: "Acessórios",
      handle: "acessorios",
      body_html: "<p>Acessórios úteis para devs.</p>",
      products: [productIds["Caneca Developer"], productIds["Mochila Tech"]].filter(Boolean),
    },
    {
      title: "Digital",
      handle: "digital",
      body_html: "<p>Cursos online do Bootcamp.</p>",
      products: [productIds["Curso Online Adobe Commerce"]].filter(Boolean),
    },
  ];

  for (const col of colecoes) {
    const res = await shopifyRequest("/custom_collections.json", "POST", {
      custom_collection: {
        title: col.title,
        handle: col.handle,
        body_html: col.body_html,
        published: true,
      },
    });

    if (res?.custom_collection) {
      const colId = res.custom_collection.id;
      console.log(`   ✅ ${col.title}`);

      // Adicionar produtos
      for (const productId of col.products) {
        if (productId) {
          await shopifyRequest("/collects.json", "POST", {
            collect: { product_id: productId, collection_id: colId },
          });
        }
        await sleep(100);
      }
    }

    await sleep(300);
  }
}

// ─── 3. VERIFICAÇÃO FINAL ─────────────────────────────────
async function verify() {
  console.log("\n" + "=".repeat(50));
  console.log("  🔍 VERIFICAÇÃO FINAL");
  console.log("=".repeat(50));

  const products = await shopifyRequest("/products.json?limit=10");
  if (products?.products) {
    console.log(`\n✅ Total de produtos: ${products.products.length}`);
  }

  const collections = await shopifyRequest("/custom_collections.json");
  if (collections?.custom_collections) {
    console.log(`✅ Total de coleções: ${collections.custom_collections.length}`);
  }
}

// ─── MAIN ─────────────────────────────────────────────────
async function main() {
  console.log("=" .repeat(50));
  console.log("  BOOTCAMP 2026 - Setup Shopify");
  console.log("=".repeat(50));

  if (
    ADMIN_TOKEN === "shpat_SEU_ADMIN_API_TOKEN_AQUI" ||
    SHOP_DOMAIN === "sua-loja.myshopify.com"
  ) {
    console.log(`
❌ CONFIGURE AS CREDENCIAIS ANTES DE RODAR!

Edite o arquivo setup_shopify.js e altere:
  SHOP_DOMAIN = "sua-loja.myshopify.com"
  ADMIN_TOKEN = "shpat_SEU_ADMIN_API_TOKEN_AQUI"

Para obter o Admin API Token:
1. Shopify Admin > Settings > Apps and sales channels
2. Develop apps > Create an app > "Bootcamp Setup"
3. Configuration > Admin API scopes (marque):
   ✅ write_products
   ✅ write_product_listings
   ✅ write_inventory
   ✅ write_collections
   ✅ write_metafield_definitions
   ✅ write_metafields
4. Install app > Reveal token > Copie o token
5. Cole aqui no ADMIN_TOKEN

⚠️ NÃO use o Webhook Secret! Use o Admin API Token!
    `);
    process.exit(1);
  }

  try {
    const productIds = await createProducts();
    await createCollections(productIds);
    await verify();

    console.log("\n" + "=".repeat(50));
    console.log("  ✅ SETUP SHOPIFY CONCLUÍDO!");
    console.log("=".repeat(50));
  } catch (err) {
    console.error("❌ Erro:", err.message);
  }
}

main();
