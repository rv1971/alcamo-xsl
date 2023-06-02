<?php

use PHPUnit\Framework\TestCase;

class ErrorsOnlyTest extends TestCase
{
    public const ALCAMO_XSL_NS = 'tag:rv1971@web.de,2021:alcamo-xsl#';

    public const XSL_DIR = __DIR__ . DIRECTORY_SEPARATOR
        . '..' . DIRECTORY_SEPARATOR
        . 'xsl' . DIRECTORY_SEPARATOR;

    private static $xsltProcessor_;
    private static $xsdXsltProcessor_;

    public static function setUpBeforeClass(): void
    {
        $xsltDoc = new \DOMDocument();

        $xsltDoc->load(static::XSL_DIR . 'xsl.xsl');

        self::$xsltProcessor_ = new \XSLTProcessor();

        self::$xsltProcessor_->importStyleSheet($xsltDoc);

        self::$xsltProcessor_->setParameter(
            self::ALCAMO_XSL_NS,
            'a:errorsOnly',
            1
        );

        self::$xsltProcessor_->setParameter(
            self::ALCAMO_XSL_NS,
            'a:errorReportingChannels',
            'output'
        );

        $xsltDoc->load(static::XSL_DIR . 'xsd.xsl');

        self::$xsdXsltProcessor_ = new \XSLTProcessor();

        self::$xsdXsltProcessor_->importStyleSheet($xsltDoc);

        self::$xsdXsltProcessor_->setParameter(
            self::ALCAMO_XSL_NS,
            'a:errorsOnly',
            1
        );

        self::$xsdXsltProcessor_->setParameter(
            self::ALCAMO_XSL_NS,
            'a:errorReportingChannels',
            'output'
        );
    }

    /**
     * @dataProvider xslCleanProvider
     */
    public function testXslClean($path): void
    {
        $doc = new DOMDocument();

        $doc->load($path);

        $this->assertNull(self::$xsltProcessor_->transformToXml($doc));
    }

    public function xslCleanProvider(): array
    {
        $paths = [];

        foreach (glob(static::XSL_DIR . '*.xsl') as $path) {
            $paths[] = [ basename($path) => $path ];
        }

        return $paths;
    }

    /**
     * @dataProvider xslErrorProvider
     */
    public function testXslError($filename, $expectedError): void
    {
        $doc = new DOMDocument();

        $doc->load(__DIR__ . DIRECTORY_SEPARATOR . $filename);

        $errorDoc = self::$xsltProcessor_->transformToDoc($doc);

        $this->assertSame(
            $expectedError,
            $errorDoc->documentElement->firstChild->textContent
        );
    }

    public function xslErrorProvider(): array
    {
        return [
            [ 'invalid-1.xsl', <<<EOT

There is top-level HTML content in this document. It is not
processed as documentation.

EOT
            ],
            [ 'invalid-2.xsl', <<<EOT

There are top-level <xsd:documentation> elements. They
are not processed as documentation.

EOT
            ],
            [ 'invalid-3.xsl', <<<EOT

There is top-level content other than <xsl:import> without a
preceding <h2> in a documentation block. Not TOC entries are
generated for this content.

EOT
            ]
        ];
    }

    /**
     * @dataProvider xsdXslErrorProvider
     */
    public function testXsdXslError($filename, $expectedError): void
    {
        $doc = new DOMDocument();

        $doc->load(__DIR__ . DIRECTORY_SEPARATOR . $filename);

        $errorDoc = self::$xsdXsltProcessor_->transformToDoc($doc);

        $this->assertSame(
            $expectedError,
            $errorDoc->documentElement->firstChild->textContent
        );
    }

    public function xsdXslErrorProvider(): array
    {
        return [
            [ 'invalid-1.xsd', <<<EOT

There are objects whose ID differs from their name:

EOT
            ],
            [ 'invalid-2.xsd', <<<EOT

There is a top-level <xsd:simpleType>
without a preceding <h2> in a documentation block.
No TOC entry is generated for it.

EOT
            ],
            [ 'invalid-3.xsd', <<<EOT

There is an <h3>Foo</h3>
without a preceding <h2> in a documentation block.
No TOC entry is generated for it.

EOT
            ]
        ];
    }
}
