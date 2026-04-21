## 🎉 Bootcamp 2026 - Setup Completo!

### ✅ O que foi criado:

```
bootcamp-2026/
│
├─ 📋 README.md                    ← Visão geral e arquitetura
├─ 🚀 SETUP.md                     ← Guia passo a passo detalhado
├─ .gitignore                      ← Configuração Git
│
├─ 📚 docs/
│  ├─ endpoints.md                 ← URLs, tokens, exemplos de cURL
│  ├─ arquitetura.md               ← Diagramas de fluxos
│  └─ checklist.md                 ← Checklist dos 7 dias
│
├─ 🔧 adobe-commerce/
│  ├─ README.md                    ← Instruções rápidas
│  └─ app/code/Bootcamp/
│     ├─ CatalogApi/               ← Módulo API REST (FASE 1)
│     │  ├─ registration.php
│     │  ├─ etc/ (module.xml, di.xml, webapi.xml)
│     │  ├─ Api/ProductListInterface.php
│     │  └─ Model/ProductList.php
│     │
│     └─ AemContent/               ← Módulo Banner AEM (FASE 6)
│        ├─ registration.php
│        ├─ etc/ (module.xml, di.xml)
│        ├─ Block/AemBanner.php
│        └─ templates/aem-banner.phtml
│
├─ 🏗️ aem-wknd/
│  └─ README.md                    ← Estrutura Maven + Content Fragments
│
├─ 🛍️ shopify-theme/
│  ├─ sections/
│  │  └─ bootcamp-products.liquid  ← Seção customizada (FASE 4)
│  │
│  └─ assets/
│     └─ bootcamp-products.css     ← Estilos BEM
│
└─ ⚛️ shopify-hydrogen/
   ├─ README.md                    ← Instruções Hydrogen
   ├─ .env.example                 ← Template de env
   ├─ index.jsx.example            ← Homepage (FASE 5)
   ├─ about.jsx.example            ← Página com conteúdo AEM
   └─ ProductCard.jsx.example      ← Componente reutilizável
```

---

## 🚀 Como Começar (em ordem):

### ORDEM RECOMENDADA:

#### **Fase 1 (Dias 11-14): Adobe Commerce**
1. Ler: [SETUP.md](SETUP.md) seção "1️⃣ SETUP: Adobe Commerce"
2. Criar atributos: `bootcamp_highlight`, `tech_stack`
3. Criar categorias
4. Criar 5 produtos
5. Ativar módulo `Bootcamp_CatalogApi`
6. Testar API: `curl https://app.magento2.test/rest/V1/bootcamp/products`

**Arquivo:** [adobe-commerce/README.md](adobe-commerce/README.md)

---

#### **Fase 2 (Dia 12): AEM Content Fragments**
1. Ler: [SETUP.md](SETUP.md) seção "2️⃣ SETUP: AEM"
2. Criar Content Fragment Model "Produto Destaque"
3. Fazer upload de imagens
4. Criar 5 Content Fragments
5. Testar GraphQL no GraphiQL
6. Criar Persisted Query

**Arquivo:** [aem-wknd/README.md](aem-wknd/README.md)

---

#### **Fase 4 (Dia 13): Shopify**
1. Ler: [SETUP.md](SETUP.md) seção "3️⃣ SETUP: Shopify"
2. Criar Shopify Store
3. Criar Metafield Definitions
4. Criar 5 produtos com metafields
5. Criar 4 coleções
6. Adicionar seção `bootcamp-products.liquid` ao tema

**Arquivo:** [shopify-theme/](shopify-theme/)

---

#### **Fase 5 (Dia 16): Shopify Hydrogen**
1. Ler: [SETUP.md](SETUP.md) seção "4️⃣ SETUP: Shopify Hydrogen"
2. Inicializar projeto: `npx @shopify/create-hydrogen@latest`
3. Configurar `.env`
4. Copiar arquivos `.jsx.example` → `.jsx`
5. Rodar: `npm run dev`

**Arquivo:** [shopify-hydrogen/README.md](shopify-hydrogen/README.md)

---

#### **Fase 3 (Dia 15): Integração AEM + Commerce**
1. Ler: [docs/arquitetura.md](docs/arquitetura.md)
2. Criar Componente ProductShowcase (Maven)
3. Ativar módulo `Bootcamp_AemContent`

---

#### **Fase 6 (Dia 17): Integração Final**
1. Criar Experience Fragment no AEM
2. Testar banner na homepage do Commerce
3. Testar página /about no Hydrogen com conteúdo AEM

---

## 📖 Documentação Rápida

| Arquivo | Objetivo | Quando usar |
|---------|----------|------------|
| [README.md](README.md) | Visão geral do projeto | Entender arquitetura geral |
| [SETUP.md](SETUP.md) | Guia passo a passo | Seguir durante desenvolvimento |
| [docs/endpoints.md](docs/endpoints.md) | URLs e exemplos cURL | Testar APIs |
| [docs/arquitetura.md](docs/arquitetura.md) | Diagramas de fluxos | Entender integrações |
| [docs/checklist.md](docs/checklist.md) | Checklist dos 7 dias | Rastrear progresso |

---

## 🧪 Verificação Rápida

### ✅ Tudo Pronto?

```bash
# 1. Verificar estrutura criada
ls -la /home/igors/projects/bootcamp-2026/

# 2. Iniciar Commerce (se não estiver rodando)
cd /home/igors/projects/magento2
php bin/magento

# 3. Iniciar AEM (se não estiver rodando)
cd /home/igors/projects/aem
docker-compose up

# 4. Verificar acesso
curl -s https://app.magento2.test/admin 2>&1 | head -3
curl -s http://localhost:4502 2>&1 | head -3
```

---

## 🎯 Objetivos por Fase

| Fase | Objetivo | Status |
|------|----------|--------|
| 1 | API REST Commerce retorna 5 produtos | 📋 Arquivos prontos |
| 2 | Content Fragments no AEM com GraphQL | 📋 Documentação pronta |
| 3 | Componente AEM busca Commerce | 📋 Exemplos prontos |
| 4 | Seção Shopify com metafields | 📋 Código pronto |
| 5 | Hydrogen rodando localmente | 📋 Estrutura pronta |
| 6 | AEM integrado em Hydrogen e Commerce | 📋 Exemplos prontos |

---

## 📞 Precisa de Ajuda?

1. **Entender fluxos?** → Ler [docs/arquitetura.md](docs/arquitetura.md)
2. **Exemplos de API?** → Consultar [docs/endpoints.md](docs/endpoints.md)
3. **Passo a passo?** → Seguir [SETUP.md](SETUP.md)
4. **Rastrear progresso?** → Usar [docs/checklist.md](docs/checklist.md)
5. **Módulos específicos?** → Ver READMEs nas pastas

---

## 💡 Tips

- ✅ Sempre verificar módulos antes de ativar: `php bin/magento module:status`
- ✅ Limpar cache após alterações: `php bin/magento cache:flush`
- ✅ Testar GraphQL no GraphiQL: `http://localhost:4502/content/graphql/global`
- ✅ Usar `jq` para formatar JSON em curl: `curl ... | jq`
- ✅ Salvar tokens em `.env` (nunca em git!)

---

## 🚀 Próximo Passo

👉 **Leia [SETUP.md](SETUP.md) e comece pela Fase 1!**

---

**Criado em:** Abril 2026  
**Versão:** 1.0.0  
**Status:** ✅ Pronto para Bootcamp!
