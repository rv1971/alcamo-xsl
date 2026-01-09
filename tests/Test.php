<?php

namespace alcamo\xsl;

use alcamo\dom\extended\Document;
use alcamo\uri\FileUriFactory;
use PHPUnit\Framework\TestCase;

class Test extends TestCase
{
    /**
     * @dataProvider xsltProvider
     */
    public function testXslt($filename): void
    {
        $uri = (new FileUriFactory())
            ->create(__DIR__ . DIRECTORY_SEPARATOR . $filename);

        $doc = Document::newFromUri($uri);

        $xslt = $doc->getElementById('xslt');

        if (isset($xslt)) {
            $styleSheet = new Document();

            $styleSheet->documentURI = $uri;

            $styleSheet->appendChild($styleSheet->importNode($xslt, true));
        } else {
            $styleSheet = $doc->getXsltStylesheet();
        }

        $xsltProcessor = XsltProcessor::newFromStylesheet($styleSheet);

        $outputDoc = new Document();

        $outputDoc->loadXML(
            $xsltProcessor->transformToXml($doc),
            LIBXML_NOBLANKS
        );

        if ($filename != 'syntaxhighlight-xml.xml') {
            $outputDoc->formatOutput = true;
        }

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
