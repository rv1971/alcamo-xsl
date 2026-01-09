<?php

namespace alcamo\xsl;

use alcamo\cli\AbstractCli;
use alcamo\dom\extended\Document;
use alcamo\exception\ErrorHandler;
use alcamo\uri\FileUriFactory;
use alcamo\xsl\XsltException;
use GetOpt\Operand;
use Ramsey\Uuid\Uuid;

function uuid(): string
{
    return Uuid::uuid4();
}

function getLineNo($params): int
{
    return $params[0]->getLineNo();
}

/**
 * @brief CLI partially compatible with `xsltproc`.
 *
 * @date Last reviewed 2026-01-09
 */
class ApplyXslCli extends AbstractCli
{
    public const OPTIONS =
        [
            'comment' => [
                'C',
                self::NO_ARGUMENT,
                'Include the command line as a comment into the output.'
            ],
            'format' => [
                'F',
                self::NO_ARGUMENT,
                'Reformat and reindent the output.'
            ],
            'include' => [
                'i',
                self::MULTIPLE_ARGUMENT,
                'Include php file containing functions to use in stylesheets.',
                'filename'
            ],
            'output' => [
                'o',
                self::REQUIRED_ARGUMENT,
                'Write each output to a filename created replacing one %s '
                . 'in the sprintf() format by the source file basename '
                . 'without suffix.',
                'sprintf()-fmt'
            ],
            'stringparam' => [
                's',
                self::MULTIPLE_ARGUMENT,
                'Set parameter <qname> to string <value>',
                'qname=value'
            ],
            'xinclude' => [
                'x',
                self::NO_ARGUMENT,
                'Do XInclude processing before XSL processing.'
            ],
        ]
        + parent::OPTIONS;

    public const OPERANDS = [
        'xslFilename' => Operand::REQUIRED,
        'xmlFilenames' => Operand::REQUIRED | Operand::MULTIPLE
    ];

    public function innerRun(): int
    {
        $errorHandler = new ErrorHandler();

        foreach ($this->getOption('include') as $include) {
            require_once($include);
        }

        $xsltProcessor = XsltProcessor::newFromStylesheetUri(
            (new FileUriFactory())->create($this->getOperand('xslFilename'))
        );

        foreach ($this->getOption('stringparam') as $assignment) {
            [ $name, $value ] = explode('=', $assignment, 2);

            $xsltProcessor->setParameter('', $name, $value);
        }

        $outputMethod = $xsltProcessor->getOutput()
            ? $xsltProcessor->getOutput()->method : null;

        $outputFileFmt = $this->getOption('output');

        $loadFlags = $this->getOption('xinclude')
            ? Document::XINCLUDE_AFTER_LOAD | Document::FORMAT_AND_REPARSE
            : 0;

        foreach ($this->getOperand('xmlFilenames') as $xmlFilename) {
            $xmlDocument = Document::newFromUri($xmlFilename, null, $loadFlags);

            try {
                if ($outputMethod == 'text') {
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

                $this->getLogger()->notice("$xmlFilename -> $outFilename");

                file_put_contents($outFilename, $output);
            } else {
                echo $output;
            }
        }

        return 0;
    }

    protected function createComment(): string
    {
        return "\n"
            . "Generated " . date('c') . " by:\n\n"
            . implode(' ', $_SERVER['argv'])
            . "\n";
    }
}
