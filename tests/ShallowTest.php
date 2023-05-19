<?php

use PHPUnit\Framework\TestCase;

class ShallowTest extends TestCase
{
    /**
     * @dataProvider xsltProvider
     */
    public function testXslt($filename): void
    {
        $filePath = dirname(__DIR__) . DIRECTORY_SEPARATOR
            . 'xsl' . DIRECTORY_SEPARATOR . $filename;

        $doc = new DOMDocument();

        $doc->load($filePath);

        $xsltProcessor = new \XSLTProcessor();

        $this->assertTrue($xsltProcessor->importStyleSheet($doc));
    }

    public function xsltProvider(): array
    {
        return [
            [ 'xsd.xsl' ],
            [ 'xsl.xsl' ]
        ];
    }
}
