<?php

namespace alcamo\xsl\apply_xsl;

use alcamo\cli\AbstractCli;
use alcamo\dom\Document;
use alcamo\dom\xsl\Document as XslDocument;
use alcamo\xsl\XsltException;
use GetOpt\{GetOpt, Operand};

/** @todo
 * - create tests
 * - review code
 * - publish
 */

class Cli extends AbstractCli
{
    public const OPTIONS =
        [
            'include' => [
                'i',
                GetOpt::MULTIPLE_ARGUMENT,
                'Include php file containing functions to use in stylesheets.',
                'filename'
            ],
            'output' => [
                'o',
                GetOpt::REQUIRED_ARGUMENT,
                'Write each output to a filename created replacing one %s '
                . 'by the source file basename without suffix.',
                'sprintf()-fmt'
            ],
            'stringparam' => [
                's',
                GetOpt::MULTIPLE_ARGUMENT,
                'Parameter to pass to stylesheet',
                'name=value'
            ]
        ]
        + parent::OPTIONS;

    public const OPERANDS = [
        'xslFilename' => Operand::REQUIRED,
        'xmlFilenames' => Operand::REQUIRED | Operand::MULTIPLE
    ];

    private $xsltProcessor_; ///< XSLTProcessor

    public function process($arguments = null): int
    {
        parent::process($arguments);

        $xsltProcessor = $this->getXsltProcessor();

        foreach ($this->getOption('include') as $include) {
            require_once($include);
        }

        $outputFileFmt = $this->getOption('output');

        foreach ($this->getOperand('xmlFilenames') as $xmlFilename) {
            $xmlDocument = Document::newFromUrl($xmlFilename);

            $xml = $xsltProcessor->transformToXML($xmlDocument);

            if ($xml === false) {
                throw (new XsltException())->setMessageContext(
                    [
                        'atUri' => $xmlFilename
                    ]
                );
            }

            if (isset($outputFileFmt)) {
                $outFilename =
                    sprintf($outputFileFmt, basename($xmlFilename, '.xml'));

                $this->reportProgress("$xmlFilename -> $outFilename");

                file_put_contents($outFilename, $xml);
            } else {
                echo $xml;
            }

            return 0;
        }
    }

    public function getXsltProcessor(): \XSLTProcessor
    {
        if (!isset($this->xsltProcessor_)) {
            $this->xsltProcessor_ = $this->createXsltProcessor();
        }

        return $this->xsltProcessor_;
    }

    protected function createXsltProcessor(): \XSLTProcessor
    {
        $xsltProcessor = new \XSLTProcessor();

        $xsltProcessor->importStyleSheet(
            XslDocument::newFromUrl($this->getOperand('xslFilename'))
        );

        foreach ($this->getOption('stringparam') as $assignment) {
            [ $name, $value ] = explode('=', $assignment);

            $xsltProcessor->setParameter('', $name, $value);
        }

        $xsltProcessor->registerPHPFunctions();

        return $xsltProcessor;
    }
}
