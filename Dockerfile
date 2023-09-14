FROM node:18
WORKDIR /docker
COPY package.json .
RUN npm install hexo-cli -g
RUN npm install
EXPOSE 4000
COPY . .
CMD ["npm", "run", "docker"]