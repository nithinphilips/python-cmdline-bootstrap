.PHONY: all dist install installer

PYTHON=python3
PYINSTALLER=pyinstaller
NOSETESTS=nosetests
PANDOC=pandoc

PRODUCT_NAME=bootstrap
VERSION := $(shell $(PYTHON) dev/extractversion.py)

# Distribution folder and distribution zip file name
DISTROOT=./dist
DISTDIR=$(PRODUCT_NAME)-$(VERSION)
DISTZIP=$(PRODUCT_NAME)-$(VERSION).zip
SRCDISTZIP=$(PRODUCT_NAME)-$(VERSION)-src.zip

# Change this GUID for each release
PRODUCT_GUID=1b16f354-eb6e-4835-967b-7c7d4dc26178
SOURCEDIR=$(PRODUCT_NAME)
SOURCES := $(shell find $(SOURCEDIR) -iname '*.py')

# Generic rst to docx rule
%.docx: %.rst
	$(PANDOC) -t docx -o $@ $<

all: $(DISTROOT)/$(PRODUCT_NAME).exe

dist: $(DISTROOT)/$(PRODUCT_NAME)-$(VERSION).zip installer
	-cp windows/$(PRODUCT_NAME)-$(VERSION).msi $(DISTROOT)/

$(DISTROOT)/$(PRODUCT_NAME).exe: $(PRODUCT_NAME)-runner.py $(SOURCES) ChangeLog.docx README.docx
	$(PYINSTALLER) --noconfirm --onefile --name=$(PRODUCT_NAME) $<
	-cp $(SOURCEDIR)/data/*.* $(DISTROOT)/
	cp ChangeLog.docx $(DISTROOT)
	cp README.docx $(DISTROOT)
	cp LICENSE $(DISTROOT)

$(DISTROOT)/$(PRODUCT_NAME)-$(VERSION).zip: $(DISTROOT)/$(PRODUCT_NAME).exe
	cd $(DISTROOT); 7z a -y $(PRODUCT_NAME)-$(VERSION).zip . -x!*.zip

install:
	$(PYTHON) setup.py install

installer: $(DISTROOT)/$(PRODUCT_NAME).exe
	VERSION=$(VERSION) PRODUCT_GUID=$(PRODUCT_GUID) PRODUCT_NAME=$(PRODUCT_NAME) $(MAKE) -C windows

clean:
	rm -rf *.spec *.egg-info/ build/
	rm -f README.docx ChangeLog.docx
	VERSION=$(VERSION) $(MAKE) -C windows clean
	find . | grep -E '(__pycache__|\.pyc|\.pyo)' | xargs rm -rf

distclean: clean
	rm -rf $(DISTROOT)

test:
	$(NOSETESTS)

