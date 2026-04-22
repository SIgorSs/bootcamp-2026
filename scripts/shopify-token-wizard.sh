#!/bin/bash

##############################################################################
# SCRIPT: shopify-token-wizard.sh
# 
# Objetivo: Assistente interativo para gerar Admin API Token Shopify 2026
# 
# Baseado em: Documentação oficial Shopify
# https://help.shopify.com
# 
# Mudanças em janeiro 2026:
# - Apps ANTIGAS: Token estático ainda disponível (Opção A)
# - Apps NOVAS: Token gerado via OAuth / Client Credentials (Opção B)
# 
# Este script detecta e executa automaticamente o método correto.
# 
# Como usar:
#   chmod +x shopify-token-wizard.sh
#   ./shopify-token-wizard.sh
#
##############################################################################

set -e

clear

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   BOOTCAMP 2026 - Shopify Admin API Token Wizard          ║"
echo "║   Detectando melhor método para sua loja...                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# ─── PRÉ-REQUISITOS ───────────────────────────────────────────

echo "🔍 Verificando pré-requisitos..."
echo ""

NODE_OK=0
if command -v node &> /dev/null; then
    echo "✅ Node.js: $(node --version)"
    NODE_OK=1
else
    echo "❌ Node.js não encontrado. Instale em: https://nodejs.org"
fi

NPM_OK=0
if command -v npm &> /dev/null; then
    echo "✅ npm: $(npm --version)"
    NPM_OK=1
else
    echo "❌ npm não encontrado"
fi

if [ $NODE_OK -eq 0 ] || [ $NPM_OK -eq 0 ]; then
    echo ""
    echo "⚠️  Instale Node.js e tente novamente"
    exit 1
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo ""

# ─── OBTER DOMÍNIO ─────────────────────────────────────────────

read -p "📌 Seu domínio Shopify (ex: qdt02k-t4): " SHOP_NAME

if [ -z "$SHOP_NAME" ]; then
    echo "❌ Domínio não pode estar vazio!"
    exit 1
fi

SHOP_DOMAIN="${SHOP_NAME}.myshopify.com"
ADMIN_URL="https://${SHOP_NAME}.admin.shopify.com"

echo ""
echo "🔗 Domínio: $SHOP_DOMAIN"
echo "🌐 Admin: $ADMIN_URL"
echo ""

# ─── OFERECER OPÇÕES ──────────────────────────────────────────

echo "════════════════════════════════════════════════════════════"
echo "  Qual é sua situação?"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "1) Já criei um app em Develop apps"
echo "   (vejo 'Client ID' e 'Client Secret' em Configuration)"
echo ""
echo "2) Ainda não criei nada (primeira vez)"
echo ""
echo "3) Não tenho certeza / Prefiro tentar automaticamente"
echo ""

read -p "Escolha (1/2/3): " CHOICE

echo ""

