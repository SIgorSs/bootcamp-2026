# Adobe Commerce - Módulos Bootcamp

## 📦 Módulos Inclusos

### 1. Bootcamp_CatalogApi
API REST que retorna produtos com atributos customizados.

**Endpoint:** `GET /rest/V1/bootcamp/products`

**Localização:** `app/code/Bootcamp/CatalogApi/`

**Arquivos:**
- `registration.php` - Registrar módulo
- `etc/module.xml` - Configuração do módulo
- `etc/di.xml` - Injeção de dependência
- `etc/webapi.xml` - Rota da API REST
- `Api/ProductListInterface.php` - Interface
- `Model/ProductList.php` - Implementação

**Instalação:**
```bash
cd /home/igors/projects/magento2

# Copiar módulo
cp -r /home/igors/projects/bootcamp-2026/adobe-commerce/app/code/Bootcamp app/code/

# Ativar
php bin/magento module:enable Bootcamp_CatalogApi

# Setup
php bin/magento setup:upgrade
php bin/magento cache:flush
```

**Teste:**
```bash
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq
```

---

### 2. Bootcamp_AemContent
Bloco que integra conteúdo do AEM (Experience Fragments) na homepage do Commerce.

**Localização:** `app/code/Bootcamp/AemContent/`

**Arquivos:**
- `registration.php` - Registrar módulo
- `etc/module.xml` - Configuração
- `etc/di.xml` - DI Config
- `Block/AemBanner.php` - Lógica do banner (busca XF do AEM)
- `templates/aem-banner.phtml` - Template HTML/CSS

**Instalação:**
```bash
# Copiar módulo
cp -r /home/igors/projects/bootcamp-2026/adobe-commerce/app/code/Bootcamp/AemContent app/code/Bootcamp/

# Ativar
php bin/magento module:enable Bootcamp_AemContent
php bin/magento setup:upgrade
php bin/magento cache:flush
```

**Uso:**
1. Acessar Admin: Content > Pages > Home
2. Add Block: `{{block class="Bootcamp\AemContent\Block\AemBanner"}}`
3. Save & Publish

---

## 🔗 Integração com Outros Serviços

### Commerce → AEM
- CatalogApi retorna produtos
- Hydrogen consome via REST

### Commerce → Hydrogen
- Storefront API do Hydrogen busca produtos Commerce
- (Ou REST API se necessário)

### AEM → Commerce
- AemContent busca XF do AEM
- Exibe na homepage do Commerce

### AEM → Hydrogen
- Hydrogen busca Content Fragments via GraphQL
- Usa Basic Auth (admin:admin)

---

## 📚 Documentação

- **README.md** - Visão geral do projeto
- **docs/endpoints.md** - Endpoints e exemplos
- **docs/arquitetura.md** - Diagramas de fluxos
- **docs/checklist.md** - Checklist dos 7 dias
- **SETUP.md** - Guia passo a passo

---

## 🧪 Testes

### Teste da API CatalogApi

```bash
# Listar todos os produtos
curl -s https://app.magento2.test/rest/V1/bootcamp/products | jq

# Esperado: 5 produtos com sku iniciando por BOOT-
```

### Teste do Banner AEM

```bash
# Verificar se bloco carrega na página
curl -s https://app.magento2.test/ | grep -A5 "aem-banner"
```

---

**Status:** ✅ Pronto para usar

Mais informações em [../../README.md](../../README.md)
