<?php

namespace alcamo\xsl;

use alcamo\exception\AbstractDataException;

/**
 * @brief Exception thrown when XSLTProcessor::transformTo*() fails
 */
class XsltException extends AbstractDataException
{
    public const NORMALIZED_MESSAGE = 'XSLT processing failed';
}
