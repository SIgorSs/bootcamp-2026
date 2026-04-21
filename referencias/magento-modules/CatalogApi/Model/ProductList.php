<?php

namespace Bootcamp\CatalogApi\Model;

use Magento\Catalog\Model\ProductFactory;
use Magento\Catalog\Model\ResourceModel\Product\CollectionFactory;
use Bootcamp\CatalogApi\Api\ProductListInterface;
use Psr\Log\LoggerInterface;

class ProductList implements ProductListInterface
{
    /**
     * @var ProductFactory
     */
    private $productFactory;

    /**
     * @var CollectionFactory
     */
    private $collectionFactory;

    /**
     * @var LoggerInterface
     */
    private $logger;

    /**
     * ProductList constructor
     *
     * @param ProductFactory $productFactory
     * @param CollectionFactory $collectionFactory
     * @param LoggerInterface $logger
     */
    public function __construct(
        ProductFactory $productFactory,
        CollectionFactory $collectionFactory,
        LoggerInterface $logger
    ) {
        $this->productFactory = $productFactory;
        $this->collectionFactory = $collectionFactory;
        $this->logger = $logger;
    }

    /**
     * Retorna produtos com SKU iniciado por "BOOT-"
     * com atributos customizados
     *
     * @return array
     */
    public function getList()
    {
        try {
            $collection = $this->collectionFactory->create();

            // Filtrar por SKU que começa com "BOOT-"
            $collection->addAttributeToFilter('sku', ['like' => 'BOOT-%']);

            // Adicionar atributos customizados
            $collection->addAttributeToSelect([
                'bootcamp_highlight',
                'tech_stack'
            ]);

            // Adicionar atributos padrão
            $collection->addAttributeToSelect([
                'sku',
                'name',
                'price',
                'type_id',
                'thumbnail',
                'image'
            ]);

            // Apenas produtos habilitados
            $collection->addAttributeToFilter('status', 1);

            $items = [];

            foreach ($collection as $product) {
                $items[] = [
                    'id' => $product->getId(),
                    'sku' => $product->getSku(),
                    'name' => $product->getName(),
                    'type' => $product->getTypeId(),
                    'price' => (float) $product->getPrice(),
                    'currency' => 'BRL',
                    'bootcamp_highlight' => (bool) $product->getBootcampHighlight(),
                    'tech_stack' => $product->getTechStack() ?? '',
                    'image_url' => $this->getProductImageUrl($product),
                    'description' => $product->getShortDescription() ?? $product->getDescription() ?? '',
                    'status' => (int) $product->getStatus(),
                    'visibility' => (int) $product->getVisibility()
                ];
            }

            return [
                'items' => $items,
                'total_count' => count($items)
            ];
        } catch (\Exception $e) {
            $this->logger->error('Bootcamp CatalogApi Error: ' . $e->getMessage());
            throw new \Magento\Framework\Webapi\Exception(
                __('Erro ao buscar produtos do Bootcamp'),
                0,
                \Magento\Framework\Webapi\Exception::HTTP_INTERNAL_ERROR
            );
        }
    }

    /**
     * Obter URL da imagem do produto
     *
     * @param \Magento\Catalog\Model\Product $product
     * @return string|null
     */
    private function getProductImageUrl($product)
    {
        try {
            if ($product->getThumbnail() && $product->getThumbnail() !== 'no_selection') {
                return $product->getThumbnail();
            }

            if ($product->getImage() && $product->getImage() !== 'no_selection') {
                return $product->getImage();
            }

            return null;
        } catch (\Exception $e) {
            $this->logger->warning('Erro ao obter imagem: ' . $e->getMessage());
            return null;
        }
    }
}
