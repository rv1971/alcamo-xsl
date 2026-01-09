<?php

namespace alcamo\xsl;

use alcamo\dom\extended\{Document, Element};
use alcamo\exception\ErrorHandler;

/**
 * @brief Extension of the built-in XSLTProcessor
 *
 * @date Last reviewed 2026-01-09
 */
class XsltProcessor extends \XSLTProcessor
{
    /// Factory class to use in newFromStylesheetUri()
    public const DOCUMENT_FACTORY_CLASS =
        Document::DEFAULT_DOCUMENT_FACTORY_CLASS;

    /// PHP functions to register, default all
    public const PHP_FUNCTIONS = null;

    private $stylesheet_; ///< ?Document
    private $output_;     ///< ?Element

    /// Create from the URI of a stylesheet
    public static function newFromStylesheetUri(string $uri): self
    {
        $factoryClass = static::DOCUMENT_FACTORY_CLASS;
        $documentClass = $factoryClass::DEFAULT_DOCUMENT_CLASS;

        return static::newFromStylesheet(
            (new $factoryClass())->createFromUri($uri, $documentClass)
        );
    }

    /// Create from a stylesheet document
    public static function newFromStylesheet(Document $stylesheet): self
    {
        $xsltProcessor = new static();

        try {
            $xsltProcessor->importStyleSheet($stylesheet);
        } catch (\Throwable $e) {
            throw XsltException::newFromPrevious($e);
        }

        return $xsltProcessor;
    }

    /// Underlying stylesheet, if any
    public function getStylesheet(): ?Document
    {
        return $this->stylesheet_;
    }

    /// First <xsl:output> element, if any
    public function getOutput(): ?Element
    {
        if ($this->output_ === false) {
            if(isset($this->stylesheet_)) {
                $this->output_ =
                    $this->stylesheet_->query('/*/xsl:output[1]')[0];
            } else {
                $this->output_ = null;
            }
        }

        return $this->output_;
    }

    /**
     * In addition to importing the stylesheet, register the PHP functions
     * defined in alcamo::xsl::XsltProcessor::PHP_FUNCTIONS.
     */
    public function importStylesheet($stylesheet): bool
    {
        $errorHandler = new ErrorHandler();

        $this->stylesheet_ = $stylesheet;
        $this->output_ = false;

        $result = parent::importStylesheet($stylesheet);

        if (static::PHP_FUNCTIONS !== null) {
            $this->registerPHPFunctions(static::PHP_FUNCTIONS);
        } else {
            $this->registerPHPFunctions();
        }

        return $result;
    }
}
