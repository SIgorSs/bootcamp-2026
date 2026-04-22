# AEM WKND - Bootcamp 2026

Projeto AEM com integração do Bootcamp 2026. Inclui componentes customizados para exibir produtos do Adobe Commerce e Content Fragments com GraphQL.

---

## 🚀 Quick Start

### 1. Clonar/Estruturar Projeto Maven

```bash
# AEM já está rodando localmente
# Acessar: http://localhost:4502

# Se quiser criar novo projeto Maven (opcional):
cd /home/igors/projects/bootcamp-2026/aem-wknd

# Usar Maven archetype
mvn archetype:generate \
  -DarchetypeGroupId=com.adobe.granite.archetypes \
  -DarchetypeArtifactId=aem-project-archetype \
  -DarchetypeVersion=LATEST \
  -DgroupId=com.example \
  -DartifactId=aem-bootcamp
```

### 2. Criar Content Fragment Model

1. **Acessar:** http://localhost:4502
2. **Tools > Assets > Content Fragment Models**
3. **Create > Create**
4. **Título:** "Produto Destaque"
5. **Adicionar campos:**
   - Text > titulo
   - Rich Text > descricao
   - Number > preco
   - Content Reference > imagem
   - Enumeration > categoria
   - Enumeration > stackTecnologico
   - Boolean > destaque
   - Text > linkExterno
6. **⚠️ ENABLE** (importante!)
7. **Save**

### 3. Fazer Upload de Imagens

1. **Assets > Files > WKND > Create Bootcamp Folder**
2. **Create Produtos Subfolder**
3. **Upload** 5 imagens dos produtos

### 4. Criar Content Fragments

1. **Assets > Files > WKND > Bootcamp > Produtos**
2. **Create > Content Fragment**
3. **Template:** Produto Destaque
4. **Preencher** todos os 8 campos para cada produto
5. **Publish**

### 5. Testar GraphQL

```bash
# GraphiQL Editor
open http://localhost:4502/content/graphql/global

# Query
query {
  produtoDestaqueList {
    items {
      titulo
      preco
      categoria
      stackTecnologico
      destaque
    }
  }
}
```

---

## 📁 Estrutura do Projeto Maven (Se Criar)

```
aem-bootcamp/
├── core/
│   └── src/main/java/com/example/core/models/
│       ├── ProductShowcase.java (Interface)
│       └── ProductShowcaseImpl.java (Implementação - Sling Model)
│
├── ui.apps/
│   └── src/main/content/jcr_root/apps/wknd/components/productshowcase/
│       ├── .content.xml (Metadados do componente)
│       ├── _cq_dialog/.content.xml (Dialog do Page Editor)
│       ├── productshowcase.html (Template HTL)
│       └── productshowcase.css (Estilos)
│
├── ui.frontend/
│   └── src/main/webpack/
│       └── bootcamp.css (Estilos Webpack)
│
└── pom.xml (Build config)
```

---

## 🔗 Componentes

### ProductShowcase (Sling Model)

**Objetivo:** Buscar produtos do Commerce e exibi-los na página

**Localização:** `core/src/main/java/com/example/core/models/`

**Funcionalidades:**
- Buscar API REST do Commerce (GET /V1/bootcamp/products)
- Parsear JSON com Gson
- Filtrar por destaque se configurado
- Timeout 5s
- Fallback se offline

**Como usar no Page Editor:**
1. Drag & drop "Product Showcase" na página
2. Configurar URL da API
3. Publicar

---

## 🧪 Teste

### GraphQL Query

```bash
# Listar todos
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{"query":"{ produtoDestaqueList { items { titulo } } }"}' | jq

# Esperado: 5 produtos

# Filtrar destaques
curl -X POST http://localhost:4502/content/graphql/global \
  -H 'Content-Type: application/json' \
  -u admin:admin \
  -d '{"query":"{ produtoDestaqueList(filter: { destaque: { _expressions: [{ value: true }] } }) { items { titulo } } }"}' | jq

# Esperado: 3 produtos
```

### Build e Deploy (Se usar Maven)

```bash
# Build completo
mvn clean install -PautoInstallPackage

# Build específico
mvn clean install -pl core,ui.apps,ui.frontend

# Deploy apenas
mvn -PautoInstallSinglePackage install
```

---

## 📚 Content Fragments vs Experience Fragments

| Tipo | Uso | API |
|------|-----|-----|
| **Content Fragment** | Conteúdo estruturado (produtos, artigos) | GraphQL |
| **Experience Fragment** | Componentes reutilizáveis (banners, blocos) | JSON (model.json) |

Para este projeto:
- **Content Fragments:** Produtos (usado por Hydrogen e Componente AEM)
- **Experience Fragments:** Banners (usado por Commerce)

---

## 🚀 Deploy para AEM Cloud (Future)

```bash
# Quando migrar para Cloud Service
mvn clean install -PautoInstallPackage,cloud

# Deploy via pipeline CI/CD
git push → Cloud Manager → Deploy
```

---

## 📞 Links

- [AEM Documentation](https://experienceleague.adobe.com/docs/experience-manager-65/content/implementing/home)
- [GraphQL in AEM](https://experienceleague.adobe.com/docs/experience-manager-65/content/headless/graphql-api/graphql-api-content-fragments.html)
- [Sling Models](https://sling.apache.org/documentation/bundles/models.html)

---

**Status:** ✅ Ready for Development

Mais informações em [../../README.md](../../README.md)
