HOME=/home/gustaf
BIN=$(HOME)/prj/RegNr
BUILD=$(HOME)/prj/RegNr/build
WWW=$(HOME)/public_html

deploy: regnr.html
	cp $(BUILD)/regnr.html $(WWW)/regnr.html

regnr.html: page.head page.foot data.txt
	cat page.head > $(BUILD)/regnr.html
	perl $(BIN)/generate-page.pl >> $(BUILD)/regnr.html
	cat page.foot >> $(BUILD)/regnr.html

