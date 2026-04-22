#!/bin/bash

# ============================================================
# SCRIPT DE SETUP - ADOBE COMMERCE - BOOTCAMP 2026
# Cadastra categorias, atributos e produtos automaticamente
# ============================================================

BASE_URL="https://app.magento2.test"
ADMIN_USER="admin"
ADMIN_PASS="admin123"  # ⚠️ ALTERE PARA SUA SENHA

echo "================================================"
echo "  BOOTCAMP 2026 - Setup Adobe Commerce"
echo "================================================"

# ─── 1. OBTER TOKEN DE ADMIN ───────────────────────────────
echo ""
echo "🔐 Obtendo token de autenticação..."

TOKEN=$(curl -s -X POST \
  "${BASE_URL}/rest/V1/integration/admin/token" \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"${ADMIN_USER}\", \"password\": \"${ADMIN_PASS}\"}" \
  | tr -d '"')

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
  echo "❌ Erro ao obter token. Verifique usuário e senha."
  echo "   URL: $BASE_URL"
  echo "   User: $ADMIN_USER"
  exit 1
fi

echo "✅ Token obtido com sucesso!"

AUTH="Authorization: Bearer ${TOKEN}"

# ─── 2. CRIAR ATRIBUTOS ────────────────────────────────────
echo ""
echo "📝 Criando atributo bootcamp_highlight..."

curl -s -X POST "${BASE_URL}/rest/V1/products/attributes" \
  -H "Content-Type: application/json" \
  -H "$AUTH" \
  -d '{
    "attribute": {
      "attribute_code": "bootcamp_highlight",
      "frontend_input": "boolean",
      "default_frontend_label": "Destaque Bootcamp",
      "is_required": false,
      "scope": "store",
      "is_searchable": true,
      "is_visible_on_front": true,
      "used_in_product_listing": true,
      "entity_type_id": "4",
      "backend_type": "int"
    }
  }' > /dev/null 2>&1

echo "✅ bootcamp_highlight criado!"

echo ""
echo "📝 Criando atributo tech_stack..."

curl -s -X POST "${BASE_URL}/rest/V1/products/attributes" \
  -H "Content-Type: application/json" \
  -H "$AUTH" \
  -d '{
    "attribute": {
      "attribute_code": "tech_stack",
      "frontend_input": "select",
      "default_frontend_label": "Stack Tecnológico",
      "is_required": false,
      "scope": "global",
      "is_searchable": true,
      "is_visible_on_front": true,
      "used_in_product_listing": true,
      "entity_type_id": "4",
      "backend_type": "int",
      "options": [
        {"label": "PHP", "value": ""},
        {"label": "Java", "value": ""},
        {"label": "JavaScript", "value": ""},
        {"label": "React", "value": ""},
        {"label": "Liquid", "value": ""}
      ]
    }
  }' > /dev/null 2>&1

echo "✅ tech_stack criado!"

# ─── 3. CRIAR CATEGORIAS ──────────────────────────────────
echo ""
echo "📁 Criando categorias..."

ROOT_ID=2

create_category() {
  local NAME=$1
  local PARENT=$2
  
  curl -s -X POST "${BASE_URL}/rest/V1/categories" \
    -H "Content-Type: application/json" \
    -H "$AUTH" \
    -d "{
      \"category\": {
        \"name\": \"${NAME}\",
        \"parent_id\": ${PARENT},
        \"is_active\": true,
        \"include_in_menu\": true,
        \"position\": 1
      }
    }" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('id',''))" 2>/dev/null
}

VESTUARIO_ID=$(create_category "Vestuário" $ROOT_ID)
CAMISETAS_ID=$(create_category "Camisetas" $VESTUARIO_ID)
echo "   ✅ Vestuário → Camisetas"

ACESSORIOS_ID=$(create_category "Acessórios" $ROOT_ID)
CANECAS_ID=$(create_category "Canecas" $ACESSORIOS_ID)
MOCHILAS_ID=$(create_category "Mochilas" $ACESSORIOS_ID)
echo "   ✅ Acessórios → Canecas, Mochilas"

