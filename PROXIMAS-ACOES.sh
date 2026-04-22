#!/bin/bash

# 🎯 PRÓXIMAS AÇÕES - GUIA RÁPIDO
# O que fazer depois de concluir o setup Git Flow

echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                          ║"
echo "║              🎯 PRÓXIMAS AÇÕES - DEPOIS DO SETUP GIT FLOW 🎯            ║"
echo "║                                                                          ║"
echo "║                   Seu Git Flow está 100% pronto!                        ║"
echo "║                      Siga estes passos agora:                           ║"
echo "║                                                                          ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}⏱️  TEMPO TOTAL: 30-60 minutos${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

# Passo 1
echo -e "${BLUE}1️⃣  LER DOCUMENTAÇÃO (5 minutos)${NC}"
echo "───────────────────────────────────────"
echo ""
echo "Leia nesta ordem:"
echo ""
echo -e "${GREEN}cat COMECE-AQUI.txt${NC}     ← LEIA ESTE PRIMEIRO! (guia visual)"
echo -e "${GREEN}cat BRANCHES-QUICK.md${NC}   ← Referência do dia-a-dia"
echo ""
echo "⏱️  Tempo: 5 minutos"
echo ""

# Passo 2
echo -e "${BLUE}2️⃣  CRIAR REPOSITÓRIO (5 minutos)${NC}"
echo "──────────────────────────────────────"
echo ""
echo "Escolha GitHub ou GitLab:"
echo ""
echo "OPÇÃO A - GitHub (recomendado):"
echo "  1. Abrir: https://github.com/new"
echo "  2. Nome: bootcamp-2026"
echo "  3. Descrição: Adobe AEM + Commerce + Shopify Bootcamp"
echo "  4. Visibility: Public (ou Private)"
echo "  5. NÃO selecionar: Initialize with README"
echo "  6. Clicar: Create Repository"
echo ""
echo "OPÇÃO B - GitLab:"
echo "  1. Abrir: https://gitlab.com/projects/new"
echo "  2. Nome: bootcamp-2026"
echo "  3. Visibility: Public (ou Private)"
echo "  4. Clicar: Create project"
echo ""
echo "⏱️  Tempo: 5 minutos"
echo ""

# Passo 3
echo -e "${BLUE}3️⃣  CONFIGURAR SSH (10 minutos - OPCIONAL)${NC}"
echo "────────────────────────────────────────────"
echo ""
echo "Se já tem SSH configurado, pule para Passo 4."
echo ""
echo "Se não tem, executar:"
echo ""
echo -e "${YELLOW}# Verificar${NC}"
echo "  ls ~/.ssh/id_rsa"
echo ""
echo -e "${YELLOW}# Se não existir, criar:${NC}"
echo "  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N \"\""
echo ""
echo -e "${YELLOW}# Copiar chave pública:${NC}"
echo "  cat ~/.ssh/id_rsa.pub"
echo ""
echo -e "${YELLOW}# Ir para GitHub/GitLab e adicionar a chave:${NC}"
echo "  GitHub: Settings → SSH and GPG keys → New SSH key"
echo "  GitLab: Edit profile → SSH Keys"
echo ""
echo -e "${YELLOW}# Testar:${NC}"
echo "  ssh -T git@github.com    # GitHub"
echo "  ssh -T git@gitlab.com    # GitLab"
echo ""
echo "⏱️  Tempo: 10 minutos (opcional)"
echo ""

# Passo 4
echo -e "${BLUE}4️⃣  FAZER PUSH (5 minutos)${NC}"
echo "───────────────────────────"
echo ""
echo "Executar no terminal (substitua SEU-USERNAME):"
echo ""
echo -e "${YELLOW}cd /home/igors/projects/bootcamp-2026${NC}"
echo ""
echo "GITHUB (via SSH):"
echo -e "${YELLOW}git remote add origin git@github.com:SEU-USERNAME/bootcamp-2026.git${NC}"
echo ""
echo "OU GITLAB (via SSH):"
echo -e "${YELLOW}git remote add origin git@gitlab.com:SEU-USERNAME/bootcamp-2026.git${NC}"
echo ""
echo "Depois disso:"
echo -e "${YELLOW}git branch -M main${NC}"
echo -e "${YELLOW}git push -u origin main${NC}"
echo -e "${YELLOW}git push -u origin develop${NC}"
echo -e "${YELLOW}git push -u origin feature/gitflow-setup${NC}"
echo ""
echo "⏱️  Tempo: 5 minutos"
echo ""

# Passo 5
echo -e "${BLUE}5️⃣  CRIAR PULL REQUEST (5 minutos)${NC}"
echo "─────────────────────────────────────"
echo ""
echo "No GitHub/GitLab:"
echo ""
echo "1. Abrir seu repositório"
echo "2. Ir para aba: Pull Requests (GitHub) ou Merge Requests (GitLab)"
echo "3. Novo PR/MR"
echo "4. From: feature/gitflow-setup → To: develop"
echo "5. Título: '🌳 Setup: Git Flow configurado'"
echo "6. Descrição:"
echo "   Git Flow com:"
echo "   - Branches main, develop, feature/*"
echo "   - Pre-commit hooks"
echo "   - Template de commit com emojis"
echo "   - Documentação completa"
echo "7. Criar Pull Request"
echo "8. Revisar mudanças"
echo "9. Fazer merge"
echo ""
echo "⏱️  Tempo: 5 minutos"
echo ""

