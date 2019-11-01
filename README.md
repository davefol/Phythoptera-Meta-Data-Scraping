# Quick Start
1. `make all_links`
2. `make`

# Motivation
My girlfriend needed a way to assemble meta-data on pyhtoptera species in order to enrich a phylogenetic tree.
She found a website: https://idtools.org/id/phytophthora/factsheet.php that had great data on 166 different species.
This tool scrapes that website, creating a `data/meta_data.csv` file as output.

# Methodology
The entire data processing pipeline is orchestrated by (gnu make)[https://www.gnu.org/software/make/], 
a tool for specifying dependencies as directed acyclic graph and the 
instructions to build these dependencies. This allows for heavy computation to be cached and intermediate files cleaned up.
Due to this, and other -nix style dependencie, Windows users will find running this tool much easier if they use Cygwin
or some other POSIX compatible environement. 

## Pipeline
1. Get links to all species
	- Curl and html-xml-utils
2. Download web page for each link
	- Curl
3. Parse web page for meta-data
	- Mixture of html-xml one liners and short BeautifulSoup4 scripts
4. Collect all meta-data into csv
	- paste and cat

In order to extract metatada, a mixture of css selectors and regex was used. This was possible due to the regular
nature of the web pages, each one a largely sharing the same structure.

# Dependencies
- html-xml-utils
  + Mac: `brew install html-xml-utils`
  + Debian: `apt-get install html-xml-utils`
- python3
  + Mac: `brew install python3`
  + Debian: `apt-get install python3`
- beautiful soup 4
  + `pip3 install beautifulsoup4`