PAPELARIA_ID=$(create_category "Papelaria" $ROOT_ID)
ADESIVOS_ID=$(create_category "Adesivos" $PAPELARIA_ID)
echo "   ✅ Papelaria → Adesivos"

DIGITAL_ID=$(create_category "Digital" $ROOT_ID)
CURSOS_ID=$(create_category "Cursos" $DIGITAL_ID)
echo "   ✅ Digital → Cursos"

# ─── 4. CRIAR PRODUTOS SIMPLES ────────────────────────────
echo ""
echo "🛍️  Criando produtos..."

create_product() {
  local NAME=$1
  local SKU=$2
  local PRICE=$3
  local CAT=$4
  local TECH=$5
  
  curl -s -X POST "${BASE_URL}/rest/V1/products" \
    -H "Content-Type: application/json" \
    -H "$AUTH" \
    -d "{
      \"product\": {
        \"sku\": \"${SKU}\",
        \"name\": \"${NAME}\",
        \"price\": ${PRICE},
        \"status\": 1,
        \"visibility\": 4,
        \"type_id\": \"simple\",
        \"extension_attributes\": {
          \"stock_item\": {\"qty\": 50, \"is_in_stock\": true},
          \"category_links\": [{\"category_id\": \"${CAT}\", \"position\": 0}]
        },
        \"custom_attributes\": [
          {\"attribute_code\": \"bootcamp_highlight\", \"value\": \"1\"},
          {\"attribute_code\": \"tech_stack\", \"value\": \"${TECH}\"}
        ]
      }
    }" > /dev/null 2>&1
}

create_product "Camiseta Bootcamp 2026" "BOOT-CAM-001" "89.90" "$CAMISETAS_ID" "React"
echo "   ✅ Camiseta Bootcamp 2026 (BOOT-CAM-001)"

create_product "Caneca Developer" "BOOT-CAN-002" "45.00" "$CANECAS_ID" "JavaScript"
echo "   ✅ Caneca Developer (BOOT-CAN-002)"

create_product "Mochila Tech" "BOOT-MOC-003" "199.90" "$MOCHILAS_ID" "Java"
echo "   ✅ Mochila Tech (BOOT-MOC-003)"

create_product "Kit Adesivos Dev" "BOOT-KIT-004" "29.90" "$ADESIVOS_ID" "PHP"
echo "   ✅ Kit Adesivos Dev (BOOT-KIT-004)"

create_product "Curso Online Adobe Commerce" "BOOT-CUR-005" "0" "$CURSOS_ID" "Liquid"
echo "   ✅ Curso Online Adobe Commerce (BOOT-CUR-005)"

# ─── 5. VERIFICAÇÃO FINAL ─────────────────────────────────
echo ""
echo "================================================"
echo "  🔍 VERIFICAÇÃO"
echo "================================================"

TOTAL=$(curl -s "${BASE_URL}/rest/V1/products?searchCriteria[filter_groups][0][filters][0][field]=sku&searchCriteria[filter_groups][0][filters][0][value]=BOOT-%25&searchCriteria[filter_groups][0][filters][0][condition_type]=like" \
  -H "$AUTH" 2>/dev/null | python3 -c "
import json,sys
try:
  data = json.load(sys.stdin)
  items = data.get('items', [])
  print(f'✅ Total de produtos: {len(items)}')
  for p in items[:5]:
    print(f'   - [{p[\"sku\"]}] {p[\"name\"]} | R\$ {p[\"price\"]}')
except:
  print('❌ Erro ao verificar')
" 2>/dev/null)

echo "$TOTAL"

echo ""
echo "================================================"
echo "  ✅ SETUP COMMERCE CONCLUÍDO!"
echo "================================================"
echo ""
echo "Testar API:"
echo "curl -s ${BASE_URL}/rest/V1/bootcamp/products | python3 -m json.tool"
echo ""
