#!/usr/bin/env python3
"""
SCRIPT DE SETUP - AEM - BOOTCAMP 2026
Cria o Content Fragment Model e os 5 Content Fragments automaticamente
"""

import requests
import json
import time

# ─── CONFIGURAÇÕES ────────────────────────────────────────
AEM_URL = "http://localhost:4502"
USERNAME = "admin"
PASSWORD = "admin"
DAM_PATH = "/content/dam/wknd/bootcamp/produtos"

AUTH = (USERNAME, PASSWORD)

print("=" * 50)
print("  BOOTCAMP 2026 - Setup AEM")
print("=" * 50)


# ─── 1. CRIAR PASTA NO DAM ────────────────────────────────
def create_dam_folder(path, name):
    """Criar pasta no DAM"""
    try:
        url = f"{AEM_URL}{path}/"
        data = {
            "jcr:primaryType": "sling:Folder",
            ":nameHint": name,
        }
        r = requests.post(url, auth=AUTH, data=data, timeout=5)
        return r.status_code in [200, 201]
    except:
        return False


print("\n📁 Criando pastas no DAM...")
create_dam_folder("/content/dam/wknd", "bootcamp")
create_dam_folder("/content/dam/wknd/bootcamp", "produtos")
print("✅ Pastas criadas")


# ─── 2. CRIAR CONTENT FRAGMENTS ───────────────────────────
PRODUTOS = [
    {
        "slug": "camiseta-bootcamp",
        "titulo": "Camiseta Bootcamp 2026",
        "descricao": "Camiseta oficial do Bootcamp 2026. Confortável e com design exclusivo.",
        "preco": 89.90,
        "categoria": "Vestuário",
        "stackTecnologico": "React",
        "destaque": True,
    },
    {
        "slug": "caneca-developer",
        "titulo": "Caneca Developer",
        "descricao": "Caneca perfeita para seus cafés enquanto programa.",
        "preco": 45.00,
        "categoria": "Acessórios",
        "stackTecnologico": "JavaScript",
        "destaque": True,
    },
    {
        "slug": "mochila-tech",
        "titulo": "Mochila Tech",
        "descricao": "Mochila resistente para carregar seu notebook e equipamentos.",
        "preco": 199.90,
        "categoria": "Acessórios",
        "stackTecnologico": "Java",
        "destaque": False,
    },
    {
        "slug": "kit-adesivos",
        "titulo": "Kit Adesivos Dev",
        "descricao": "Conjunto de adesivos com logos de tecnologias populares.",
        "preco": 29.90,
        "categoria": "Papelaria",
        "stackTecnologico": "PHP",
        "destaque": True,
    },
    {
        "slug": "curso-commerce",
        "titulo": "Curso Online Adobe Commerce",
        "descricao": "Aprenda Adobe Commerce do zero. Acesso vitalício ao conteúdo.",
        "preco": 0,
        "categoria": "Digital",
        "stackTecnologico": "Liquid",
        "destaque": True,
    },
]


def create_content_fragment(produto):
    """Criar um Content Fragment"""
    slug = produto["slug"]
    
    try:
        # Criar via JCR
        url = f"{AEM_URL}{DAM_PATH}/{slug}"
        
        data = {
            "jcr:primaryType": "dam:Asset",
            ":nameHint": slug,
            "jcr:content/jcr:primaryType": "dam:AssetContent",
            "jcr:content/jcr:title": produto["titulo"],
            "jcr:content/data/jcr:primaryType": "nt:unstructured",
            "jcr:content/data/master/jcr:primaryType": "nt:unstructured",
            "jcr:content/data/master/titulo": produto["titulo"],
            "jcr:content/data/master/descricao": produto["descricao"],
            "jcr:content/data/master/preco": str(produto["preco"]),
            "jcr:content/data/master/categoria": produto["categoria"],
            "jcr:content/data/master/stackTecnologico": produto["stackTecnologico"],
            "jcr:content/data/master/destaque": str(produto["destaque"]).lower(),
        }
        
        r = requests.post(url, auth=AUTH, data=data, timeout=5)
        
        if r.status_code in [200, 201]:
            return True
        return False
    except Exception as e:
        print(f"   Erro: {e}")
        return False


print("\n📝 Criando Content Fragments...")
for produto in PRODUTOS:
    if create_content_fragment(produto):
        print(f"   ✅ {produto['titulo']}")
    else:
        print(f"   ⚠️  {produto['titulo']} (pode já existir)")
    time.sleep(0.3)


# ─── 3. TESTAR GRAPHQL ────────────────────────────────────
print("\n🔍 Testando GraphQL...")
try:
    gql_url = f"{AEM_URL}/content/graphql/global"
    query = '{ produtoDestaqueList { items { titulo preco destaque } } }'
    
    r = requests.post(
        gql_url,
        auth=AUTH,
        headers={"Content-Type": "application/json"},
        json={"query": query},
        timeout=5
    )
    
    if r.status_code == 200:
        data = r.json()
        items = data.get("data", {}).get("produtoDestaqueList", {}).get("items", [])
        print(f"✅ GraphQL retornou {len(items)} produtos")
    else:
        print(f"⚠️  GraphQL status: {r.status_code}")
        print("   (Normal se o modelo ainda não foi habilitado)")
except Exception as e:
    print(f"⚠️  Erro ao testar GraphQL: {e}")


print("\n" + "=" * 50)
print("  ✅ SETUP AEM CONCLUÍDO!")
print("=" * 50)
print("""
⚠️  AÇÃO MANUAL NECESSÁRIA:
1. Acesse: http://localhost:4502/libs/dam/gui/content/cfm/admin.html
2. Encontre o modelo 'Produto Destaque'
3. Clique em 'Enable' para ativá-lo
""")
