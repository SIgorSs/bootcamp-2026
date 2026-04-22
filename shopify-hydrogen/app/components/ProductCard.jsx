/**
 * Componente: ProductCard
 * Cartão de produto reutilizável
 * Exibe: imagem, título, preço, desconto, tech stack, highlight badge
 */

export default function ProductCard({
  product,
  highlight = null,
  techStack = null,
  className = '',
}) {
  const {
    id,
    title,
    handle,
    description,
    featuredImage,
    priceRange,
    compareAtPriceRange,
  } = product;

  const price = parseFloat(priceRange?.minVariantPrice?.amount || 0);
  const comparePrice = parseFloat(compareAtPriceRange?.maxVariantPrice?.amount || 0);
  const discount = comparePrice > price ? Math.round(((comparePrice - price) / comparePrice) * 100) : 0;

  return (
    <article className={`product-card ${className}`}>
      <div className="product-card__image">
        {featuredImage && (
          <img
            src={`${featuredImage.url}?width=400&height=400`}
            alt={featuredImage.altText || title}
            loading="lazy"
          />
        )}
        {discount > 0 && (
          <div className="product-card__discount">
            -{discount}%
          </div>
        )}
      </div>

      <div className="product-card__content">
        <h3 className="product-card__title">{title}</h3>

        {techStack && (
          <span className="product-card__tech-stack">{techStack}</span>
        )}

        {highlight && (
          <span className="product-card__highlight">
            {highlight}
          </span>
        )}

        <p className="product-card__description">
          {description?.substring(0, 100)}...
        </p>

        <div className="product-card__price">
          {comparePrice > price && (
            <span className="product-card__compare-price">
              ${comparePrice.toFixed(2)}
            </span>
          )}
          <span className="product-card__current-price">
            ${price.toFixed(2)}
          </span>
        </div>

        <a
          href={`/products/${handle}`}
          className="product-card__link"
        >
          Ver Produto →
        </a>
      </div>
    </article>
  );
}
