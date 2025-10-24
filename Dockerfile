FROM node:18-alpine AS runtime
ENV PORT=1337
ENV HOME=/app
ENV NODE_ENV=production
WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm install --no-audit --no-fund

# Copia o restante do código e gera o build (admin)
COPY . .

# Se existir um script de build (package.json), roda: `npm run build`
RUN if [ -f package.json ] ; then npm run build ; fi

WORKDIR /app
# Expor porta padrão do Strapi
# Usuário não-root é recomendado em produção
RUN addgroup -S strapi && adduser -S -G strapi strapi && chown -R strapi:strapi /app
USER strapi
EXPOSE 1337
# Comando padrão para iniciar Strapi
CMD ["npm", "run", "start"]
