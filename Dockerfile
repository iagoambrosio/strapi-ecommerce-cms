FROM node:18-bullseye AS builder

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm install --no-audit --no-fund

# Copia o restante do código e gera o build (admin)
COPY . .

# Se existir um script de build (package.json), roda: `npm run build`
RUN if [ -f package.json ] ; then npm run build ; fi

# Runtime: imagem menor para execução
FROM node:18-bullseye-slim AS runtime

WORKDIR /app

# Variáveis de ambiente sensatas para Strapi
ENV PORT=1337

# Copia apenas as dependências de produção do estágio builder
COPY --from=builder /app/node_modules ./node_modules

# Copia o restante necessário da aplicação
COPY --from=builder /app .

# Expor porta padrão do Strapi
EXPOSE 1337

# Usuário não-root é recomendado em produção
RUN groupadd -r strapi && useradd -r -g strapi strapi && chown -R strapi:strapi /app
USER strapi
ENV HOME=/app
# Comando padrão para iniciar Strapi
CMD ["npm", "run", "start"]
