<?php

use PHPUnit\Framework\TestCase;

class Test extends TestCase
{
    /**
     * @dataProvider xsltProvider
     */
    public function testXslt($filename): void
    {
        $filePath = __DIR__ . DIRECTORY_SEPARATOR . $filename;

        $doc = new DOMDocument();

        $doc->load($filePath);

        $xslt = $doc->getElementById('xslt');

        $xsltDoc = new DOMDocument();

        if (isset($xslt)) {
            $xsltDoc->documentURI = $filePath;

            $xsltDoc->appendChild($xsltDoc->importNode($xslt, true));
        } else {
            $firstPi = (new \DOMXPath($doc))
                ->query('/processing-instruction("xml-stylesheet")')[0];

            $xsltDoc->load(
                __DIR__ . DIRECTORY_SEPARATOR .
                simplexml_load_string("<x {$firstPi->nodeValue}/>")['href']
            );
        }

        $xsltProcessor = new \XSLTProcessor();

        $xsltProcessor->importStyleSheet($xsltDoc);

        $outputDoc = new DOMDocument();

        $outputDoc->loadXML(
            $xsltProcessor->transformToXml($doc),
            LIBXML_NOBLANKS
        );

        $outputDoc->formatOutput = true;

        $this->assertSame(
            file_get_contents(
                __DIR__ . DIRECTORY_SEPARATOR
                . 'expected' . DIRECTORY_SEPARATOR
                . $filename
            ),
            $outputDoc->saveXML()
        );
    }

    public function xsltProvider(): array
    {
        $filenames = [];

        foreach (glob(__DIR__ . DIRECTORY_SEPARATOR . '*.xml') as $path) {
            $filenames[] = [ basename($path) ];
        }

        return $filenames;
    }
}
