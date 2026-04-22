# ⚠️ CUIDADO: Symlinks + Docker = Alterações em Tempo Real

## 🤔 Sua Pergunta

"Se eu fizer alteração no Magento via symlink, vai alterar o Magento rodando no Docker?"

**Resposta: SIM! Vai alterar em tempo real!** ⚠️

---

## 🔗 Como Funciona

```
Seu Computador (WSL)
    ↓
/home/igors/projects/magento2/ (DIRETÓRIO REAL)
    ↑ ↑
    │ └─ Symlink: /home/igors/projects/bootcamp-2026/magento2 → ../magento2
    │
    Docker Volume Mapping
    ↓
Docker Container Magento
    ↓
/var/www/html (mesmo arquivo!)
```

**Resumo:** O symlink aponta para o MESMO arquivo que o Docker está usando!

---

## ⚡ Exemplos

### Cenário 1: Editar arquivo via symlink

```bash
# Editar via symlink
vi /home/igors/projects/bootcamp-2026/magento2/app/code/Bootcamp/CatalogApi/Model/ProductList.php
```

### Cenário 2: Magento rodando no Docker

```bash
# O arquivo dentro do container mudou AUTOMATICAMENTE!
docker exec magento cat /var/www/html/app/code/Bootcamp/CatalogApi/Model/ProductList.php
# ✅ Mudanças visíveis!
```

### Cenário 3: Resultado

```
Antes:  ❌ Magento quebrado
         (ou funcionando)
         ↓
Alteração via symlink
         ↓
Depois: ⚠️ Magento pode quebrar
         (ou funcionar melhor)
         ↓
Docker vê mudança em tempo real!
```

---

## ⚠️ RISCOS

### Risco 1: Quebrar Magento em Produção
```
❌ Edita arquivo via symlink
❌ Manda errado
❌ Magento no Docker quebra
❌ Precisa fazer rollback rápido
```

### Risco 2: Cache Não Atualizar
```
❌ Edita PHP
❌ Docker vê mudança
⚠️ Mas cache do Magento não limpa
❌ Mudança não aparece
```

### Risco 3: Conflito de Múltiplos Devs
```
Dev 1 edita via symlink
Dev 2 edita na instalação Magento
...
Conflito! 💥
```

---

## ✅ SOLUÇÕES (ESCOLHA UMA)

### OPÇÃO 1: Usar Symlink + Cautela (RECOMENDADO para Dev)

**Vantagens:**
- ✅ Alterações em tempo real
- ✅ Testa mudanças vivo
- ✅ Mais rápido fazer push

**Desvantagens:**
- ❌ Pode quebrar produção
- ❌ Sem isolamento

**Usar quando:**
- Você está DESENVOLVENDO
- Quer ver mudanças ao vivo
- Ambiente é DEV/TEST

**Como usar:**
```bash
# 1. Editar via symlink
vi /home/igors/projects/bootcamp-2026/magento2/...

# 2. Limpar cache ANTES de testar
docker exec magento php bin/magento cache:flush

# 3. Testar no Docker
curl http://localhost/rest/V1/bootcamp/products

# 4. Se funcionou, fazer commit
cd /home/igors/projects/bootcamp-2026
cp -r ../magento2/app/code/Bootcamp/* referencias/magento-modules/
git add referencias/
git commit -m "🔧 Atualizar módulo"
```

---

### OPÇÃO 2: Copiar em Vez de Symlink (ISOLADO)

**Vantagens:**
- ✅ Isolamento total
- ✅ Não quebra Magento em produção
- ✅ Mais seguro

**Desvantagens:**
- ❌ Mudanças NÃO refletem ao vivo
- ❌ Precisa copiar manualmente

**Como setup:**

```bash
cd /home/igors/projects/bootcamp-2026

# 1. Remover symlinks
rm magento2 aem

# 2. Criar diretórios reais
mkdir -p magento-dev aem-dev

# 3. Copiar conteúdo ATUAL
cp -r ../magento2/app/code/Bootcamp magento-dev/
cp -r ../aem/* aem-dev/

# 4. Atualizar .gitignore
echo "magento-dev/" >> .gitignore
echo "aem-dev/" >> .gitignore

# 5. Commit
git add .gitignore
git commit -m "🔄 Mudar de symlinks para cópias isoladas"
```

**Como usar:**
```bash
# Editar em magento-dev (ISOLADO)
vi magento-dev/CatalogApi/Model/ProductList.php

# Quando testar de verdade, copiar para Magento real
cp -r magento-dev/* ../magento2/app/code/Bootcamp/

# Magento no Docker vê mudança
docker exec magento php bin/magento cache:flush

# Se funcionou, fazer commit
git add magento-dev/
git commit -m "✅ Módulo CatalogApi funcionando"
```

---

### OPÇÃO 3: Usar Branches + Merge (PARA TIME)

