index.html: ../../../assets.nw README.txt
	@nofake --error README.txt | sh

.PHONY: reveal
reveal: index.html
	@rm -f .hidden
	$(MAKE) -C ../../..
