build:
	./node_modules/.bin/pegjs grammar.pegjs

install:
	npm install

clean:
	rm grammar.js out.js
