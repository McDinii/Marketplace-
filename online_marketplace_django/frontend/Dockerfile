# Указываем нужную версию Node.js
FROM node:16

# Создаем директорию приложения
WORKDIR /app

# Копируем файлы package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем исходный код приложения
COPY . .

# Наше приложение работает на 3000 порту, поэтому можем его открыть
EXPOSE 3000

# Запуск приложения
CMD [ "npm", "start" ]