serve:
	source .env && mix phx.server

git-hook:
	rm -f .git/hooks/pre-commit
	ln -s `pwd`/tools/git-hooks/pre-commit .git/hooks/pre-commit
