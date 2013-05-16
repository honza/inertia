NAME=inertiac

all:
	./node_modules/.bin/pegjs inertia/grammar.pegjs
	rm $(NAME)
	echo "#!/usr/bin/env node" > $(NAME)
	cat inertia/grammar.js inertia/main.js >> $(NAME)
	chmod +x $(NAME)

install:
	npm install

clean:
	rm grammar.js out.js $(NAME)

example:
	./$(NAME) -o examples/simple.js examples/simple.clj
	./$(NAME) -o examples/arrays.js examples/arrays.clj
	./$(NAME) -o examples/objects.js examples/objects.clj
