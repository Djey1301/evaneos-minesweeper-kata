install:
	docker build -f dockerfile-install -t dockerfile-install .

test:
	docker build -f dockerfile-test -t dockerfile-test .
	docker run -it -p 8080:8080 --rm --name minesweeper-kata-test dockerfile-test

dev:
	docker build -f dockerfile-dev -t dockerfile-dev .
	docker run -it -p 8080:8080 --rm --name minesweeper-kata-dev dockerfile-dev

start:
	docker build -f dockerfile-prod -t dockerfile-prod .
	docker run -it -p 8080:8080 --rm --name minesweeper-kata-prod dockerfile-prod

package:
	tar -zcvf ./docs/`git describe --abbrev=0 --tags`.tar.gz `git ls-tree -r master --name-only | sed '/docs/d'`
	cd docs && ln -sf ./`git describe --abbrev=0 --tags`.tar.gz ./latest.tar.gz && cd -
	cp ./README.md ./docs/README.md
