# Command-line XSLT processor

On the one hand, this package supplies a command-line XSLT processor
in `bin/apply-xsl`. It supports some of the options of `xsltproc` and
offers additional features. The main advantages over `xsltproc` are:
* The syntax `apply-xsl <xslFilename> <xmlFilename>` works as expected
  also when `<xslFilename>` contains itself a stylesheet processing
  instruction (for documentation purposes).
* The sysntax `apply-xsl -o %s-result.xml foo.xsl bar.xml baz.xml
    qux.xml` can be used to created in one run `bar-result.xml`,
    `baz-result.xml` and `qux-result.xml`.
* If is possible to use PHP functions in the XSL code.

See `bin/apply-xsl --help` for details.


# XSL library

The `xsl` directory contains a library of XSL files with a number of
(mainly simple) multi-purpose templates.

In addition, it contains `xsd.xsl` and `xsl.xsl` which can be used to
generate HTML documentation from XSD and XSL files.
