<?php

namespace Bootcamp\AemContent\Block;

use Magento\Framework\View\Element\Template;
use Magento\Framework\HTTP\Client\Curl;
use Psr\Log\LoggerInterface;

class AemBanner extends Template
{
    /**
     * @var Curl
     */
    private $httpClient;

    /**
     * @var LoggerInterface
     */
    private $logger;

    /**
     * URL do Experience Fragment no AEM
     */
    const AEM_XF_URL = 'http://localhost:4502/content/experience-fragments/wknd/bootcamp-banner/master.json';

    /**
     * Timeout padrão (segundos)
     */
    const AEM_TIMEOUT = 5;

    /**
     * AemBanner constructor
     *
     * @param Template\Context $context
     * @param Curl $httpClient
     * @param LoggerInterface $logger
     * @param array $data
     */
    public function __construct(
        Template\Context $context,
        Curl $httpClient,
        LoggerInterface $logger,
        array $data = []
    ) {
        parent::__construct($context, $data);
        $this->httpClient = $httpClient;
        $this->logger = $logger;
    }

    /**
     * Busca conteúdo do Experience Fragment do AEM
     *
     * @return array
     */
    public function getBannerContent()
    {
        try {
            $this->httpClient->setTimeout(self::AEM_TIMEOUT);
            $this->httpClient->get(self::AEM_XF_URL);

            $response = $this->httpClient->getBody();
            $data = json_decode($response, true);

            if (isset($data['title']) && isset($data['description'])) {
                return [
                    'title' => $data['title'],
                    'description' => $data['description'],
                    'image_url' => $data['image_url'] ?? null,
                    'cta_url' => $data['cta_url'] ?? null,
                    'cta_text' => $data['cta_text'] ?? 'Saiba Mais',
                    'source' => 'aem-live'
                ];
            }

            return $this->getFallbackBanner();
        } catch (\Exception $e) {
            $this->logger->error('Erro ao buscar banner do AEM: ' . $e->getMessage());
            return $this->getFallbackBanner();
        }
    }

    /**
     * Banner fallback (quando AEM está offline)
     *
     * @return array
     */
    private function getFallbackBanner()
    {
        return [
            'title' => 'Bem-vindo ao Bootcamp 2026',
            'description' => 'Integração entre Adobe Commerce, AEM e Shopify',
            'image_url' => null,
            'cta_url' => '#',
            'cta_text' => 'Explorar',
            'source' => 'fallback'
        ];
    }

    /**
     * Verificar se banner está disponível
     *
     * @return bool
     */
    public function hasBanner()
    {
        return !empty($this->getBannerContent());
    }

    /**
     * Verificar se é conteúdo do AEM (live)
     *
     * @return bool
     */
    public function isAemLive()
    {
        $content = $this->getBannerContent();
        return isset($content['source']) && $content['source'] === 'aem-live';
    }
}
