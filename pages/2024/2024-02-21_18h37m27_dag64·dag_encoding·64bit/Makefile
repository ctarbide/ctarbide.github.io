index.html: ../../../assets.nw README.txt *.nw
	@nofake --error README.txt | sh

.PHONY: reveal
reveal:
	@rm -f .hidden
	$(MAKE) -C ../../..
