SHELL := /bin/bash
VIRTUALENV_ROOT := $(shell [ -z $$VIRTUAL_ENV ] && echo $$(pwd)/venv || echo $$VIRTUAL_ENV)

run_all: requirements frontend_build run_app

run_app: show_environment virtualenv
	python application.py runserver

virtualenv:
	[ -z $$VIRTUAL_ENV ] && [ ! -d venv ] && virtualenv venv || true

requirements: virtualenv requirements.txt
	${VIRTUALENV_ROOT}/bin/pip install -r requirements.txt

requirements_for_test: virtualenv requirements_for_test.txt
	${VIRTUALENV_ROOT}/bin/pip install -r requirements_for_test.txt

requirements_freeze:
	${VIRTUALENV_ROOT}/bin/pip install --upgrade pip
	${VIRTUALENV_ROOT}/bin/pip install --upgrade -r requirements_for_test.txt
	${VIRTUALENV_ROOT}/bin/pip freeze | grep -v buyer-frontend > requirements.txt
	sed '/^-e /s/$$/==whatever/' -i requirements.txt
	sed '/^-e /s/-e //' -i requirements.txt

npm_install:
	npm install

frontend_build:
	npm run frontend-build:development

frontend_livereload:
	npm run frontend-build:livereload

test: show_environment frontend_build test_pep8 test_python test_javascript

test_pep8: virtualenv
	${VIRTUALENV_ROOT}/bin/pep8 .

test_python: virtualenv
	${VIRTUALENV_ROOT}/bin/py.test ${PYTEST_ARGS}

test_javascript: frontend_build
	npm test

show_environment:
	@echo "Environment variables in use:"
	@env | grep DM_ || true

docker:
	docker build -t dto-buyer-frontend .

docker-run:
	docker run -it -p 5002:5002 dto-buyer-frontend bash
	
.PHONY: run_all run_app virtualenv requirements requirements_for_test frontend_build test test_pep8 test_python test_javascript show_environment
