<?php

function myfunc(string $prefix, string $text): string
{
    return "**$prefix" . strtoupper($text) . "**";
}