# Passo 6
echo -e "${BLUE}6️⃣  ATUALIZAR LOCAL (2 minutos)${NC}"
echo "─────────────────────────────────"
echo ""
echo -e "${YELLOW}git checkout develop${NC}"
echo -e "${YELLOW}git pull${NC}"
echo -e "${YELLOW}git branch -d feature/gitflow-setup${NC}"
echo ""
echo "⏱️  Tempo: 2 minutos"
echo ""

# Passo 7
echo -e "${BLUE}7️⃣  COMEÇAR FASE 1 (próximas 40-60 horas)${NC}"
echo "────────────────────────────────────────"
echo ""
echo -e "${YELLOW}git checkout -b feature/fase-1-magento-setup${NC}"
echo ""
echo "Agora seguir SETUP.md para Dias 11-14:"
echo "  ✅ Criar atributos em Magento"
echo "  ✅ Criar categorias"
echo "  ✅ Criar 5 produtos"
echo "  ✅ Ativar módulo CatalogApi"
echo "  ✅ Testar API endpoint"
echo ""
echo -e "${YELLOW}cat SETUP.md${NC}"
echo ""
echo "⏱️  Tempo: 40-60 horas"
echo ""

# Resumo
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}📊 RESUMO${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

cat << 'TABLE'
PASSO | AÇÃO                    | TEMPO   | STATUS
──────┼─────────────────────────┼─────────┼─────────────
1️⃣   | Ler documentação         | 5 min   | [ ] TODO
2️⃣   | Criar repositório        | 5 min   | [ ] TODO
3️⃣   | Configurar SSH           | 10 min  | [ ] OPCIONAL
4️⃣   | Fazer push              | 5 min   | [ ] TODO
5️⃣   | Criar Pull Request      | 5 min   | [ ] TODO
6️⃣   | Atualizar local         | 2 min   | [ ] TODO
7️⃣   | Começar Fase 1          | 40-60h  | [ ] TODO
──────┴─────────────────────────┴─────────┴─────────────
       TOTAL (sem Fase 1)       | 32 min
TABLE

echo ""

# Comandos rápidos
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}⚡ COMANDOS RÁPIDOS (copie e cole)${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

echo "GITHUB:"
echo -e "${YELLOW}cd /home/igors/projects/bootcamp-2026 && \\"
echo "git remote add origin git@github.com:SEU-USERNAME/bootcamp-2026.git && \\"
echo "git branch -M main && \\"
echo "git push -u origin main develop feature/gitflow-setup${NC}"
echo ""

echo "GITLAB:"
echo -e "${YELLOW}cd /home/igors/projects/bootcamp-2026 && \\"
echo "git remote add origin git@gitlab.com:SEU-USERNAME/bootcamp-2026.git && \\"
echo "git branch -M main && \\"
echo "git push -u origin main develop feature/gitflow-setup${NC}"
echo ""

# Verificação
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}✅ COMO VERIFICAR QUE ESTÁ TUDO FUNCIONANDO${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

echo "Depois de fazer push:"
echo ""
echo -e "${YELLOW}git branch -a${NC}              # Deve mostrar: main, develop, feature/gitflow-setup"
echo -e "${YELLOW}git remote -v${NC}"
echo ""
echo "Verá algo como:"
echo "  origin  git@github.com:username/bootcamp-2026.git (fetch)"
echo "  origin  git@github.com:username/bootcamp-2026.git (push)"
echo ""

echo "No GitHub/GitLab:"
echo "  ✅ Ver 3 branches"
echo "  ✅ Ver histórico de commits"
echo "  ✅ PR/MR pronto para merge"
echo ""

# Próxima informação
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}🎓 CONSULTE QUANDO PRECISAR${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo ""

echo "Documentação disponível:"
echo ""
echo "  📖 cat COMECE-AQUI.txt" 
echo "  📖 cat BRANCHES-QUICK.md"
echo "  📖 cat GIT-CHEAT-SHEET.md"
echo "  📖 cat BRANCHES-WORKFLOW.md"
echo "  📖 cat PUSH-GITHUB-GITLAB.sh"
echo ""

# Status final
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ TUDO PRONTO!${NC}"
echo ""
echo "Você tem:"
echo "  ✅ Git Flow configurado"
echo "  ✅ Branches setup concluído"
echo "  ✅ Feature/gitflow-setup pronta"
echo "  ✅ Documentação completa"
echo "  ✅ Instruções passo-a-passo"
echo ""
echo "Agora precisa de:"
echo "  ⏳ 30 minutos → Push e PR (Passos 1-6)"
echo "  ⏳ Amanhã → Começar Fase 1 (Passo 7)"
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${PURPLE}📞 PRECISA DE AJUDA?${NC}"
echo ""
echo "  Dúvidas sobre Git? →     cat GIT-CHEAT-SHEET.md"
echo "  Como fazer push? →       cat PUSH-GITHUB-GITLAB.sh"
echo "  Workflow completo? →     cat BRANCHES-WORKFLOW.md"
echo "  Começar? →               cat COMECE-AQUI.txt"
echo ""
echo -e "${PURPLE}Sucesso! 🚀${NC}"
echo ""
