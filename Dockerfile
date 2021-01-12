FROM python:2.7-stretch

RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_11.x  | bash -
RUN apt-get -y install nodejs

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

ADD . .

RUN npm install gulp --save-dev
RUN npm install
RUN npm install natives@1.1.6
RUN npm run frontend-install
RUN npm run frontend-build:production

RUN cp app/static/stylesheets/application-ie8-part-2.css app/static/stylesheets/application-ie8-part-1.css

CMD python application.py runprodserver