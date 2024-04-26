index.html: ../../../assets.nw README.txt Makefile-wip.nw wip.nw
	@nofake --error README.txt | sh

.PHONY: reveal
reveal: index.html
	@rm -f .hidden
	$(MAKE) -C ../../..
