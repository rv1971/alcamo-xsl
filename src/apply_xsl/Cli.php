<?php

namespace alcamo\xsl\apply_xsl;

use alcamo\cli\AbstractCli;
use alcamo\dom\Document;
use alcamo\dom\xsl\Document as XslDocument;
use alcamo\exception\ErrorHandler;
use alcamo\xsl\XsltException;
use GetOpt\{GetOpt, Operand};

/** @todo
 * - review code
 * - publish
 */

class Cli extends AbstractCli
{
    public const OPTIONS =
        [
            'format' => [
                'F',
                GetOpt::NO_ARGUMENT,
                'Reformat and reindent the output.'
            ],
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
                . 'in the sprintf() format by the source file basename '
                . 'without suffix.',
                'sprintf()-fmt'
            ],
            'stringparam' => [
                's',
                GetOpt::MULTIPLE_ARGUMENT,
                'Set parameter <qname> to string <value>',
                'qname=value'
            ]
        ]
        + parent::OPTIONS;

    public const OPERANDS = [
        'xslFilename' => Operand::REQUIRED,
        'xmlFilenames' => Operand::REQUIRED | Operand::MULTIPLE
    ];

    private $xsltProcessor_; ///< XSLTProcessor

    public function innerRun(): int
    {
        $errorHandler = new ErrorHandler();

        foreach ($this->getOption('include') as $include) {
            require_once($include);
        }

        $xsltProcessor = $this->getXsltProcessor();

        $outputFileFmt = $this->getOption('output');

        foreach ($this->getOperand('xmlFilenames') as $xmlFilename) {
            $xmlDocument = Document::newFromUrl($xmlFilename);

            try {
                if ($this->getOption('format')) {
                    $newDocument = $xsltProcessor->transformToDoc($xmlDocument);
                    $newDocument->formatOutput = true;
                    $xml = $newDocument->saveXML();
                } else {
                    $xml = $xsltProcessor->transformToXml($xmlDocument);
                }

                if ($xml === false) {
                    throw new XsltException();
                }
            } catch (\Throwable $e) {
                if (!($e instanceof ExceptionInterface)) {
                    $e = XsltException::newFromPrevious($e);
                }

                $e->addMessageContext(
                    [
                        'atUri' => $xmlFilename
                    ]
                );

                throw $e;
            }

            if (isset($outputFileFmt)) {
                $outFilename =
                    sprintf($outputFileFmt, basename($xmlFilename, '.xml'));

                $this->reportProgress("$xmlFilename -> $outFilename");

                file_put_contents($outFilename, $xml);
            } else {
                echo $xml;
            }
        }

        return 0;
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
            [ $name, $value ] = explode('=', $assignment, 2);

            $xsltProcessor->setParameter('', $name, $value);
        }

        $xsltProcessor->registerPHPFunctions();

        return $xsltProcessor;
    }
}
