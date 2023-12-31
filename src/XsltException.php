<?php

namespace alcamo\xsl;

use alcamo\exception\AbstractDataException;

/**
 * @brief Exception to be thrown when XSLTProcessor::transformTo*() fails
 */
class XsltException extends AbstractDataException
{
    public const NORMALIZED_MESSAGE = 'XSLT processing failed';
}
