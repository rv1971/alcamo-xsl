<?php

namespace alcamo\xsl;

use alcamo\dom\extended\Document;
use alcamo\uri\FileUriFactory;
use PHPUnit\Framework\TestCase;

class XsltProcessorTest extends TestCase
{
    public function testBasics(): void
    {
        $fileUriFactory = new FileUriFactory();

        $xsltProcessor = XsltProcessor::newFromStylesheetUri(
            $fileUriFactory->create(__DIR__ . DIRECTORY_SEPARATOR . 'foo.xsl')
        );

        $this->assertInstanceOf(
            Document::class,
            $xsltProcessor->getStylesheet()
        );

        /* test caching */
        $xsltProcessor2 = XsltProcessor::newFromStylesheetUri(
            $fileUriFactory->create(__DIR__ . DIRECTORY_SEPARATOR . 'foo.xsl')
        );

        $this->assertSame(
            $xsltProcessor->getStylesheet(),
            $xsltProcessor2->getStylesheet()
        );

        $this->assertNull($xsltProcessor->getOutput());

        $xsltProcessor3 = XsltProcessor::newFromStylesheetUri(
            $fileUriFactory->create(__DIR__ . DIRECTORY_SEPARATOR . 'bar.xsl')
        );

        $this->assertSame('text', $xsltProcessor3->getOutput()->method);

        $foo = Document::newFromUri(
            $fileUriFactory->create(__DIR__ . DIRECTORY_SEPARATOR . 'foo.xml')
        );

        /* this tests registration of PHP functions */
        $this->assertSame(
            'LOREM IPSUM.',
            $xsltProcessor3->transformToXml($foo)
        );
    }

    public function testInvalidStylesheetException(): void
    {
        $fileUriFactory = new FileUriFactory();

        $this->expectException(XsltException::class);

        $this->expectExceptionMessage('compilation error');

        $xsltProcessor = XsltProcessor::newFromStylesheetUri(
            $fileUriFactory->create(__DIR__ . DIRECTORY_SEPARATOR . 'foo.xml')
        );
    }
}
