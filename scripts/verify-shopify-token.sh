#!/bin/bash

##############################################################################
# SCRIPT: verify-shopify-token.sh
# 
# Objetivo: Verificar se o token Shopify está funcionando corretamente
# 
# Detecta:
# - Token válido vs inválido
# - Escopos aprovados vs não aprovados
# - Qual é o problema exato
#
# Como usar:
#   export SHOPIFY_DOMAIN="qdt02k-t4.myshopify.com"
#   export SHOPIFY_TOKEN="shpat_seu_token"
#   ./verify-shopify-token.sh
#
##############################################################################

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   BOOTCAMP 2026 - Verificar Token Shopify                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Ler de variáveis de ambiente
SHOP_DOMAIN="${SHOPIFY_DOMAIN:-}"
ADMIN_TOKEN="${SHOPIFY_TOKEN:-}"

if [ -z "$SHOP_DOMAIN" ] || [ -z "$ADMIN_TOKEN" ]; then
    echo "❌ Não consegui ler SHOPIFY_DOMAIN ou SHOPIFY_TOKEN"
    echo ""
    echo "Configure as variáveis:"
    echo "   export SHOPIFY_DOMAIN='qdt02k-t4.myshopify.com'"
    echo "   export SHOPIFY_TOKEN='shpat_seu_token'"
    echo ""
    echo "Ou use o wizard:"
    echo "   ./shopify-token-wizard.sh"
    exit 1
fi

echo "🔍 Verificando token..."
echo ""
echo "Domínio: $SHOP_DOMAIN"
echo "Token (primeiros 20 caracteres): ${ADMIN_TOKEN:0:20}..."
echo ""

# ─── TESTE 1: TOKEN VÁLIDO? ───────────────────────────────

echo "════════════════════════════════════════════════════════════"
echo "  TESTE 1: Token é válido?"
echo "════════════════════════════════════════════════════════════"
echo ""

RESPONSE=$(curl -s -X GET \
  "https://${SHOP_DOMAIN}/admin/api/2024-01/shop.json" \
  -H "X-Shopify-Access-Token: $ADMIN_TOKEN")

if echo "$RESPONSE" | grep -q '"shop"'; then
    echo "✅ Token é válido!"
    SHOP_NAME=$(echo "$RESPONSE" | grep -o '"name":"[^"]*' | cut -d'"' -f4)
    echo "   Loja: $SHOP_NAME"
    echo ""
else
    if echo "$RESPONSE" | grep -q "401\|Unauthorized"; then
        echo "❌ Token INVÁLIDO ou EXPIRADO"
        echo ""
        echo "Solução: Gere um novo token"
        echo "   ./shopify-token-wizard.sh"
        exit 1
    else
        echo "❌ Erro ao validar token"
        exit 1
    fi
fi

# ─── TESTE 2: ESCOPOS APROVADOS? ──────────────────────────

echo "════════════════════════════════════════════════════════════"
echo "  TESTE 2: Escopos aprovados?"
echo "════════════════════════════════════════════════════════════"
echo ""

RESPONSE=$(curl -s -X POST \
  "https://${SHOP_DOMAIN}/admin/api/2024-01/products.json" \
  -H "X-Shopify-Access-Token: $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"product":{"title":"Test"}}' 2>&1)

if echo "$RESPONSE" | grep -q "merchant approval"; then
    echo "❌ Escopos NÃO foram aprovados"
    echo ""
    echo "⚠️  A app precisa ser INSTALADA no Dev Dashboard"
    echo ""
    echo "Solução:"
    echo "  1. Acesse: https://dev.shopify.com"
    echo "  2. Selecione: Sua app 'Bootcamp Setup'"
    echo "  3. Clique em: 'Install app'"
    echo "  4. Confirme"
    echo "  5. Aguarde 1-2 minutos"
    echo "  6. Rode novamente: ./verify-shopify-token.sh"
    echo ""
    exit 1
elif echo "$RESPONSE" | grep -q '"product"'; then
    echo "✅ Escopos APROVADOS!"
    echo ""
    echo "🎉 Tudo pronto! Execute:"
    echo "   export SHOPIFY_DOMAIN='$SHOP_DOMAIN'"
    echo "   export SHOPIFY_TOKEN='$ADMIN_TOKEN'"
    echo "   node setup_shopify.js"
    exit 0
else
    echo "❌ Erro ao verificar escopos"
    exit 1
fi
