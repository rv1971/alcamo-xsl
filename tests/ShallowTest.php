<?php

namespace alcamo\xsl;

use alcamo\uri\FileUriFactory;
use PHPUnit\Framework\TestCase;

class ShallowTest extends TestCase
{
    /**
     * @dataProvider xsltProvider
     */
    public function testXslt($filename): void
    {
        $fileUriFactory = new FileUriFactory();

        $xsltProcessor = XsltProcessor::newFromStylesheetUri(
            $fileUriFactory->create(
                dirname(__DIR__) . DIRECTORY_SEPARATOR
                    . 'xsl' . DIRECTORY_SEPARATOR . $filename
            )
        );

        /* This simply tests that the XSLs are imported without errors. */
        $this->assertInstanceOf(XsltProcessor::class, $xsltProcessor);
    }

    public function xsltProvider(): array
    {
        return [
            [ 'xsd.xsl' ],
            [ 'xsl.xsl' ]
        ];
    }
}
