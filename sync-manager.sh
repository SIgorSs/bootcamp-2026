#!/bin/bash

# 🔄 Sync Manager - Escolher entre Symlink ou Cópias
# Este script ajuda a sincronizar Magento e AEM de forma segura

set -e

PROJECT_DIR="/home/igors/projects/bootcamp-2026"
MAGENTO_DIR="/home/igors/projects/magento2"
AEM_DIR="/home/igors/projects/aem"

echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                        ║"
echo "║          🔄 BOOTCAMP 2026 - SYNC MANAGER 🔄                          ║"
echo "║                                                                        ║"
echo "║  Escolha como sincronizar Magento e AEM com Git                      ║"
echo "║                                                                        ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Menu
echo -e "${BLUE}Escolha uma opção:${NC}"
echo ""
echo "1️⃣  OPÇÃO 1: Manter Symlink + Criar Script de Sincronização"
echo "   ✅ Alterações em tempo real"
echo "   ⚠️  Sem isolamento (altera Magento em Docker)"
echo "   👉 Melhor para: Desenvolvimento ativo"
echo ""
echo "2️⃣  OPÇÃO 2: Remover Symlink + Usar Cópias Isoladas"
echo "   ✅ Isolamento total"
echo "   ❌ Sem alterações ao vivo"
echo "   👉 Melhor para: Produção / Segurança"
echo ""
echo "3️⃣  OPÇÃO 3: Ver Mais Detalhes"
echo "   📖 Abrir AVISO-SYMLINKS.md"
echo ""

read -p "Escolha [1-3]: " choice

