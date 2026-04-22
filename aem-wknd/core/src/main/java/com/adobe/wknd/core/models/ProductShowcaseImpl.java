package com.adobe.wknd.core.models;

import javax.inject.Inject;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.models.annotations.Model;
import org.apache.sling.models.annotations.injectorspecific.ValueMapValue;
import org.apache.sling.models.annotations.injectorspecific.SlingObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Sling Model Implementation for ProductShowcase Component
 * Busca produtos do Adobe Commerce via API REST
 */
@Model(
    adaptables = { SlingHttpServletRequest.class, Resource.class },
    adapters = ProductShowcase.class,
    resourceType = "wknd/components/productshowcase"
)
public class ProductShowcaseImpl implements ProductShowcase {
    
    private static final Logger logger = LoggerFactory.getLogger(ProductShowcaseImpl.class);
    private static final int TIMEOUT = 5000; // 5 segundos
    
    @ValueMapValue
    private String title;
    
    @ValueMapValue
    private String apiUrl;
    
    @ValueMapValue
    private boolean highlightOnly;
    
    @SlingObject
    private ResourceResolver resourceResolver;
    
    private List<Map<String, Object>> products;
    
    @Override
    public String getTitle() {
        return title != null ? title : "Produtos em Destaque";
    }
    
    @Override
    public String getApiUrl() {
        return apiUrl != null ? apiUrl : "https://app.magento2.test/rest/V1/bootcamp/products";
    }
    
    @Override
    public boolean isHighlightOnly() {
        return highlightOnly;
    }
    
    @Override
    public List<Map<String, Object>> getProducts() {
        if (products == null) {
            products = fetchProducts();
        }
        return products;
    }
    
    @Override
    public boolean isEmpty() {
        return getProducts().isEmpty();
    }
    
    /**
     * Busca produtos via API REST do Commerce
     */
    private List<Map<String, Object>> fetchProducts() {
        List<Map<String, Object>> result = new ArrayList<>();
        
        try {
            String url = getApiUrl();
            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setConnectTimeout(TIMEOUT);
            conn.setReadTimeout(TIMEOUT);
            
            int status = conn.getResponseCode();
            if (status == 200) {
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                StringBuilder content = new StringBuilder();
                String line;
                while ((line = in.readLine()) != null) {
                    content.append(line);
                }
                in.close();
                
                // Parse JSON
                JsonObject json = JsonParser.parseString(content.toString()).getAsJsonObject();
                JsonArray items = json.getAsJsonArray("items");
                
                if (items != null) {
                    for (JsonElement item : items) {
                        JsonObject product = item.getAsJsonObject();
                        
                        // Filtrar por destaque se necessário
                        if (highlightOnly && !product.get("bootcamp_highlight").getAsBoolean()) {
                            continue;
                        }
                        
                        Map<String, Object> productMap = new HashMap<>();
                        productMap.put("sku", product.get("sku").getAsString());
                        productMap.put("name", product.get("name").getAsString());
                        productMap.put("price", product.get("price").getAsDouble());
                        productMap.put("type", product.get("type").getAsString());
                        productMap.put("bootcamp_highlight", product.get("bootcamp_highlight").getAsBoolean());
                        productMap.put("tech_stack", product.get("tech_stack").getAsString());
                        productMap.put("image_url", product.get("image_url").isJsonNull() ? 
                            "/content/dam/wknd/bootcamp/products/default.png" : 
                            product.get("image_url").getAsString());
                        productMap.put("description", product.get("description").getAsString());
                        
                        result.add(productMap);
                    }
                }
            } else {
                logger.warn("Erro ao buscar produtos: HTTP " + status);
            }
            
            conn.disconnect();
        } catch (Exception e) {
            logger.error("Erro ao buscar produtos do Commerce: " + e.getMessage(), e);
        }
        
        return result;
    }
}
