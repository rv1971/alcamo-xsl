<?php

namespace alcamo\xsl;

use Ramsey\Uuid\Uuid;

/// Create a uuid
function uuid(): string
{
    return Uuid::uuid4();
}

/// Line number of argument node
function getLineNo($nodes): int
{
    return $nodes[0]->getLineNo();
}

/**
 * @brief Unparsed text read from URI supplied as argument
 *
 * Inspired by the XST 2.0 function
 * [unparsed-text](https://www.w3.org/TR/xslt20/#unparsed-text)
 */
function unparsedText($uri): string
{
    return file_get_contents($uri);
}

/**
 * @brief Global functions for use in XSL stylesheets
 *
 * This interface does nothing but is used to trigger inclusion of this file
 * so that the global functions here become available.
 *
 * @date Last reviewed 2026-03-11
 */
interface XslFunctionsInterface
{
}
