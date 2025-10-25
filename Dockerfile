FROM node:18-alpine AS runtime
ENV PORT=1337
ENV HOME=/app
ENV NODE_ENV=production
WORKDIR /app
COPY . .
RUN npm install --no-audit --no-fund
# Se existir um script de build (package.json), roda: `npm run build`
RUN if [ -f package.json ] ; then npm run build ; fi
# Usuário não-root é recomendado em produção
EXPOSE 1337
# Comando padrão para iniciar Strapi
CMD ["npm", "run", "start"]
