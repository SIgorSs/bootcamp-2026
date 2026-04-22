#!/bin/bash

##############################################################################
# SCRIPT: get-shopify-token.sh
# 
# Objetivo: Gerar Admin API Token do Shopify automaticamente
# 
# Como usar:
#   chmod +x get-shopify-token.sh
#   ./get-shopify-token.sh
#
# Requisitos:
#   - Node.js 18+
#   - Shopify CLI instalada
#
# Este script automatiza o processo de geração de token via Shopify CLI
##############################################################################

set -e  # Exit se qualquer comando falhar

echo "════════════════════════════════════════════════════════════"
echo "  BOOTCAMP 2026 - Gerar Shopify Admin API Token"
echo "════════════════════════════════════════════════════════════"
echo ""

# ─── VERIFICAR PRÉ-REQUISITOS ─────────────────────────────────

echo "🔍 Verificando pré-requisitos..."
echo ""

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não encontrado!"
    echo "   Instale: https://nodejs.org/ (versão 18+)"
    exit 1
fi
echo "✅ Node.js: $(node --version)"

# Verificar npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm não encontrado!"
    exit 1
fi
echo "✅ npm: $(npm --version)"

echo ""

# ─── INSTALAR SHOPIFY CLI (SE NECESSÁRIO) ───────────────────

if ! command -v shopify &> /dev/null; then
    echo "⬇️  Instalando Shopify CLI globalmente..."
    npm install -g @shopify/cli @shopify/theme
    echo "✅ Shopify CLI instalada"
else
    echo "✅ Shopify CLI já está instalada: $(shopify version)"
fi

echo ""

# ─── OBTER INFORMAÇÕES DO USUÁRIO ─────────────────────────────

echo "📝 Informações necessárias:"
echo ""

read -p "   Domínio Shopify (ex: qdt02k-t4.myshopify.com): " SHOP_DOMAIN

if [ -z "$SHOP_DOMAIN" ]; then
    echo "❌ Domínio não pode estar vazio!"
    exit 1
fi

echo ""

# ─── GERAR TOKEN ──────────────────────────────────────────────

echo "🔐 Gerando token via Shopify CLI..."
echo ""

# Usar shopify app generate-credentials com redirect automático
CREDENTIALS=$(shopify app generate-credentials \
    --shop="$SHOP_DOMAIN" \
    --scopes="write_products,write_product_listings,write_inventory,write_collections,write_metafield_definitions,write_metafields" \
    2>&1 || true)

# Extrair token do output
ADMIN_TOKEN=$(echo "$CREDENTIALS" | grep -oP '(?<=access_token["\s:]+)[^"]+' || echo "")

if [ -z "$ADMIN_TOKEN" ]; then
    echo "❌ Não consegui extrair o token automaticamente."
    echo ""
    echo "📖 Alternativa manual:"
    echo "   1. Acesse: https://$SHOP_DOMAIN/admin"
    echo "   2. Apps and sales channels → Develop apps"
    echo "   3. Clique em sua app → Configuration"
    echo "   4. Copie 'Client ID' e 'Client Secret'"
    echo "   5. Use: shopify app generate-credentials"
    echo ""
    exit 1
fi

echo "✅ Token gerado com sucesso!"
echo ""

# ─── MOSTRAR TOKEN ─────────────────────────────────────────────

echo "════════════════════════════════════════════════════════════"
echo "  🎉 SEU ADMIN API TOKEN"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Token:"
echo "   $ADMIN_TOKEN"
echo ""
echo "Domínio:"
echo "   $SHOP_DOMAIN"
echo ""

# ─── CONFIGURAR NO SCRIPT ──────────────────────────────────────

read -p "📝 Deseja configurar automaticamente no setup_shopify.js? (s/n): " CONFIGURE

if [[ "$CONFIGURE" == "s" || "$CONFIGURE" == "S" ]]; then
    SCRIPT_PATH="$(dirname "$0")/setup_shopify.js"
    
    if [ ! -f "$SCRIPT_PATH" ]; then
        echo "❌ Arquivo setup_shopify.js não encontrado em $SCRIPT_PATH"
        exit 1
    fi
    
    # Fazer backup
    cp "$SCRIPT_PATH" "$SCRIPT_PATH.bak"
    echo "💾 Backup criado: $SCRIPT_PATH.bak"
    
    # Substituir valores (escaping especial para o sed)
    sed -i "s|const SHOP_DOMAIN = .*|const SHOP_DOMAIN = \"$SHOP_DOMAIN\";|" "$SCRIPT_PATH"
    sed -i "s|const ADMIN_TOKEN = .*|const ADMIN_TOKEN = \"$ADMIN_TOKEN\";|" "$SCRIPT_PATH"
    
    echo "✅ setup_shopify.js configurado com sucesso!"
    echo ""
    echo "🚀 Para executar o setup:"
    echo "   cd $(dirname "$0")"
    echo "   node setup_shopify.js"
else
    echo "📋 Configure manualmente em setup_shopify.js:"
    echo ""
    echo "   const SHOP_DOMAIN = \"$SHOP_DOMAIN\";"
    echo "   const ADMIN_TOKEN = \"$ADMIN_TOKEN\";"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
