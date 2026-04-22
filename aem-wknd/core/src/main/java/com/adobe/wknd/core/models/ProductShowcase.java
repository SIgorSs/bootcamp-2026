package com.adobe.wknd.core.models;

import javax.inject.Inject;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.models.annotations.Model;
import org.apache.sling.models.annotations.injectorspecific.ValueMapValue;
import java.util.List;
import java.util.Map;

/**
 * Interface ProductShowcase
 * Define métodos para o componente ProductShowcase
 */
@Model(adaptables = { org.apache.sling.api.resource.Resource.class, org.apache.sling.api.SlingHttpServletRequest.class })
public interface ProductShowcase {
    
    /**
     * @return Título da seção
     */
    String getTitle();
    
    /**
     * @return URL da API do Commerce
     */
    String getApiUrl();
    
    /**
     * @return Indica se deve filtrar apenas destaques
     */
    boolean isHighlightOnly();
    
    /**
     * @return Lista de produtos
     */
    List<Map<String, Object>> getProducts();
    
    /**
     * @return true se a lista de produtos está vazia
     */
    boolean isEmpty();
}