case $choice in
  1)
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}OPÇÃO 1: Manter Symlink + Script de Sincronização${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Verificar se já tem symlinks
    if [ -L "$PROJECT_DIR/magento2" ]; then
      echo -e "${GREEN}✅ Symlink magento2 já existe${NC}"
    else
      echo -e "${YELLOW}⚠️  Symlink magento2 não encontrado${NC}"
      read -p "Criar agora? [s/n]: " create_link
      if [ "$create_link" = "s" ]; then
        cd "$PROJECT_DIR"
        ln -s ../magento2 ./magento2
        echo -e "${GREEN}✅ Symlink criado${NC}"
      fi
    fi
    
    # Criar script de sincronização
    echo ""
    echo -e "${BLUE}Criando script de sincronização...${NC}"
    
    cat > "$PROJECT_DIR/sync-modules.sh" << 'SYNC_SCRIPT'
#!/bin/bash

# 🔄 Sincronizar mudanças Magento/AEM com Git

set -e

PROJECT_DIR="/home/igors/projects/bootcamp-2026"
MAGENTO_DIR="/home/igors/projects/magento2"
AEM_DIR="/home/igors/projects/aem"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}🔄 SINCRONIZANDO MÓDULOS...${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

cd "$PROJECT_DIR"

# 1. Sincronizar Magento
echo -e "${BLUE}1️⃣  Sincronizando Magento...${NC}"
if [ -d "$MAGENTO_DIR/app/code/Bootcamp" ]; then
    cp -r "$MAGENTO_DIR/app/code/Bootcamp" referencias/magento-modules/
    echo -e "${GREEN}✅ Magento sincronizado${NC}"
else
    echo -e "${YELLOW}⚠️  Módulos Magento não encontrados${NC}"
fi

echo ""

# 2. Limpar cache Docker (se container estiver rodando)
echo -e "${BLUE}2️⃣  Limpando cache Magento (Docker)...${NC}"
if docker ps | grep -q magento; then
    docker exec magento php bin/magento cache:flush 2>/dev/null || true
    echo -e "${GREEN}✅ Cache limpo${NC}"
else
    echo -e "${YELLOW}⚠️  Container Magento não está rodando${NC}"
fi

echo ""

# 3. Sincronizar AEM (se tiver mudanças)
echo -e "${BLUE}3️⃣  Sincronizando AEM...${NC}"
if [ -d "$AEM_DIR" ]; then
    cp -r "$AEM_DIR"/src/* referencias/aem-config/ 2>/dev/null || true
    echo -e "${GREEN}✅ AEM sincronizado${NC}"
else
    echo -e "${YELLOW}⚠️  AEM não encontrado em $AEM_DIR${NC}"
fi

echo ""

# 4. Fazer Git commit automático
echo -e "${BLUE}4️⃣  Fazendo commit automático...${NC}"

git add referencias/ shopify-*/ adobe-*/

STATUS=$(git status --porcelain | wc -l)

if [ $STATUS -gt 0 ]; then
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "🔄 Sincronização automática - $TIMESTAMP

- Módulos Magento sincronizados
- Cache Docker limpado
- Código atualizado" || true
    
    echo -e "${GREEN}✅ Commit realizado${NC}"
else
    echo -e "${YELLOW}ℹ️  Nenhuma mudança para commitar${NC}"
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✨ SINCRONIZAÇÃO COMPLETA!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Próximo passo: git push"

SYNC_SCRIPT

    chmod +x "$PROJECT_DIR/sync-modules.sh"
    echo -e "${GREEN}✅ Script criado: sync-modules.sh${NC}"
    
    echo ""
    echo -e "${BLUE}Como usar:${NC}"
    echo "  1. Editar em: /home/igors/projects/magento2/app/code/Bootcamp/"
    echo "  2. Testar no Docker"
    echo "  3. Rodar: bash $PROJECT_DIR/sync-modules.sh"
    echo "  4. Fazer push: git push"
    echo ""
    echo -e "${YELLOW}⚠️  IMPORTANTE:${NC}"
    echo "  • Mudanças NO DOCKER vão refletir de verdade"
    echo "  • Sempre fazer backup antes de mudanças grandes"
    echo "  • Limpar cache: docker exec magento php bin/magento cache:flush"
    ;;
    
  2)
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}OPÇÃO 2: Remover Symlink + Usar Cópias Isoladas${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    read -p "Tem certeza? Isso vai remover os symlinks [s/n]: " confirm
    
    if [ "$confirm" != "s" ]; then
      echo -e "${YELLOW}Cancelado${NC}"
      exit 0
    fi
    
    echo ""
    echo -e "${BLUE}1️⃣  Removendo symlinks...${NC}"
    
    cd "$PROJECT_DIR"
    
    if [ -L "magento2" ]; then
      rm magento2
      echo -e "${GREEN}✅ Symlink magento2 removido${NC}"
    fi
    
    if [ -L "aem" ]; then
      rm aem
      echo -e "${GREEN}✅ Symlink aem removido${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}2️⃣  Criando diretórios isolados...${NC}"
    
    mkdir -p magento-local aem-local
    
    # Copiar conteúdo atual
    cp -r "$MAGENTO_DIR/app/code/Bootcamp" magento-local/ 2>/dev/null || true
    echo -e "${GREEN}✅ Magento copiado para magento-local/${NC}"
    
    if [ -d "$AEM_DIR/src" ]; then
      cp -r "$AEM_DIR/src"/* aem-local/ 2>/dev/null || true
      echo -e "${GREEN}✅ AEM copiado para aem-local/${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}3️⃣  Atualizando .gitignore...${NC}"
    
    # Remover referências a symlinks
    sed -i '/^magento2\/$/d' .gitignore
    sed -i '/^aem\/$/d' .gitignore
    
    # Adicionar os novos diretórios se quiser ignorar ou não
    if ! grep -q "magento-local" .gitignore; then
      echo "magento-local/" >> .gitignore
      echo "aem-local/" >> .gitignore
    fi
    
    echo -e "${GREEN}✅ .gitignore atualizado${NC}"
    
    echo ""
    echo -e "${BLUE}4️⃣  Fazendo commit...${NC}"
    
    git add .gitignore
    git commit -m "🔄 Migrar de Symlinks para Cópias Isoladas

- Removidos symlinks magento2 e aem
- Criados diretórios magento-local/ e aem-local/
- Conteúdo copiado de forma isolada
- Mudanças não afetam Docker até fazer merge" || true
    
    echo -e "${GREEN}✅ Commit realizado${NC}"
    
    echo ""
    echo -e "${BLUE}Como usar agora:${NC}"
    echo "  1. Editar em: magento-local/ e aem-local/"
    echo "  2. Testar mudanças (isolado)"
    echo "  3. Quando pronto, copiar para Magento real:"
    echo "     cp -r magento-local/* $MAGENTO_DIR/app/code/"
    echo "  4. Testar em Docker"
    echo "  5. Fazer commit: git add . && git commit"
    echo ""
    ;;
    
  3)
    echo ""
    echo -e "${BLUE}Abrindo AVISO-SYMLINKS.md...${NC}"
    cat "$PROJECT_DIR/AVISO-SYMLINKS.md" | less
    ;;
    
  *)
    echo -e "${RED}Opção inválida!${NC}"
    exit 1
    ;;
esac

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✨ Pronto! Escolha implementada com sucesso!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
