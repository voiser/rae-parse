rae-parse
=========

A simple XSLT to parse the RAE webpage (spanish institution to regulate the spanish language)


Usage
=====

```
$ wget -O file.html "http://lema.rae.es/drae/srv/search?val=$WORD" && xsltproc --html rae.xslt file.html
```

