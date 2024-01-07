index.html: pages index.nw
	rm -f index.html
	nofake --error index.nw | sh | sh

.PHONY: pages
pages:
	$(MAKE) -C 'pages/2024/2024-01-06_15h38m06_meta'
	$(MAKE) -C 'pages/2023/2023-10-19_21h40m15_perl·markdown·daringfireball.net'
