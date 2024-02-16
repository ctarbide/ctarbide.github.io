# generated from index.nw

index.html: .installation-ok update-Makefile unlink-draft-pages pages index.nw
	@nofake --error index.nw | sh

.installation-ok: bin/check-installation.sh
	@./bin/check-installation.sh
	@date '+%Y-%m-%d_%Hh%Mm%S' > .installation-ok

.PHONY: update-Makefile
update-Makefile:
	@nofake -R'generate Makefile' index.nw | sh

.PHONY: unlink-draft-pages
unlink-draft-pages:
	@nofake -R'unlink draft pages' index.nw | sh

.PHONY: pages
pages: unlink-draft-pages
	$(MAKE) -C 'pages/2023/2023-10-19_21h40m15_perl·markdown·daringfireball.net'
	$(MAKE) -C 'pages/2024/2024-01-06_15h38m06_meta'
	$(MAKE) -C 'pages/2024/2024-01-08_10h24m46_compiling_cmucl_2023-08_on_a_void-live-i686_vm'
	$(MAKE) -C 'pages/2024/2024-01-10_00h50m10_markdown·basics'
	$(MAKE) -C 'pages/2024/2024-01-10_00h50m14_markdown·syntax'
	$(MAKE) -C 'pages/2024/2024-01-25_20h18m26_scsh·examples'
	$(MAKE) -C 'pages/2024/2024-01-29_10h43m49_scsh·ipc·fork·exec·waitpid·run'
	$(MAKE) -C 'pages/2024/2024-02-01_13h35m19_sicp·book'
	$(MAKE) -C 'pages/2024/2024-02-05_12h00m11_hello-worlds'
	$(MAKE) -C 'pages/2024/2024-02-10_10h47m46_slackware64-13.37_from_2011_on_qemu_v8.1.3'
	$(MAKE) -C 'pages/2024/2024-02-15_15h49m59_ieee754·aka_floats_and_doubles·qnans_and_snans'
