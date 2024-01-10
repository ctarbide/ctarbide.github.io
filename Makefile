index.html: update-Makefile pages index.nw
	nofake --error index.nw | sh

.PHONY: update-Makefile
update-Makefile:
	nofake -R'generate Makefile' index.nw | sh

.PHONY: pages
pages:
	$(MAKE) -C 'pages/2023/2023-10-19_21h40m15_perl·markdown·daringfireball.net'
	$(MAKE) -C 'pages/2024/2024-01-06_15h38m06_meta'
	$(MAKE) -C 'pages/2024/2024-01-08_10h24m46_compiling_cmucl_2023-08_on_a_void-live-i686_vm'
	$(MAKE) -C 'pages/2024/2024-01-10_00h50m10_markdown·basics'
	$(MAKE) -C 'pages/2024/2024-01-10_00h50m14_markdown·syntax'
