/**
 * Rota: /about
 * Página com conteúdo do AEM (integração)
 * Busca Content Fragments via GraphQL do AEM
 */

export async function loader(context) {
  try {
    const aemUrl = context.queryShop.aemAuthorUrl || 'http://localhost:4502';
    const aemUsername = context.queryShop.aemUsername || 'admin';
    const aemPassword = context.queryShop.aemPassword || 'admin';

    // Autenticação Basic
    const auth = btoa(`${aemUsername}:${aemPassword}`);

    // Query GraphQL para AEM
    const query = `
      {
        produtoDestaqueList(filter: { destaque: { _expressions: [{ value: true }] } }) {
          items {
            titulo
            descricao {
              plaintext
            }
            preco
            categoria
            stackTecnologico
            destaque
            imagem {
              _path
            }
            linkExterno
          }
        }
      }
    `;

    const response = await fetch(`${aemUrl}/content/graphql/global`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Basic ${auth}`,
      },
      body: JSON.stringify({ query }),
    });

    if (!response.ok) {
      throw new Error('AEM offline');
    }

    const data = await response.json();

    return {
      products: data.data?.produtoDestaqueList?.items || [],
      source: 'aem-live',
    };
  } catch (error) {
    console.error('Erro ao buscar conteúdo do AEM:', error);

    // Fallback: conteúdo estático
    return {
      products: [
        {
          titulo: 'Camiseta Bootcamp 2026',
          descricao: { plaintext: 'Camiseta oficial com logo' },
          preco: 89.9,
          categoria: 'Vestuário',
          stackTecnologico: 'React',
          destaque: true,
          linkExterno: '#',
        },
      ],
      source: 'aem-static',
      error: 'AEM offline, usando cache',
    };
  }
}

export default function About({products, source, error}) {
  return (
    <div className="about">
      <div className="container">
        <h1>Sobre o Bootcamp 2026</h1>

        {error && (
          <div className="alert alert-warning">
            ⚠️ {error}
          </div>
        )}

        <div className="content">
          <p>
            Este projeto integra três plataformas de e-commerce e gerenciamento de conteúdo:
          </p>
          <ul>
            <li>Adobe Commerce (Catálogo)</li>
            <li>AEM (Conteúdo)</li>
            <li>Shopify (Loja Headless)</li>
          </ul>

          <h2>Produtos em Destaque (via {source === 'aem-live' ? '🟢 AEM' : '⚪ Fallback'})</h2>

          {products && products.length > 0 ? (
            <div className="products-grid">
              {products.map((product, index) => (
                <div key={index} className="product-card">
                  <h3>{product.titulo}</h3>
                  <p className="description">{product.descricao.plaintext}</p>
                  <div className="meta">
                    <span className="price">R$ {product.preco}</span>
                    <span className="category">{product.categoria}</span>
                    <span className="tech-stack">{product.stackTecnologico}</span>
                  </div>
                  {product.linkExterno && (
                    <a href={product.linkExterno} className="btn">
                      Saiba Mais
                    </a>
                  )}
                </div>
              ))}
            </div>
          ) : (
            <p className="empty">Nenhum produto disponível no momento.</p>
          )}
        </div>
      </div>
    </div>
  );
}
