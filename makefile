max_links = 2
data = data
src = src
bin = bin

links = $(data)/links
html = $(data)/html
sexual_features = $(data)/sexual_features
names = $(data)/names
references = $(data)/references
substrates = $(data)/substrates
hosts = $(data)/hosts
data_rows = $(data)/data_rows

python = python3
remove_pipes = tr "|" ";"

extract_links = $(src)/extract_links.sh
species_links = $(data)/species_links.txt
extract_text = $(src)/extract_text.sh
extract_species_name = $(src)/extract_species_name.sh
extract_sexual_features = $(python) $(src)/extract_sexual_features.py
extract_reference = $(src)/extract_reference.sh
extract_substrate = $(python) $(src)/extract_substrate.py
extract_host = $(python) $(src)/extract_host.py

ifeq (, $(shell which hxnormalize))
$(error "No hxnormalize in $(PATH), consider installing html-xml-utils")
endif
ifeq (, $(shell which hxclean))
$(error "No hxclean in $(PATH), consider installing html-xml-utils")
endif
ifeq (, $(shell which hxselect))
$(error "No hxselect in $(PATH), consider installing html-xml-utils")
endif
ifeq (, $(shell which hxunent))
$(error "No hxunent in $(PATH), consider installing html-xml-utils")
endif
ifeq (, $(shell which python3))
$(error "No python3 in $(PATH), consider installing python3")
endif

bs4_installed := $(shell bash -c "echo -e 'try:\n  import bs4\n  print(\"good\")\nexcept ImportError:\n  print(\"error\")' | python3 -")
ifeq ("error", "$(bs4_installed)")
$(error "No bs4 installed, consider installing bs4 (pip3 install 'beautifulsoup4' after installing python3)")
endif

.PRECIOUS: $(links)/%.hyperlink $(html)/%.html

objects = $(shell basename $(links)/*.hyperlink | sed -E "s/(.*)/data\/data_rows\/\1/g" | sed "s/hyperlink/pdv/g" | tr "\n" " ")

all: all_objects $(data)/header.txt 
	cat $(data)/header.txt $(data_rows)/*.pdv > $(data)/meta_data.pdv
	cat $(data)/meta_data.pdv | sed 's/,/","/g' | tr "|" "," > $(data)/meta_data.csv

clean:
	rm $(data_rows)/*.pdv
	rm $(hosts)/*.txt
	rm $(substrates)/*.txt
	rm $(references)/*.txt
	rm $(names)/*.txt
	rm $(sexual_features)/*.txt

all_objects : $(objects)

all_links:
	curl -s https://idtools.org/id/phytophthora/factsheet_index.php | $(extract_links) | xargs -I '{}' bash -c 'echo {} > $(links)\$$(echo {} | egrep -o "[0-9]+").hyperlink'


$(data_rows)/%.pdv : $(names)/%.txt $(hosts)/%.txt $(substrates)/%.txt $(sexual_features)/%.txt $(references)/%.txt $(links)/%.hyperlink | $(data_rows)
	paste -d "|" $^ > $@

$(hosts)/%.txt : $(html)/%.html | $(hosts)
	cat $< | $(extract_host) | tr "\n" " " 2> error.log 1> $@

$(substrates)/%.txt : $(html)/%.html | $(substrates)
	cat $< | $(extract_substrate) | tr "\n" " " | $(remove_pipes)  > $@

$(references)/%.txt : $(html)/%.html | $(references)
	cat $< | $(extract_reference) 2> error.log 1> $@

$(names)/%.txt : $(html)/%.html | $(names)
	cat $< | $(extract_species_name) 2> error.log 1> $@

$(sexual_features)/%.txt : $(html)/%.html | $(sexual_features)
	cat $< | $(extract_text) | $(extract_sexual_features) | $(remove_pipes) > $@

$(html)/%.html : $(links)/%.hyperlink | $(html)
	cat $< | xargs curl -s > $@
	
$(links)/%.hyperlink : $(extract_links) | $(links)
	curl -s https://idtools.org/id/phytophthora/factsheet_index.php | $(extract_links) | xargs -I '{}' bash -c 'echo {} > $(links)\$$(echo {} | egrep -o "[0-9]+").hyperlink'

$(links) : | $(data)
	mkdir $(links)

$(html) : | $(data)
	mkdir $(html)

$(sexual_features) : | $(data)
	mkdir $(sexual_features)

$(names) : | $(data)
	mkdir $(names)

$(references) : | $(data)
	mkdir $(references)

$(substrates) : | $(data)
	mkdir $(substrates)

$(hosts) : | $(data)
	mkdir $(hosts)

$(data_rows) : | $(data)
	mkdir $(data_rows)