**Vantagens:**
- ✅ Isolamento por feature
- ✅ Fácil fazer rollback
- ✅ Múltiplos devs trabalhando

**Desvantagens:**
- ❌ Mais complexo
- ❌ Precisa fazer merge

**Como usar:**

```bash
cd /home/igors/projects/bootcamp-2026

# Branch para feature
git checkout -b feature/catalogo-api

# Editar com segurança
# ... mudanças ...

# Testar em Docker
# docker-compose restart

# Se ok, fazer commit
git add .
git commit -m "✨ Feature: Melhorar CatalogApi"

# Depois fazer merge em main
git checkout main
git merge feature/catalogo-api
git push origin main
```

---

## 🎯 RECOMENDAÇÃO (OPÇÃO 1 + SCRIPTS)

Usar symlink + criar scripts para sincronizar:

```bash
# Criar: sync-magento.sh
#!/bin/bash

echo "🔄 Sincronizando Magento..."

# 1. Copiar mudanças
cp -r /home/igors/projects/magento2/app/code/Bootcamp/* \
      /home/igors/projects/bootcamp-2026/referencias/magento-modules/

# 2. Limpar cache
docker exec magento php bin/magento cache:flush

# 3. Git commit
cd /home/igors/projects/bootcamp-2026
git add referencias/
git commit -m "🔧 Sincronizar Magento - $(date '+%Y-%m-%d %H:%M')"

echo "✅ Pronto!"
```

Depois rodar:
```bash
bash sync-magento.sh
```

---

## 📊 COMPARAÇÃO DAS 3 OPÇÕES

| Aspecto | Opção 1 (Symlink) | Opção 2 (Cópia) | Opção 3 (Branches) |
|--------|-------------------|-----------------|------------------|
| **Alterações ao vivo** | ✅ Sim | ❌ Não | ✅ Sim (por branch) |
| **Isolamento** | ❌ Não | ✅ Sim | ✅ Sim (por branch) |
| **Segurança** | ⚠️ Média | ✅ Alta | ✅ Alta |
| **Facilidade** | ✅ Fácil | ✅ Fácil | ⚠️ Média |
| **Para Dev** | ✅ Melhor | ❌ Não ideal | ✅ Bom |
| **Para Time** | ⚠️ Cuidado | ✅ Melhor | ✅ Melhor |

---

## 🚨 CHECKLIST DE SEGURANÇA

Se usar Opção 1 (Symlink), SEMPRE fazer:

- [ ] Limpar cache antes de testar: `docker exec magento php bin/magento cache:flush`
- [ ] Verificar em navegador: `https://app.magento2.test/`
- [ ] Rodar testes se tiver: `php bin/magento test:run`
- [ ] Copiar para Git: `cp -r ... referencias/`
- [ ] Fazer commit descritivo
- [ ] Fazer push
- [ ] **NUNCA** editar diretamente em produção via symlink

---

## 💡 MINHA RECOMENDAÇÃO

**Use OPÇÃO 1 (Symlink Atual) MAS com Scripts:**

```bash
# 1. Editar normalmente
vi /home/igors/projects/bootcamp-2026/magento2/...

# 2. Testar
docker exec magento php bin/magento cache:flush
curl http://localhost/rest/V1/bootcamp/products

# 3. Sincronizar (uso script)
bash /home/igors/projects/bootcamp-2026/sync-magento.sh

# 4. Ver resultado
git log --oneline | head -3
```

---

## ❓ CASOS ESPECIAIS

### Se está testando coisa perigosa?
```bash
# Use branch temporária
git checkout -b test/risky-change
# ... testa ...
# Se der errado: git checkout main
# Se der certo: git merge test/risky-change
```

### Se quer múltiplos Magento?
```bash
# Clone outro Magento em porta diferente
docker run -p 8081:80 magento:2.4 ...
# Cria symlink para outro
ln -s /outro/magento2 ./magento2-staging
```

### Se trabalha em time?
```bash
# Use Opção 3 (Branches)
# Cada dev em seu branch
# Pull request antes de merge
```

---

## ✅ PRÓXIMOS PASSOS

1. **Escolher uma opção** (recomendo Opção 1)
2. **Se Opção 1:** Criar script de sincronização
3. **Se Opção 2:** Remover symlinks e copiar
4. **Se Opção 3:** Criar branches e workflow
5. **Sempre:** Fazer backup antes de grandes mudanças

---

## 🎯 RESUMO

```
Symlink + Docker = Alterações em tempo real

Seguro para DEV? ✅ Sim (com cuidado)
Seguro para PRODUÇÃO? ⚠️ Não (use branches/cópias)

Recomendação: Use Opção 1 + Scripts + Testes
```

---

**Qual opção você quer implementar?** 🚀

A) Manter symlink (Opção 1) + criar script de sincronização
B) Mudar para cópias isoladas (Opção 2)
C) Usar branches para tudo (Opção 3)