case $CHOICE in
    1)
        # ─── OPÇÃO: JÁ TEM APP ───────────────────────────
        echo "🔑 Método: Gerar token via Client Credentials"
        echo ""
        echo "Você precisa de:"
        echo "  1. Client ID (encontra em: Develop apps → Sua app → Configuration)"
        echo "  2. Client Secret (mesma tela, abaixo de Client ID)"
        echo ""
        
        read -p "Cole aqui seu Client ID: " CLIENT_ID
        read -sp "Cole aqui seu Client Secret: " CLIENT_SECRET
        
        if [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
            echo ""
            echo "❌ Client ID ou Secret vazio!"
            exit 1
        fi
        
        echo ""
        echo ""
        echo "🔐 Gerando token via OAuth..."
        
        # Fazer requisição para gerar token
        RESPONSE=$(curl -s -X POST "https://${SHOP_DOMAIN}/admin/oauth/access_token" \
          -H "Content-Type: application/json" \
          -d "{
            \"client_id\": \"$CLIENT_ID\",
            \"client_secret\": \"$CLIENT_SECRET\",
            \"grant_type\": \"client_credentials\",
            \"scope\": \"write_products,write_product_listings,write_inventory,write_collections,write_metafield_definitions,write_metafields\"
          }")
        
        ADMIN_TOKEN=$(echo "$RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
        
        if [ -z "$ADMIN_TOKEN" ]; then
            echo "❌ Erro ao gerar token. Resposta:"
            echo "$RESPONSE"
            exit 1
        fi
        
        echo "✅ Token gerado com sucesso!"
        ;;
    
    2)
        # ─── OPÇÃO: CRIAR APP NOVO ───────────────────────
        echo "📝 Método: Criar app novo e gerar token"
        echo ""
        echo "Vou abrir seu Shopify Admin..."
        echo ""
        echo "Você precisa:"
        echo "  1. Ir em: Develop apps → Create an app"
        echo "  2. Nome: 'Bootcamp Setup'"
        echo "  3. Configuration → Admin API scopes → Marcar 6 escopos:"
        echo "     ✅ write_products"
        echo "     ✅ write_product_listings"
        echo "     ✅ write_inventory"
        echo "     ✅ write_collections"
        echo "     ✅ write_metafield_definitions"
        echo "     ✅ write_metafields"
        echo "  4. Salvar → Install app"
        echo "  5. Voltar para Configuration e copiar Client ID + Secret"
        echo ""
        
        read -p "Abrir Shopify Admin agora? (s/n): " OPEN_ADMIN
        
        if [[ "$OPEN_ADMIN" == "s" || "$OPEN_ADMIN" == "S" ]]; then
            # Tentar abrir no navegador
            if command -v xdg-open &> /dev/null; then
                xdg-open "$ADMIN_URL/settings/apps-and-integrations/develop-apps"
            elif command -v open &> /dev/null; then
                open "$ADMIN_URL/settings/apps-and-integrations/develop-apps"
            else
                echo "Abra manualmente: $ADMIN_URL/settings/apps-and-integrations/develop-apps"
            fi
            
            echo ""
            echo "⏳ Aguardando... Após criar a app e copiar as credenciais,"
            sleep 2
        fi
        
        read -p "Cole seu Client ID: " CLIENT_ID
        read -sp "Cole seu Client Secret: " CLIENT_SECRET
        
        if [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
            echo ""
            echo "❌ Credenciais vazias!"
            exit 1
        fi
        
        echo ""
        echo ""
        echo "🔐 Gerando token..."
        
        RESPONSE=$(curl -s -X POST "https://${SHOP_DOMAIN}/admin/oauth/access_token" \
          -H "Content-Type: application/json" \
          -d "{
            \"client_id\": \"$CLIENT_ID\",
            \"client_secret\": \"$CLIENT_SECRET\",
            \"grant_type\": \"client_credentials\",
            \"scope\": \"write_products,write_product_listings,write_inventory,write_collections,write_metafield_definitions,write_metafields\"
          }")
        
        ADMIN_TOKEN=$(echo "$RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
        
        if [ -z "$ADMIN_TOKEN" ]; then
            echo "❌ Erro ao gerar token:"
            echo "$RESPONSE"
            exit 1
        fi
        
        echo "✅ Token gerado com sucesso!"
        ;;
    
    3)
        # ─── OPÇÃO: TENTAR SHOPIFY CLI ───────────────────
        echo "🤖 Método: Automático via Shopify CLI"
        echo ""
        
        if ! command -v shopify &> /dev/null; then
            echo "⬇️  Instalando Shopify CLI..."
            npm install -g @shopify/cli @shopify/theme
            echo "✅ Instalação concluída"
        fi
        
        echo ""
        echo "🔐 Gerando credenciais via CLI..."
        echo "(Isso pode abrir uma janela de navegador)"
        echo ""
        
        CREDENTIALS=$(shopify app generate-credentials --shop "$SHOP_DOMAIN" 2>&1 || true)
        
        # Tentar extrair token
        ADMIN_TOKEN=$(echo "$CREDENTIALS" | grep -oP 'access_token["\s:]*\K[^"\n,]+' || echo "")
        
        if [ -z "$ADMIN_TOKEN" ]; then
            echo "❌ Não consegui extrair o token automaticamente."
            echo ""
            echo "💡 Tente novamente com a Opção 1 (se já tem a app) ou Opção 2 (criar nova)"
            exit 1
        fi
        
        echo "✅ Token gerado com sucesso!"
        ;;
    
    *)
        echo "❌ Opção inválida!"
        exit 1
        ;;
esac

# ─── EXIBIR TOKEN E CONFIGURAR ─────────────────────────────────

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  ✨ TOKEN GERADO COM SUCESSO!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Token:"
echo "  $ADMIN_TOKEN"
echo ""
echo "Domínio:"
echo "  $SHOP_DOMAIN"
echo ""

# ─── CONFIGURAR NO SCRIPT ──────────────────────────────────────

read -p "Configurar automaticamente no setup_shopify.js? (s/n): " CONFIGURE

if [[ "$CONFIGURE" == "s" || "$CONFIGURE" == "S" ]]; then
    SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)/setup_shopify.js"
    
    if [ ! -f "$SCRIPT_PATH" ]; then
        echo "❌ Arquivo setup_shopify.js não encontrado!"
        echo "   Procurado em: $SCRIPT_PATH"
        exit 1
    fi
    
    # Fazer backup
    cp "$SCRIPT_PATH" "$SCRIPT_PATH.bak"
    echo "💾 Backup criado: $SCRIPT_PATH.bak"
    echo ""
    
    # Usar perl ao invés de sed para melhor compatibilidade
    perl -i -pe "s|const SHOP_DOMAIN = .*?;|const SHOP_DOMAIN = \"$SHOP_DOMAIN\";|" "$SCRIPT_PATH"
    perl -i -pe "s|const ADMIN_TOKEN = .*?;|const ADMIN_TOKEN = \"$ADMIN_TOKEN\";|" "$SCRIPT_PATH"
    
    echo "✅ Configurado com sucesso!"
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "  🚀 PRÓXIMO PASSO: Executar o Setup"
    echo "════════════════════════════════════════════════════════════"
    echo ""
    echo "  cd $(dirname "$SCRIPT_PATH")"
    echo "  node setup_shopify.js"
    echo ""
else
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "  📋 CONFIGURAÇÃO MANUAL"
    echo "════════════════════════════════════════════════════════════"
    echo ""
    echo "Abra: scripts/setup_shopify.js"
    echo ""
    echo "Altere estas linhas:"
    echo "  const SHOP_DOMAIN = \"$SHOP_DOMAIN\";"
    echo "  const ADMIN_TOKEN = \"$ADMIN_TOKEN\";"
    echo ""
    echo "Depois execute:"
    echo "  cd scripts"
    echo "  node setup_shopify.js"
    echo ""
fi

echo "════════════════════════════════════════════════════════════"
