PROJECT = api-boilerplate
PROJECT_DIR = $(shell pwd)

TESTTIMEOUT = 5000
REPORTER	= spec
TEST_UNIT_SPEC = $(shell find test -name \*-uspec.coffee -or -name \*-unit.coffee)
TEST_INT_SPEC  = $(shell find test -name \*-intspec.coffee -or -name \*-integration.coffee )

TMP_BUILD = tmp

SHARED_SRC = src/coffee/shared
SHARED_BUILD = lib/shared

APP_BUILD = lib/server
APP_VIEWS = src/views
APP_SRC = src/coffee/server

SOURCE = ${PWD}

										
install:
	npm install
	make build-dev

version:
	@echo $(VERSION)

build-app:
	@mkdir -p lib && coffee -c -o $(APP_BUILD) $(APP_SRC)
	@find $(APP_SRC) -name "*.coffee" -print0 | xargs -0 ./node_modules/coffeelint/bin/coffeelint -f ./coffeelint.json
	@cp -rf $(APP_VIEWS) $(APP_BUILD)


build-shared:
	@coffee -c -o $(SHARED_BUILD) $(SHARED_SRC)
	@find $(SHARED_SRC) -name "*.coffee" -print0 | xargs -0 ./node_modules/coffeelint/bin/coffeelint -f ./coffeelint.json

build-dev: build-app build-shared

build-prod: build-app build-shared min

watch: build-dev
	node ./node_modules/nodemon/bin/nodemon -e coffee,css,js,html,conf,png,jpg,jpeg --watch src -x "make build-dev -f" Makefile

clean:
	@find src/coffee -name \*.js | xargs rm
	@rm -rf lib 

#all-dev: install build-dev test
all-dev: install build-dev

.PHONY: all 

