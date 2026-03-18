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
 * [unparsed-text](https://www.w3.org/TR/xslt20/#unparse-d-text)
 *
 * Regarding URL resolution, the parameters $uri and $context work exactly as
 * the parameters of the XSLT document() function.
 */
function unparsedText($uri, $context = null): string
{
    if (is_array($uri)) {
        $uri = $uri[0]->resolveUri($uri[0]->textContent);
    }

    if (isset($context)) {
        $uri = $context[0]->resolveUri($uri);
    }

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
