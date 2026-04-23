# 🔧 Troubleshooting: Escopos Não Aprovados (Erro 403)

## ⚠️ Sintoma

Após instalar a app, você recebe:

```
❌ Erro 403: [API] This action requires merchant approval for write_products scope.
```

---

## ✅ Solução Rápida

1. **Verifique se a app está realmente instalada:**
   - Acesse: https://dev.shopify.com
   - Você vê "Uninstall" (em vez de "Install")?
   - Sim → Vá para passo 2
   - Não → Vá para [Cenário 1](#cenário-1-app-não-foi-instalada)

2. **Aguarde 2-3 minutos** para sincronização

3. **Verifique os escopos:**
   ```bash
   cd /home/igors/projects/bootcamp-2026/scripts
   export SHOPIFY_DOMAIN="qdt02k-t4.myshopify.com"
   export SHOPIFY_TOKEN="shpat_seu_token"
   ./verify-shopify-token.sh
   ```

4. **Se disser "✅ Escopos APROVADOS":**
   ```bash
   node setup_shopify.js
   ```

---

## 🔍 Diagnóstico: 3 Cenários

### Cenário 1: App não foi instalada

**Sinais:**
- Você vê um botão "Install" em dev.shopify.com
- Não consegue ver a app no Admin Shopify

**Solução:**
1. Acesse: https://dev.shopify.com
2. Clique em sua app "Bootcamp Setup"
3. Clique no botão **"Install"** (cinza/branco)
4. Clique no botão **principal** que aparece (azul/destacado)
5. Você deve ver: "✅ App installed"
6. Aguarde 2 minutos
7. Voltea aqui e tente novamente

---

### Cenário 2: App foi instalada em dev store diferente

**Sinais:**
- Você tem múltiplas dev stores
- A app aparece em uma, mas não na outra

**Solução:**
1. Acesse: https://dev.shopify.com
2. **Canto superior:** Selecione a dev store correta (qdt02k-t4)
3. Clique em sua app
4. Se não tiver "Install" aí, clique em "Install"
5. Confirme

---

### Cenário 3: Token renovado, mas escopos não sincronizaram

**Sinais:**
- Token novo foi gerado
- Mas o verificador ainda mostra escopos não aprovados

**Solução:**
1. **Aguarde 3-5 minutos** (Shopify sincroniza em background)
2. Rode o verificador novamente:
   ```bash
   export SHOPIFY_DOMAIN="qdt02k-t4.myshopify.com"
   export SHOPIFY_TOKEN="shpat_seu_token_novo"
   ./verify-shopify-token.sh
   ```
3. Se ainda não funcionar, **desinstale e reinstale a app**

---

## 🔄 Nuclear Option: Desinstalar e Reinstalar

Se nada funcionou:

1. **Desinstale:**
   - Dev Dashboard → Seu app → "Uninstall"
   - Confirme
   - Aguarde 30 segundos

2. **Reinstale:**
   - Dev Dashboard → Seu app → "Install"
   - Confirme
   - Aguarde 1-2 minutos

3. **Tente novamente:**
   ```bash
   ./verify-shopify-token.sh
   ```

---

## 📞 Se Ainda Não Funcionar

Me responda com os dados do checklist:

- [ ] Você vê "Uninstall" na dev.shopify.com?
- [ ] Você consegue ver a app no Admin Shopify → Apps → Developed apps?
- [ ] Você clicou em um botão de confirmação (azul/destacado)?
- [ ] Você aguardou 2-3 minutos após instalar?
- [ ] Qual erro o `verify-shopify-token.sh` mostra?

Esses dados vão me ajudar a diagnosticar o problema real!
