<?php

use PHPUnit\Framework\TestCase;

class MessageTest extends TestCase
{
    public const ALCAMO_XSL_NS = 'tag:rv1971@web.de,2021:alcamo-xsl#';

    public static function errorHandler(
        int $errno,
        string $errstr,
        string $errfile = null,
        int $errline = null
    ): void {
        throw new \ErrorException($errstr, 0, $errno, $errfile, $errline);
    }

    /**
     * @dataProvider xsltProvider
     */
    public function testXslt($filename, $params, $expectedMessage): void
    {
        set_error_handler(
            static::class . '::errorHandler',
            E_RECOVERABLE_ERROR | E_WARNING | E_NOTICE
        );

        $filePath = __DIR__ . DIRECTORY_SEPARATOR . $filename;

        $doc = new DOMDocument();

        $doc->load($filePath);

        $xsltDoc = new DOMDocument();

        $xsltDoc->documentURI = $filePath;

        $xsltDoc->appendChild(
            $xsltDoc->importNode($doc->getElementById('xslt'), true)
        );

        $xsltProcessor = new \XSLTProcessor();

        $xsltProcessor->importStyleSheet($xsltDoc);

        foreach ($params as $param) {
            [ $ns, $name, $value ] = $param;

            $this->assertTrue($xsltProcessor->setParameter($ns, $name, $value));
        }

        try {
            $xsltProcessor->transformToDoc($doc);
        } catch (\ErrorException $e) {
            $this->assertSame(
                "XSLTProcessor::transformToDoc(): $expectedMessage",
                $e->getMessage()
            );

            return;
        }

        $this->assertNull($expectedMessage);
    }

    public function xsltProvider(): array
    {
        return [
            [
                'html-document-errors.xml',
                [
                    [ self::ALCAMO_XSL_NS, 'a:errorReportingChannels', 'message' ]
                ],
                'Lorem ipsum.'
            ],
            [
                'html-document-errors.xml',
                [
                    [ self::ALCAMO_XSL_NS, 'a:errorReportingChannels', 'both' ]
                ],
                'Lorem ipsum.'
            ],
            [
                'html-document-errors.xml',
                [
                    [ self::ALCAMO_XSL_NS, 'a:errorReportingChannels', 'output' ]
                ],
                null
            ],
            [
                'html-document-errors.xml',
                [
                    [ self::ALCAMO_XSL_NS, 'errorReportingChannels', 'none' ]
                ],
                null
            ]
        ];
    }
}
