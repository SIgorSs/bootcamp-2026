<?php

namespace Bootcamp\CatalogApi\Api;

/**
 * Interface ProductListInterface
 * Define métodos para obter lista de produtos do Bootcamp
 */
interface ProductListInterface
{
    /**
     * Retorna lista de produtos com atributos customizados
     *
     * @return \Bootcamp\CatalogApi\Api\Data\ProductInterface[]
     */
    public function getList();
}
