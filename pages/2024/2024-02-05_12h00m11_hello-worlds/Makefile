index.html: ../../../assets.nw README.txt htmlify-all-hellos.sh hello-*.sh
	@nofake --error README.txt | sh

.PHONY: reveal
reveal:
	@rm -f .hidden
	$(MAKE) -C ../../..
