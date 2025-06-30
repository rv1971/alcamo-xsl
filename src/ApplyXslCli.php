<?php

namespace alcamo\xsl;

use alcamo\cli\AbstractCli;
use alcamo\dom\Document;
use alcamo\dom\xsl\Document as XslDocument;
use alcamo\exception\ErrorHandler;
use alcamo\xsl\XsltException;
use GetOpt\{GetOpt, Operand};
use Ramsey\Uuid\Uuid;

function uuid(): string
{
    return Uuid::uuid4();
}

function getLineNo($params): int
{
    return $params[0]->getLineNo();
}

class ApplyXslCli extends AbstractCli
{
    public const OPTIONS =
        [
            'comment' => [
                'C',
                GetOpt::NO_ARGUMENT,
                'Include the command line as a comment into the output.'
            ],
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
            ],
            'xinclude' => [
                'x',
                GetOpt::NO_ARGUMENT,
                'Do XInclude processing before XSL processing.'
            ],
        ]
        + parent::OPTIONS;

    public const OPERANDS = [
        'xslFilename' => Operand::REQUIRED,
        'xmlFilenames' => Operand::REQUIRED | Operand::MULTIPLE
    ];

    private $outputMethod_;  ///< ?string
    private $xsltProcessor_; ///< XSLTProcessor

    public function innerRun(): int
    {
        $errorHandler = new ErrorHandler();

        foreach ($this->getOption('include') as $include) {
            require_once($include);
        }

        $xsltProcessor = $this->getXsltProcessor();

        $outputFileFmt = $this->getOption('output');

        $loadFlags = 0;

        if ($this->getOption('xinclude')) {
            $loadFlags |= Document::XINCLUDE_AFTER_LOAD;
        }

        foreach ($this->getOperand('xmlFilenames') as $xmlFilename) {
            $xmlDocument = Document::newFromUrl($xmlFilename, 0, $loadFlags);

            if ($this->getOption('xinclude')) {
                $xmlDocument->reparse();
            }

            try {
                if ($this->outputMethod_ == 'text') {
                    $output = $xsltProcessor->transformToXml($xmlDocument);
                } else {
                    $newDocument = $xsltProcessor->transformToDoc($xmlDocument);

                    if ($this->getOption('format')) {
                        $newDocument->formatOutput = true;
                    }

                    if ($this->getOption('comment')) {
                        $newDocument->insertBefore(
                            $newDocument->createComment($this->createComment()),
                            $newDocument->firstChild
                        );
                    }

                    $output = $newDocument->saveXML();

                    if ($output === false) {
                        throw new XsltException();
                    }
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

                file_put_contents($outFilename, $output);
            } else {
                echo $output;
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

        $xsltDocument =
            XslDocument::newFromUrl($this->getOperand('xslFilename'));

        $output = $xsltDocument->query('/*/xsl:output')[0];

        $this->outputMethod_ = isset($output) ? $output->method : null;

        $xsltProcessor->importStyleSheet($xsltDocument);

        foreach ($this->getOption('stringparam') as $assignment) {
            [ $name, $value ] = explode('=', $assignment, 2);

            $xsltProcessor->setParameter('', $name, $value);
        }

        $xsltProcessor->registerPHPFunctions();

        return $xsltProcessor;
    }

    protected function createComment(): string
    {
        return "\n"
            . "Generated " . date('c') . " by:\n\n"
            . implode(' ', $_SERVER['argv'])
            . "\n";
    }
}
