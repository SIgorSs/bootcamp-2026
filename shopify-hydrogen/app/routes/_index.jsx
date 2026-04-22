/**
 * Rota: / (Homepage)
 * Exibe produtos em destaque da coleção "destaques"
 * Integração com Shopify Storefront API
 */

import {useShopQuery} from '@shopify/hydrogen';
import ProductCard from '~/components/ProductCard.client';

export default function Homepage() {
  return (
    <div className="homepage">
      <header className="hero">
        <h1>Bem-vindo ao Bootcamp 2026</h1>
        <p>Integração Adobe Commerce + AEM + Shopify</p>
        <a href="/about" className="btn btn-primary">
          Conheça nosso conteúdo
        </a>
      </header>

      <Destaques />
    </div>
  );
}

/**
 * Componente: Produtos em Destaque
 * Busca coleção "destaques" via Storefront API
 */
function Destaques() {
  const {data} = useShopQuery({
    query: DESTAQUES_QUERY,
    variables: {
      handle: 'destaques',
      first: 4,
    },
  });

  const collection = data?.collection;

  if (!collection) {
    return <div>Carregando produtos...</div>;
  }

  return (
    <section className="destaques">
      <div className="container">
        <h2>Produtos em Destaque</h2>
        <div className="grid">
          {collection.products.edges.map(({node: product}) => (
            <ProductCard
              key={product.id}
              product={product}
              highlight={product.metafields?.find(
                (m) => m.key === 'highlight_badge'
              )?.value}
              techStack={product.metafields?.find(
                (m) => m.key === 'tech_stack'
              )?.value}
            />
          ))}
        </div>
      </div>
    </section>
  );
}

const DESTAQUES_QUERY = `
  query getDestaques($handle: String!, $first: Int) {
    collection(handle: $handle) {
      products(first: $first) {
        edges {
          node {
            id
            handle
            title
            description
            onlineStoreUrl
            priceRange {
              minVariantPrice {
                amount
                currencyCode
              }
            }
            compareAtPriceRange {
              maxVariantPrice {
                amount
                currencyCode
              }
            }
            metafields(identifiers: [
              { namespace: "custom", key: "tech_stack" }
              { namespace: "custom", key: "highlight_badge" }
              { namespace: "custom", key: "bootcamp_year" }
            ]) {
              namespace
              key
              value
            }
            featuredImage {
              url
              altText
            }
            variants(first: 1) {
              edges {
                node {
                  id
                  title
                  availableForSale
                  selectedOptions {
                    name
                    value
                  }
                  priceV2 {
                    amount
                    currencyCode
                  }
                }
              }
            }
          }
        }
      }
    }
  }
`;
